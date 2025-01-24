import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:multiapp/common/widgets/containers/rounded_container.dart';
import 'package:multiapp/common/widgets/loaders/animation_loader.dart';
import 'package:multiapp/features/shop/controllers/products/order_controller.dart';
import 'package:multiapp/features/shop/screens/order/widgets/order_items.dart';
import 'package:multiapp/navigation_menu.dart';
import 'package:multiapp/utils/constants/colors.dart';
import 'package:multiapp/utils/constants/image_strings.dart';
import 'package:multiapp/utils/constants/sizes.dart';
import 'package:multiapp/utils/helpers/cloud_helper_functions.dart';
import 'package:multiapp/utils/helpers/helper_functions.dart';

class MOrderListItems extends StatelessWidget {
  const MOrderListItems({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = Get.put(OrderController());

    return FutureBuilder(
      future: controller.fetchOrders(),
      builder: (_, snapshot) {
        //Nothing found widget
        final emptyWidget = MAnimationLoaderWidget(
          text: 'Whoops! No Order Yet.',
          animation: MImages.pencilAnimation,
          showAction: true,
          actionText: 'Let\'s fill it',
          onActionPressed: () =>
              Get.off(() => const NavigationMenu()),
        );

        final response = MCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot, nothingFound: emptyWidget);
        if(response != null) return response;

        //Congrats record found
        final orders = snapshot.data!;
        return ListView.separated(
          shrinkWrap: true,
          itemCount: orders.length,
          separatorBuilder: (_, __) => const SizedBox(height: MSizes.spaceBtwItems),
          itemBuilder: (_, index) {
            final order= orders[index];
            return  MRoundedContainer(
              showBorder: true,
              padding: const EdgeInsets.all(MSizes.md),
              backgroundColor: dark ? MColors.dark : MColors.light,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      //Icon
                      const Icon(Iconsax.ship),
                      const SizedBox(width: MSizes.spaceBtwItems /2),
            
                      //Status & Date
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${order.companyName}  -  ${order.orderStatusText}", 
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyLarge!.apply(color: MColors.primary, fontWeightDelta: 1)),
                            Text(order.formattedOrderDate, style: Theme.of(context).textTheme.headlineSmall),
                          ],
                        ),
                      ),
            
                      //Icon
                      IconButton(onPressed: () => Get.to(() => MOrderItems(order :order)), icon: const Icon(Iconsax.arrow_right_34, size: MSizes.iconSm))
                    ],
                  ),
                  const SizedBox(height: MSizes.spaceBtwItems),
            
                  Row(
                    children: [
                      //Status & Date
                      Expanded(
                        child: Row(
                          children: [
                            //Icon
                            const Icon(Iconsax.tag),
                            const SizedBox(width: MSizes.spaceBtwItems /2),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Text('Order  (${order.defaultPricing})', style: Theme.of(context).textTheme.labelMedium),
                                  Text(order.id, style: Theme.of(context).textTheme.titleMedium),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
            
                      Expanded(
                        child: Row(
                          children: [
                            //Icon
                            const Icon(Iconsax.money),
                            const SizedBox(width: MSizes.spaceBtwItems /2),
            
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('INV Amount', style: Theme.of(context).textTheme.labelMedium),
                                  Text(order.totalAmount.toString(), style: Theme.of(context).textTheme.titleMedium),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        );
      }
    );
  }
}