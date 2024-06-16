import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';
import '../curved_edges/curved_edges_widget.dart';
import 'circular_container.dart';

class FVPrimaryHeaderContainer extends StatelessWidget {
  const FVPrimaryHeaderContainer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FVCurvedEdgeWidget(
      child: Container(
        color: FVColors.gold,
        child: Stack(
          children: [
            Positioned(
              top: -150,
              right: -250,
              child: FVCircularContainer(
                backgroundColor: FVColors.textWhite.withOpacity(0.1),
              ),
            ),
            Positioned(
              top: 100,
              right: -300,
              child: FVCircularContainer(
                backgroundColor: FVColors.textWhite.withOpacity(0.1),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
