import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fvapp/utils/helpers/helper_function.dart';

import '../../../../../common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';

class FVProductImageSlider extends StatefulWidget {
  final String packageId;

  const FVProductImageSlider({
    required this.packageId,
    Key? key,
  }) : super(key: key);

  @override
  _FVProductImageSliderState createState() => _FVProductImageSliderState();
}

class _FVProductImageSliderState extends State<FVProductImageSlider> {
  List<String> imageUrls = [];
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    print('Package ID: ${widget.packageId}');
    _fetchImages();
  }

  Future<void> _fetchImages() async {
    if (widget.packageId.isEmpty) {
      print('Error: Package ID is empty');
      return;
    }

    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('packages')
          .doc(widget.packageId)
          .get();

      if (documentSnapshot.exists) {
        var data = documentSnapshot.data() as Map<String, dynamic>;
        List<dynamic> urls = data['imageUrls'];
        setState(() {
          imageUrls = urls.cast<String>();
        });
        print('Fetched image URLs: $imageUrls'); // Log untuk debugging
      } else {
        print('No image URLs found.'); // Log jika tidak ada data gambar
      }
    } catch (e) {
      print('Error fetching image URLs: $e'); // Log jika terjadi error
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = FVHelperFunctions.isDarkMode(context);

    return FVCurvedEdgeWidget(
      child: Container(
        color: dark ? FVColors.darkerGrey : FVColors.light,
        child: Stack(
          children: [
            // Main large image
            SizedBox(
              height: 400,
              child: Padding(
                padding: const EdgeInsets.all(FVSizes.productImageRadius * 2),
                child: Center(
                  child: selectedIndex < imageUrls.length
                      ? GestureDetector(
                          onTap: () {
                            _showFullImage(context, imageUrls[selectedIndex]);
                          },
                          child: Image.network(
                            imageUrls[selectedIndex],
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Text('Failed to load image'); // Menampilkan pesan jika gagal memuat gambar
                            },
                          ),
                        )
                      : Container(
                          child: Text('No image available'), // Menampilkan pesan jika tidak ada gambar
                        ),
                ),
              ),
            ),
            // Image slider
            Positioned(
              right: 0,
              bottom: 30,
              left: FVSizes.defaultSpace,
              child: SizedBox(
                height: 100,
                child: ListView.separated(
                  itemCount: imageUrls.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: const AlwaysScrollableScrollPhysics(),
                  separatorBuilder: (_, __) => const SizedBox(width: FVSizes.spaceBtwItems),
                  itemBuilder: (_, index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          border: Border.all(color: FVColors.gold),
                          borderRadius: BorderRadius.circular(10), // Adjust border radius as needed
                          image: DecorationImage(
                            image: NetworkImage(imageUrls[index]),
                            fit: BoxFit.cover,
                            onError: (error, stackTrace) {
                              print('Error loading image: $error'); // Log error jika terjadi masalah
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFullImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }
}
