import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class PackageBox extends StatelessWidget {
  final String image;
  final String name;

  const PackageBox({
    Key? key,
    required this.image,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: 100,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.error);
            },
          ),
          const SizedBox(height: 8),
          Text(name, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}