import 'package:get/get.dart';
import 'package:multiapp/data/repositories/authentication/authentication_repository.dart';
import 'package:multiapp/features/shop/controllers/products/cart_controller.dart';
import 'package:multiapp/features/shop/models/product_model.dart';
import 'package:multiapp/features/shop/models/product_packing_price.dart';

class VariationController extends GetxController {
  static VariationController get instance => Get.find();

  //Variables
  RxMap selectedAttributes = {}.obs;
  RxString selectedAttribute = ''.obs;
  RxString variationStockStatus = ''.obs;
  Rx<ProductPackingPrice> selectedVariation = ProductPackingPrice.empty().obs;

  //Select attribute and variation
  //product details, color/size,green/43  ///product details,unit, price
  void onAttributeSelected(
      ProductModels product, attributeName, attributeValue) {
    final selectedAttribute = attributeName.toString();

    // Find the selected variation
    final selectedVariation = product.quantityPrice!.firstWhere(
      (variation) =>
          variation.bulkPackUnit == attributeName &&
          _isSameAttributeValues(variation.bulkPackUnit!, selectedAttribute),
      orElse: () => ProductPackingPrice.empty(),
    );

    //Show selected variation quantity already in the cart
    if (selectedVariation.itmCode != null &&
        selectedVariation.itmCode!.isNotEmpty) {
      final cartController = CartController.instance;
      cartController.productQuantityInCart.value =
          cartController.getVariationQuantityInCart(
              product.itmCode, selectedVariation.bulkPackUnit!);
    }
    getProductVariationStockStatus(product, selectedVariation.basePackQty);
    // Assign selected variation
    this.selectedVariation.value = selectedVariation;
  }

  //Check if slected attributes matches any variation attributes
  bool _isSameAttributeValues(
      String variationAttributes, String selectedAttributes) {
    // Split the attributes into lists of words
    List<String> variationWords = variationAttributes.split(' ');
    List<String> selectedWords = selectedAttributes.split(' ');

    // Check if each word in variationWords is contained in selectedWords
    for (var word in variationWords) {
      if (!selectedWords.contains(word)) {
        return false; // Return false if any word is not found
      }
    }
    return true;
  }

  Set<String?> getAttributesAvailabilityInVariation(
      List<ProductPackingPrice> variations, String attributeName) {
    // Pass the variations to check which attributes are available and stock is not 0
    final availableVariationAttributeValues = variations
        .where((variation) =>
            // Check for non-null, non-empty attributes and stock greater than 0
            variation.bulkPackUnit != null &&
            variation.bulkPackUnit!.isNotEmpty)
        // Fetch all non-empty attributes of variations
        .map((variation) => variation.bulkPackUnit)
        .toSet();

    return availableVariationAttributeValues;
  }

  String getVariationPrice(ProductModels product) {
    final isRsp = AuthenticationRepository.instance.isRetailPrice.value; // Accessing .value for RxBool
    // print("Rsp ${product.rspIncVat}, bulkPackUPrice ${selectedVariation.value.bulkPackUPrice}, basePackQty ${selectedVariation.value.basePackQty!} " );
    return isRsp
        ? (product.rspIncVat * selectedVariation.value.basePackQty!).toString()
        : selectedVariation.value.bulkPackUPrice.toString();
  }


  //Check product variation stock status
  void getProductVariationStockStatus(product, variationQty) {
    final selectedProductQty = product.currBalance;
    final stock = selectedProductQty - variationQty;
    variationStockStatus.value = stock >= 0 ? 'In Stock' : 'Out of Stock';
  }

  String getProductStockStatus(int stock) {
    return stock > 0 ? 'In Stock' : 'Out of Stock';
  }

  //Reset selected attributes when switching products
  void resetSelectedAttributes() {
    selectedAttributes.clear();
    variationStockStatus.value = '';
    selectedVariation.value = ProductPackingPrice.empty();
  }
}
