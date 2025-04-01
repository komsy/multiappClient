import 'dart:async';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:easyapp/features/shop/controllers/products/cart_controller.dart';
import 'package:easyapp/utils/constants/sizes.dart';
import 'package:easyapp/utils/helpers/helper_functions.dart';
import '../../../../../common/widgets/icons/m_circular_icon.dart';
import '../../../../../utils/constants/colors.dart';

class MProductQuantityWithAddRemoveButton extends StatefulWidget {
  final int quantity;
  final VoidCallback? add, remove;
  final Function(int) update;
  final dynamic item;

  const MProductQuantityWithAddRemoveButton({
    super.key,
    required this.quantity,
    required this.update,
    required this.item,
    this.add,
    this.remove,
  });

  @override
  MProductQuantityWithAddRemoveButtonState createState() =>
      MProductQuantityWithAddRemoveButtonState();
}

class MProductQuantityWithAddRemoveButtonState
    extends State<MProductQuantityWithAddRemoveButton> {
  late TextEditingController _controller;
  Timer? _debounce;
  final cartController = CartController.instance;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.quantity.toString());
  }

  @override
  void didUpdateWidget(covariant MProductQuantityWithAddRemoveButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.quantity != widget.quantity) {
      _controller.text = widget.quantity.toString(); // Update text when quantity changes
    }
  }

  void _onChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel(); // Cancel previous timer

    _debounce = Timer(const Duration(seconds: 1), () {
      int? newQuantity = int.tryParse(value);
      if (newQuantity != null && newQuantity > 0) {
        widget.update(newQuantity);
      } else {
        _controller.text = widget.quantity.toString(); // Reset if invalid
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        MCircularIcon(
          icon: Iconsax.minus,
          width: 32,
          height: 32,
          size: MSizes.md,
          onPressed: () {
            widget.remove?.call(); // Call remove function
            setState(() {
              _controller.text = (int.parse(_controller.text) - 1).toString();
            });
          },
          color: dark ? MColors.white : MColors.black,
          backgroundColor: dark ? MColors.darkGrey : MColors.light,
        ),
        const SizedBox(width: MSizes.spaceBtwItems * 2),

        // Editable quantity input
        SizedBox(
          width: 70,
          child: TextField(
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            controller: _controller,
            onChanged: _onChanged,
            style: Theme.of(context).textTheme.titleSmall,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 5), // Adjust padding
              isDense: true, // Reduces default height
              border: OutlineInputBorder( // Optional: Adds a border
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),


        const SizedBox(width: MSizes.spaceBtwItems * 2),

        MCircularIcon(
          icon: Iconsax.add,
          backgroundColor: MColors.primary,
          width: 32,
          height: 32,
          size: MSizes.md,
          color: MColors.white,
          onPressed: () {
            widget.add?.call(); // Call add function
            setState(() {
              _controller.text = (int.parse(_controller.text) + 1).toString();
            });
          },
        ),
      ],
    );
  }
}
