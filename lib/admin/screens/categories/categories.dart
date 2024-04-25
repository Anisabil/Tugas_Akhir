import 'package:flutter/material.dart';
import 'package:fvapp/admin/components/box_information.dart';
import '../../../utils/constants/enums.dart';
import '../../../utils/constants/sizes.dart';
import '../../components/box_layout.dart';

class SettingCategories extends StatelessWidget {
  const SettingCategories({
    super.key,
    this.brandTextSize = TextSizes.small,
  });

  final TextSizes brandTextSize;

  @override
  Widget build(BuildContext context) {

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.all(FVSizes.defaultSpace),
          child: Column(
            children: [
              FVBoxLayout(
                itemCount: 4,
                itemBuilder: (_, index) => const BoxInformation(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


