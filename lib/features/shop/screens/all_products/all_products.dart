import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiapp/common/widgets/appbar/appbar.dart';
import 'package:multiapp/common/widgets/shimmers/vertical_product_shimmer.dart';
import 'package:multiapp/features/shop/controllers/products/product_controller.dart';
import 'package:multiapp/features/shop/models/product_model.dart';
import 'package:multiapp/utils/constants/sizes.dart';

import '../../../../common/widgets/products/sortable/sortable_products.dart';

class AllProducts extends StatelessWidget {
  const AllProducts({super.key, required this.title, this.futureMethod});

  final String title;
  final Future<List<ProductModels>>? futureMethod;

  @override
  Widget build(BuildContext context) {
    // final controller = Get.put(AllProductsController());
  final controller = ProductController.instance;
    
    return Scaffold(
      appBar: MAppBar(title: Text(title), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(MSizes.defaultSpace/2),
          child:  Obx((){
                    if(controller.isLoading.value) return const MVerticalProductShimmer();

                    if(controller.featuredProducts.isEmpty){
                      return Center(child: Text('No Data Found!', style: Theme.of(context).textTheme.bodyMedium));
                    }
                    final products = controller.featuredProducts;
                    return MSortableProducts(products: products);
                    // return MGridLayout(
                    //   itemCount: controller.featuredProducts.length,
                    //   itemBuilder: (_,index) =>  MProductCardVertical(product: controller.featuredProducts[index]),
                    // );
                   }),
          // child: FutureBuilder(
          //   future: futureMethod ?? controller.fetchProductsByQuery(query),
          //   builder: (context, snapshot) {
          //     //Check the state of the FutureBuilder snapshot
          //     const loader = MVerticalProductShimmer();

          //     print(snapshot.data);

          //     // final widget = MCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot, loader: loader);

          //     // ///Return appropriate widget based on snapshot state
          //     // if (widget !=null) return widget;

          //     // if(snapshot.connectionState == ConnectionState.waiting) {
          //     //   return loader;
          //     // }
          //     // if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
          //     //   return const Center(child: Text('No Data Found!'));
          //     // }
          //     // if (snapshot.hasError) {}
          //       return const Center(child: Text('Something went wrong getting all products'));
              

          //     //Products found!
          //     // final products = snapshot.data!;
              //  return MSortableProducts(products: products);
          //   }
          // ),
        ),
      ),
    );
  }
}
