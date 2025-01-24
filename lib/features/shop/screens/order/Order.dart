import 'package:flutter/material.dart';
import 'package:multiapp/common/widgets/appbar/appbar.dart';
import 'package:multiapp/features/shop/screens/order/widgets/orders_list.dart';
import 'package:multiapp/utils/constants/sizes.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MAppBar(title: Text('My Orders', style: Theme.of(context).textTheme.headlineSmall), showBackArrow: false),
      body: const Padding(
        padding: EdgeInsets.all(MSizes.defaultSpace),

        //Orders
        child: MOrderListItems(),
      )
    );
  }
}