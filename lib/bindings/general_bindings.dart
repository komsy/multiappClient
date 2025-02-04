import 'package:get/get.dart';
import 'package:easyapp/features/shop/controllers/products/variation_controller.dart';
import 'package:easyapp/utils/helpers/network_manager.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkManager());
    Get.put(VariationController());
  }
}