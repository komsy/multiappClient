import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiapp/common/widgets/custom_shapes/containers/primary_header_containers.dart';
import 'package:multiapp/common/widgets/shimmers/vertical_product_shimmer.dart';
import 'package:multiapp/common/widgets/texts/section_heading.dart';
import 'package:multiapp/features/shop/controllers/customer_controller.dart';
import 'package:multiapp/features/shop/controllers/products/product_controller.dart';
import 'package:multiapp/features/shop/screens/home/widgets/home_appbar.dart';

import '../../../../common/widgets/containers/search_container.dart';
import '../../../../common/widgets/layouts/grid_layout.dart';
import '../../../../common/widgets/products/product_cards/product_card_vertical.dart';
import '../../../../utils/constants/sizes.dart';
import '../all_products/all_products.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {  
    final controller = Get.put(ProductController());
    Get.put(CustomerController()); //To review the customer data from the controller
    return  Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
           MPrimaryHeaderContainer(
              child: Column(
                children: [
                   const MHomeAppBar(),                  
                   const SizedBox(height: MSizes.spaceBtwSections/2),

                  //SearchBar
                  MSearchContainer(
                    text: "Search in Store",
                    onChanged: (String keyWord) async {
                      controller.fetchSearchProduct(
                          keyWord); // Pass a dynamic callback
                    },
                  ),
                   const SizedBox(height: MSizes.spaceBtwSections*1.5),

                  //Categories
                  // Padding(
                  //   padding:  const EdgeInsets.only(left: MSizes.defaultSpace),
                  //   child: Column(
                  //     children: [
                  //       //Heading
                  //        MSectionHeading(title: 'Popular Categories', textColor: Colors.white,showActionButton: false, onPressed: () {},),
                  //        const SizedBox(height: MSizes.spaceBtwItems),

                  //       //Categories
                  //       const MHomeCategories()
                  //     ],
                  //   ),
                  // ),

                  // const SizedBox(height: MSizes.spaceBtwSections),
                ],
              ),
            ),

            //Body
             Padding(
              padding: const EdgeInsets.all(MSizes.defaultSpace/2.5),
              child:  Column(
                children: [
                  // const MPromoSlider(),
                  // const SizedBox(height: MSizes.spaceBtwSections),

                  //Heading
                  MSectionHeading(title: 'Popular Products', showActionButton: false,
                  onPressed: () {}
                  //  => Get.to(() =>  const AllProducts(
                  //   title: 'All Products',
                  //   // query: FirebaseFirestore.instance.collection('Products').where('IsFeatured',isEqualTo: true).limit(6),
                  //   // futureMethod: controller.fetchFeaturedProducts(),
                  //   )),
                  ),
                  const SizedBox(height: MSizes.spaceBtwItems),
                  
                  //Popular Products 
                  Obx((){
                    if(controller.isLoading.value) return const MVerticalProductShimmer();

                    if(controller.featuredProducts.isEmpty){
                      return Center(child: Text('No Data Found!', style: Theme.of(context).textTheme.bodyMedium));
                    }
                    return MGridLayout(
                      itemCount: controller.featuredProducts.length,
                      itemBuilder: (_,index) =>  MProductCardVertical(product: controller.featuredProducts[index]),
                    );
                   })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
