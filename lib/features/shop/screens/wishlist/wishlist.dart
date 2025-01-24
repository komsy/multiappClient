import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:multiapp/common/widgets/appbar/appbar.dart';
import 'package:multiapp/common/widgets/icons/m_circular_icon.dart';
import 'package:multiapp/common/widgets/layouts/grid_layout.dart';
import 'package:multiapp/common/widgets/loaders/animation_loader.dart';
import 'package:multiapp/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:multiapp/common/widgets/shimmers/vertical_product_shimmer.dart';
import 'package:multiapp/features/shop/controllers/products/favourites_controller.dart';
import 'package:multiapp/features/shop/controllers/products/product_controller.dart';
import 'package:multiapp/features/shop/screens/home/home.dart';
import 'package:multiapp/navigation_menu.dart';
import 'package:multiapp/utils/constants/image_strings.dart';
import 'package:multiapp/utils/constants/sizes.dart';
import 'package:multiapp/utils/helpers/cloud_helper_functions.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final controller = FavouritesController.instance;
    final controller = ProductController.instance;
   //  final controller = Get.put(FavouritesController());

    return Scaffold(
      appBar: MAppBar(
        title:
            Text('Productlist', style: Theme.of(context).textTheme.headlineMedium),
        actions: [
          MCircularIcon(
              icon: Iconsax.add, onPressed: () => Get.to(const HomeScreen()))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(MSizes.defaultSpace),
            child: 
            Obx((){
                    if(controller.isLoading.value) return const MVerticalProductShimmer();

                    if(controller.featuredProducts.isEmpty){
                      return MAnimationLoaderWidget(
                        text: 'Whoops! Productlist is Empty...',
                        animation: MImages.pencilAnimation,
                        showAction: true,
                        actionText: 'Let\'s add some',
                        onActionPressed: () =>
                            Get.off(() => const NavigationMenu()),
                      ); 
                      // return Center(child: Text('No Data Found!', style: Theme.of(context).textTheme.bodyMedium));
                    }
                    return MGridLayout(
                      itemCount: controller.featuredProducts.length,
                      itemBuilder: (_,index) =>  MProductCardVertical(product: controller.featuredProducts[index]),
                    );
                   })
          ),
      ),
    );
  }
}
