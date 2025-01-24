import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:multiapp/common/widgets/layouts/grid_layout.dart';
import 'package:multiapp/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:multiapp/features/shop/controllers/products/all_products_controller.dart';
import 'package:multiapp/features/shop/models/product_model.dart';
import 'package:multiapp/utils/constants/sizes.dart';

class MSortableProducts extends StatelessWidget {
  const MSortableProducts({
    super.key, required this.products,
  });

  final List<ProductModels> products;
  
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AllProductsController());
    controller.assignProducts(products);

    return Column(
      children: [
        //SearchBar row
            // Expanded(
            //   child: MSearchContainer(
            //     text: "Search in Store",
            //     onChanged: (String keyWord) async {
            //       // controller.fetchSearchProduct(
            //       //     keyWord); // Pass a dynamic callback
            //     },
            //   ),
            // ),
            //Dropdown
            // SizedBox(
            //     width: 150,
            //     child: DropdownButtonFormField(
            //       // decoration: const InputDecoration(prefixIcon: Icon(Iconsax.sort)),
            //       value: controller.selectedSortOption.value,
            //       onChanged: (value){
            //         //Sort products based on the selected option
            //         controller.sortProducts(value!);
            //       },
            //       items: ['Name', 'Higher Price', 'Lower Price']
            //           .map((option) => DropdownMenuItem(value: option, child: Text(option)))
            //           .toList(),
            //     ),
            //   ),
        //Dropdown
        DropdownButtonFormField(
          decoration: const InputDecoration(prefixIcon: Icon(Iconsax.sort)),
          value: controller.selectedSortOption.value,
          onChanged: (value){
            //Sort products based on the selected option
            controller.sortProducts(value!);
          },
          items: ['Name', 'Higher Price', 'Lower Price']
              .map((option) => DropdownMenuItem(value: option, child: Text(option)))
              .toList(),
        ),
        const SizedBox(height: MSizes.spaceBtwSections),
    
        //Products
        Obx(() => MGridLayout(
          itemCount: controller.products.length, 
          itemBuilder: (_,index) => MProductCardVertical(product: controller.products[index]))
        ),
      ],
    );
  }
}