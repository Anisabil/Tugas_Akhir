import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CategoryBox extends StatelessWidget {
  final String imageUrl; // Ubah dari IconData menjadi String
  final String text;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CategoryBox({
    Key? key,
    required this.imageUrl, // Ganti parameter icon dengan imageUrl
    required this.text,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(imageUrl, width: 40, height: 40), // Gunakan Image.network untuk menampilkan gambar dari URL
            const SizedBox(height: 8),
            Text(text, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Iconsax.edit),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: Icon(Iconsax.trash),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
