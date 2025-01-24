import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:multiapp/utils/constants/sizes.dart';

class MProfileMenu extends StatelessWidget {
  const MProfileMenu({
    super.key, this.showIcon = true, this.icon=Iconsax.arrow_right_34, required this.onPressed, required this.title, required this.value,
  });

  final bool showIcon;
  final IconData icon;
  final VoidCallback onPressed;
  final String title,value;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical:  MSizes.spaceBtwItems / 1.5),
        child: Row(
          children: [
            Expanded(flex:2, child: Text(title, style: Theme.of(context).textTheme.bodySmall, overflow: TextOverflow.ellipsis)),
            Expanded(flex:5, child: Text(value, style: Theme.of(context).textTheme.bodyMedium, overflow: TextOverflow.ellipsis)),
            showIcon ? Expanded(child: Icon(icon, size: 18)) : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}