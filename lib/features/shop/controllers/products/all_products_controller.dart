
import 'package:get/get.dart';
import 'package:multiapp/data/repositories/authentication/authentication_repository.dart';
import 'package:multiapp/features/shop/controllers/products/product_controller.dart';
import 'package:multiapp/features/shop/models/product_model.dart';

class AllProductsController extends GetxController {
  static AllProductsController get instance => Get.find();

  final repository = [];// ProductRepository.instance;
  final controller = ProductController.instance;
  final RxString selectedSortOption = 'Name'.obs;
  final RxList<ProductModels> products = <ProductModels>[].obs;


  void sortProducts (String sortOption) {
    selectedSortOption.value = sortOption;
    final isQuantityPrice = AuthenticationRepository.instance.isQuantityPrice;

    switch (sortOption){
      case 'Name' :
        products.sort((a,b) => a.longName.compareTo(b.longName));
      break;
      case 'Higher Price' :
        products.sort((a,b) => b.rspIncVat.compareTo(a.rspIncVat));
      break;
      case 'Lower Price' :
        products.sort((a,b) => a.rspIncVat.compareTo(b.rspIncVat));
      break;
      // case 'Newest' :
      //   products.sort((a,b) => a.date!.compareTo(b.date!));
      // break;
      // case 'Sale' :
      //   products.sort((a,b) {
      //     if (b.rspIncVat > 0){
      //       return b.rspIncVat.compareTo(b.rspIncVat);
      //     } else if (a.rspIncVat > 0) {
      //       return -1;
      //     } else {
      //       return 1;
      //     }
      // });
      // break;
    default:
    products.sort((a,b) => a.longName.compareTo(b.longName));
    }
  }

  void assignProducts(List<ProductModels> products){
    //Assign products to the 'Products' list
    this.products.assignAll(products);
    sortProducts('Name');
  }

}