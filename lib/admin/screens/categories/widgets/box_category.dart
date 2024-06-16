import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CategoryBox extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CategoryBox({
    Key? key,
    required this.icon,
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
            Icon(icon, size: 40),
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