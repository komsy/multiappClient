import 'package:flutter/material.dart';
import 'package:multiapp/common/widgets/texts/product_title_text.dart';
import 'package:multiapp/features/shop/models/customer_model.dart';

class MCustomerMenuTile extends StatelessWidget {
  const MCustomerMenuTile(
      {super.key,this.onTap, required this.customer});

  final VoidCallback? onTap;
  final CustomerModel customer;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // leading: MProductTitletext(title: customer.cusCode, smallSize: true),
      title: MProductTitletext(title: customer.companyName, smallSize: true), 
      trailing: Text("${customer.crLimit}  ${customer.currBalance.toString()}",style: Theme.of(context).textTheme.titleSmall),
      onTap: onTap,
    );
  }
}