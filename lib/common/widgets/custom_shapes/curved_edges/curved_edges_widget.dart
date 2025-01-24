import 'package:flutter/material.dart';
import 'package:multiapp/common/widgets/custom_shapes/curved_edges/curved_edges.dart';

class MCurvedEdgeWidget extends StatelessWidget {
  const MCurvedEdgeWidget({
    super.key, this.child,
  });
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MCustomCurvedEdges(),
      child: child
    );
  }
}
