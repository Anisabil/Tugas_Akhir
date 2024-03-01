import 'package:flutter/material.dart';
import 'package:fvapp/common/widgets/custom_shapes/curved_edges/curved_edges.dart';

class FVCurvedEdgeWidget extends StatelessWidget {
  const FVCurvedEdgeWidget({
    super.key, required this.child,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: FVCustomCurvedEdges(),
      child: child,
    );
  }
}

