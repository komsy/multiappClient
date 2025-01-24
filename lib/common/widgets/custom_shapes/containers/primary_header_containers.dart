import 'package:flutter/material.dart';
import 'package:multiapp/common/widgets/custom_shapes/containers/circular_container.dart';
import 'package:multiapp/common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import 'package:multiapp/utils/constants/colors.dart';

class MPrimaryHeaderContainer extends StatelessWidget {
  const MPrimaryHeaderContainer({
    super.key, required this.child,
  });

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return MCurvedEdgeWidget(
     child: Container(
       color: MColors.primary,
      //  padding: const EdgeInsets.all(0),
      //  child: SizedBox(
      //    height: 400,
         child: Stack(
           children: [
             Positioned(top: -150, right: -250, child: MCircularContainer(backgroundColor: MColors.textWhite.withOpacity(0.1))),
             Positioned(top: 100, right: -300, child: MCircularContainer(backgroundColor: MColors.textWhite.withOpacity(0.1))),
             child,
           ],
         ),
       ),
    //  ),
    );
  }
}
