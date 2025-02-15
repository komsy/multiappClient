import 'package:easyapp/common/widgets/custom_shapes/containers/primary_header_containers.dart';
import 'package:easyapp/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:easyapp/common/widgets/appbar/appbar.dart';
import 'package:easyapp/features/shop/screens/order/widgets/orders_list.dart';
import 'package:easyapp/utils/constants/sizes.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: MAppBar(title: Text('My Orders', style: Theme.of(context).textTheme.headlineSmall), showBackArrow: false),
      body: SingleChildScrollView(
        // padding: const EdgeInsets.all(MSizes.defaultSpace),

        //Orders
        child: Column(
          children: [
            MPrimaryHeaderContainer(
              child: Column(
                children: [
                  // MAppBar(title: Text('Account', style: Theme.of(context).textTheme.headlineMedium!.apply(color: MColors.white),),),
                  MAppBar(title: Text('My Orders', style: Theme.of(context).textTheme.headlineSmall!.apply(color: MColors.white)), showBackArrow: false),
                  //User profile card
                  const SizedBox(height: MSizes.spaceBtwSections),
                ],
              )
            ),


            Transform.translate(
              offset: const Offset(0, -25), // Shift content 10 pixels upward
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: MSizes.defaultSpace/1.5),
                child: Row(
                  children: [
                    Expanded(child: MOrderListItems()),
                    SizedBox(height: MSizes.spaceBtwSections),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}