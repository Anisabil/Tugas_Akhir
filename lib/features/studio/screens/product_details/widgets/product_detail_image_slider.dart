import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fvapp/utils/helpers/helper_function.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import '../../../../../common/widgets/icons/fv_circular_icon.dart';
import '../../../../../common/widgets/images/fv_rounded_image.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/image_strings.dart';
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
    _fetchImages();
  }

  Future<void> _fetchImages() async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref('packages/${widget.packageId}/imageUrls');
    DataSnapshot snapshot = await ref.get();
    if (snapshot.exists) {
      List<dynamic> urls = snapshot.value as List<dynamic>;
      setState(() {
        imageUrls = urls.cast<String>();
      });
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
                          ),
                        )
                      : Container(),
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
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: FVSizes.spaceBtwItems),
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