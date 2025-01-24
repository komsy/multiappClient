import 'package:flutter/material.dart';

class MSectionHeading extends StatelessWidget {
  const MSectionHeading({
    super.key,
    this.textColor,
    required this.title,
    this.rightSideWidget,
    this.buttonTitle = 'View all',
    this.buttonTitle1 = 'Add',
    this.onPressed,
    this.onPressed1,
    this.showActionButton=true,
    this.showSecActionButton=false,
  });

  final Color? textColor;
  final Widget? rightSideWidget;
  final String title, buttonTitle, buttonTitle1;

  final bool showActionButton;
  final bool showSecActionButton;
  final void Function()? onPressed;
  final void Function()? onPressed1;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: Theme.of(context).textTheme.headlineSmall!.apply(color: textColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
        // if (rightSideWidget!= null) rightSideWidget!
        if(showActionButton) TextButton(onPressed: onPressed, child: Text(buttonTitle)),
        if(showSecActionButton) TextButton(onPressed: onPressed1, child: Text(buttonTitle1))
      ],
    );
  }
}
