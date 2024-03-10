import 'package:flutter/material.dart';

import '../../../utils/constants/sizes.dart';

class FVGridLayout extends StatelessWidget {
  const FVGridLayout({
    Key? key,
    required this.itemCount,
    this.mainAxisExtent = 288,
    required this.itemBuilder,
  }) : super(key: key);

  final int itemCount;
  final double? mainAxisExtent;
  final Widget Function(BuildContext, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: itemCount,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: mainAxisExtent!,
        mainAxisSpacing: FVSizes.gridViewSpacing,
        crossAxisSpacing: FVSizes.gridViewSpacing,
      ),
      itemBuilder: (context, index) {
        return Expanded( // Wrap each item in an Expanded widget
          child: itemBuilder(context, index),
        );
      },
    );
  }
}
