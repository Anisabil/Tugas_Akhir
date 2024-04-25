import 'package:flutter/material.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/sizes.dart';
import '../../components/box_information.dart';
import '../../components/box_layout.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({
    Key? key,
    this.brandTextSize = TextSizes.small,
  }) : super(key: key);

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
                itemBuilder: (_, index) => const BoxInformation(title: '26'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

