import 'package:flutter/material.dart';
import 'package:fvapp/admin/models/promo_model.dart';
import 'package:fvapp/admin/screens/promo/widgets/promo_form.dart';
import 'package:fvapp/admin/service/promo_service.dart';
import 'package:fvapp/utils/constants/colors.dart';

class PromoScreen extends StatelessWidget {
  const PromoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Promo Images'),
      ),
      body: StreamBuilder<List<PromoImage>>(
        stream: PromoService().getImages(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<PromoImage> promoImages = snapshot.data ?? [];

          if (promoImages.isEmpty) {
            return Center(
              child: Text('No promo images available.'),
            );
          }

          return ListView.builder(
            itemCount: promoImages.length,
            itemBuilder: (context, index) {
              PromoImage promoImage = promoImages[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PromoForm(promoImage: promoImage),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        promoImage.imageUrl,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: FVColors.gold,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PromoForm()), // Pastikan PromoForm terdapat di bawah Provider<PromoController>
          );
        },
        tooltip: 'Add Promo',
        child: Icon(Icons.add, color: FVColors.white,),
      ),
    );
  }
}
