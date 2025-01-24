import 'package:flutter/material.dart';
import 'package:multiapp/common/widgets/appbar/appbar.dart';
import 'package:multiapp/common/widgets/list_tiles/settings_menu_tile.dart';
import 'package:multiapp/features/shop/models/order_item_model.dart';
import 'package:multiapp/features/shop/models/order_model.dart';
import 'package:multiapp/utils/constants/sizes.dart';

class MOrderItems extends StatelessWidget {
  const MOrderItems({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {

    // print("order: ${order.orderItems}");
    return Scaffold(
      appBar: MAppBar(
        title: Text('Order Items', style: Theme.of(context).textTheme.headlineSmall),
        showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
            padding:const  EdgeInsets.all(MSizes.defaultSpace/3),
            //Items in order
            child: Column(
              children: 
                order.orderItems!.map((item) {
              return ListTile(
                leading: const Icon(Icons.shopping_cart),
                title: Text("${item.longName} (${item.unit})",style: Theme.of(context).textTheme.bodyMedium),
                subtitle: Text(" Vat: ${item.vatAmount.toStringAsFixed(2)}          Qty: ${item.quantity}   (${item.defaultPricing})"),
                trailing: Text(item.amount.toStringAsFixed(2),style: Theme.of(context).textTheme.bodyMedium),
                onTap: () {},
              );
            }).toList(),
              
            ),
        ),
      ),
    );
  }
}