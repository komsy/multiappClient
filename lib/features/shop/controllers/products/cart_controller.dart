import 'dart:ffi';

import 'package:get/get.dart';
import 'package:multiapp/SQLite/sqlite.dart';
import 'package:multiapp/data/repositories/authentication/authentication_repository.dart';
import 'package:multiapp/features/shop/controllers/products/product_controller.dart';
import 'package:multiapp/features/shop/controllers/products/variation_controller.dart';
import 'package:multiapp/features/shop/models/cart_item_model.dart';
import 'package:multiapp/features/shop/models/product_model.dart';
import 'package:multiapp/features/shop/models/product_packing_price.dart';
import 'package:multiapp/utils/local_storage/storage_utility.dart';
import 'package:multiapp/utils/popups/loaders.dart';

class CartController extends GetxController {
  static CartController get instance => Get.find();

  //Variables
  RxInt noOfCartItems = 0.obs;
  RxDouble totalCartPrice = 0.0.obs;
  RxDouble totalCartTax = 0.0.obs;
  RxInt productQuantityInCart = 0.obs;
  RxList<CartItemModel> cartItems = <CartItemModel>[].obs;
  final variationController = VariationController.instance;
  final LocalDatabase db = LocalDatabase.instance;

  CartController() {
    loadCartItems();
  }
  int isProductOutInStock(ProductModels product) {
    final productqty = product.currBalance;
    final productQuantityToCart = productQuantityInCart.value;
  final isQuantityPrice = AuthenticationRepository.instance.isQuantityPrice.value;
    if (!isQuantityPrice && product.quantityPrice != null && product.quantityPrice!.length > 1){
      //check which variation in cart to query the qty for the variation * the number of items in cart
      final variationUnit = variationController.selectedVariation.value.bulkPackUnit!;
      
      final cartqty =getAllProductQuantityInCart(product,variationUnit);
      
      //get selected variation qty * selected product quantity 
      final selvariationQuantity = variationController.selectedVariation.value.basePackQty!;
      final selProductQty = productQuantityToCart * selvariationQuantity;

      //get product currbalance minus cart qty
      final productStock = productqty - (cartqty+ selProductQty);
      // if (productStock < 0) return false;
      // print("product stock: $productStock");
      return productStock.toInt();
    } else {

      //get product currbalance minus cart qty
      final productStock = productqty - productQuantityToCart;
      return productStock.toInt();
    }
  }
  //Add items in the cart
  void addToCart(ProductModels product){
  final isQuantityPrice = AuthenticationRepository.instance.isQuantityPrice.value;
    //Quantity check
    if (productQuantityInCart.value < 1){
      MLoaders.customToast(message: 'Select Quantity');
      return;
    }

    // print("product ${product.longName} is ${product.locationID}");
    //Variation selected
    if (!isQuantityPrice && product.quantityPrice != null && product.quantityPrice!.length > 1 && variationController.selectedVariation.value.itmCode!.isEmpty) {
      MLoaders.customToast(message: 'Select Variation');
      return;
    }

    //Out of stock status
    final productStock =isProductOutInStock(product);

    if(productStock < 0){
    MLoaders.warningSnackBar(message: 'Product Quantity is out of stock.', title: 'Oh Snap!');
        return;
      
    } else {
      //get product currbalance minus variation qty
      if (!isQuantityPrice && product.quantityPrice != null && product.quantityPrice!.length > 1) {
        // determine variation quantity
        final variationQty = variationController.selectedVariation.value.basePackQty;
        final stock = product.currBalance - (variationQty! * productQuantityInCart.value);
        if (stock < 1) {
          MLoaders.warningSnackBar(message: 'Selected variation is out of stock.', title: 'Oh Snap!');
          return;
        }
      } else {
        if (product.currBalance < 1) {
          MLoaders.warningSnackBar(message: 'Selected product is out of stock.', title: 'Oh Snap!');
          return;
        }
      } 
    }

    //Convert the productModel to a cartItemModel with the given quantity
    final selectedCartItem = convertToCartItem(product, productQuantityInCart.value);
    // print("selectedCartItem pricing ${selectedCartItem.defaultPricing}");
    //Check if already added in the cart
    int index = cartItems.indexWhere((cartItem) => cartItem.itmCode == selectedCartItem.itmCode && cartItem.defaultPricing ==selectedCartItem.defaultPricing && cartItem.variationId == selectedCartItem.variationId);
    
    if(index >= 0){
      // print("cartitem pricing ${cartItems[index].defaultPricing}");
      //This quantity is already added or updated/removed from the design cart (-)
      cartItems[index].quantity = selectedCartItem.quantity;
    } else {
      cartItems.add(selectedCartItem);
    }

    updateCart();
    MLoaders.customToast(message: 'Your Product has been added to the Cart.');
 } 

 //Add one product to cart
 void addOneToCart(CartItemModel item) {
  int index = cartItems.indexWhere((cartItem) => cartItem.itmCode == item.itmCode && cartItem.defaultPricing ==item.defaultPricing && cartItem.variationId == item.variationId);
  //check stock qty before adding one
  // Access the ProductController instance
  final productController = ProductController.instance;
  final isQuantityPrice = AuthenticationRepository.instance.isQuantityPrice.value;

  // Find a specific product by itmCode
  final itmCode = item.itmCode; 
  final product = productController.featuredProducts.firstWhere(
    (product) => product.itmCode == itmCode,
    orElse: () => ProductModels.empty(),
  );
  
  // print("isQuantityPrice cart: ${AuthenticationRepository.instance.isQuantityPrice.value}");
  //get product currbalance minus quantity in cart
  if (index >= 0) {
    //ensure if quantity price is enabled, only add one item
     if (!isQuantityPrice && product.quantityPrice != null && product.quantityPrice!.length > 1){
      //get other product variant qty
      final cartqty =getAllProductQuantityInCart(product,item.variationId); //3
      final productQuantityToCart = cartItems[index].quantity + 1;

      //get selected variation qty * selected product quantity
      // Retrieve the quantity based on variationId from productPackagingPrice
      final productPackaging = product.quantityPrice!.firstWhere(
        (pack) => pack.bulkPackUnit == item.variationId,
        orElse: () => ProductPackingPrice.empty(),
      );
      //variation qty * cart item's variation quantity
      final ppQuantity = productPackaging.basePackQty! * productQuantityToCart;
      final productStock = product.currBalance - (cartqty + ppQuantity);

    if (productStock < 0) {
      // Show warning if out of stock
      MLoaders.warningSnackBar(message: 'Product is out of stock.', title: 'Oh Snap!');
      return;
    }
    cartItems[index].quantity += 1;
    addOneCartTax(item);
    updateCart();
    } else {
      // Calculate stock after adding one more unit
      final productStock = product.currBalance - cartItems[index].quantity;
      
      if (productStock < 1) {
        // Show warning if out of stock
        MLoaders.warningSnackBar(message: 'Product is out of stock.', title: 'Oh Snap!');
        return;
      }
      
      // Increase quantity and update cart
      cartItems[index].quantity += 1;
      addOneCartTax(item);
      updateCart();
    }
  } else {
    // Add new item to cart and update
    cartItems.add(item);
    //calculate tax and update cart
    updateCart();
  }
 }
 
 void addOneCartTax(CartItemModel item) {
  int index = cartItems.indexWhere((cartItem) => cartItem.itmCode == item.itmCode && cartItem.defaultPricing ==item.defaultPricing && cartItem.variationId == item.variationId);
  if (cartItems[index].vatRate > 0){
    final taxAmount =cartItems[index].quantity * ((cartItems[index].vatRate  * cartItems[index].price) / (cartItems[index].vatRate + 100));
    final exVat =(cartItems[index].quantity * cartItems[index].price) - taxAmount;
    cartItems[index].taxAmount = double.parse(taxAmount.toStringAsFixed(2));
    cartItems[index].exVat = double.parse(exVat.toStringAsFixed(2));
  }
 }

  void removeOneCartTax(CartItemModel item) {
  int index = cartItems.indexWhere((cartItem) => cartItem.itmCode == item.itmCode && cartItem.defaultPricing ==item.defaultPricing && cartItem.variationId == item.variationId);
  if (cartItems[index].vatRate > 0){
    final taxAmount =cartItems[index].quantity * ((cartItems[index].vatRate  * cartItems[index].price) / (cartItems[index].vatRate + 100));
    cartItems[index].taxAmount = double.parse(taxAmount.toStringAsFixed(2));
  }
 }
 //remove one product to cart
  void removeOneToCart(CartItemModel item) {
    int index = cartItems.indexWhere((cartItem) => cartItem.itmCode == item.itmCode && cartItem.defaultPricing ==item.defaultPricing && cartItem.variationId == item.variationId);

    if(index >= 0) {
      if (cartItems[index].quantity > 1){
        cartItems[index].quantity -= 1;
      }
      else {
        //Show dialog before completely removing
        cartItems[index].quantity == 1 ? removeFromCartDialog(index) : cartItems.removeAt(index);
      }
      addOneCartTax(item);
      updateCart();
    }
  }

  //Remove from cart dialog
  void removeFromCartDialog(int index) {
    Get.defaultDialog(
      title: 'Remove Product',
      middleText: 'Are you sure you want to remove this product?',
      onConfirm: () {
        //Remove the item from the cart
        cartItems.removeAt(index);
        updateCart();
        MLoaders.customToast(message: 'Product removed from the cart.');
        Get.back();
      },
      onCancel: () => () => Get.back(),
    );
  }

  //Initialize already added items's count in the cart.
  void updateAlreadyAddedProductCount(ProductModels product){
    //If product has no variations then calculate cartEntries and display total number
    //Else make default entries to 0 and show cartEntries when variation is selected.
    if (product.quantityPrice!.length <= 1) {
      productQuantityInCart.value = getProductQuantityInCart(product.itmCode);
    } else {
      //Check if default pricing is FUM else Get selected variation if any.
      final isQuantityPrice = AuthenticationRepository.instance.isQuantityPrice.value;
      final variationId = variationController.selectedVariation.value.bulkPackUnit;
      if(isQuantityPrice){
        productQuantityInCart.value = getProductQuantityInCart(product.itmCode);
      } else if(variationId!.isNotEmpty) {
        productQuantityInCart.value = getVariationQuantityInCart(product.itmCode, variationId);
      } else {
        productQuantityInCart.value = 0;
      }
    }
  }


 CartItemModel convertToCartItem(ProductModels product, int quantity) {
  final isQuantityPrice = AuthenticationRepository.instance.isQuantityPrice.value;

  // Reset variation if there are no variations
  // if (product.quantityPrice == null && product.quantityPrice!.length <= 1)
  if ( product.quantityPrice!.length <= 1) {
    variationController.resetSelectedAttributes();
  }
    // Retrieve the quantity based on variationId from productPackagingPrice
  final productPackaging = product.quantityPrice!.firstWhere(
    (pack) => pack.bulkPackUnit == product.fixUnitOfSell,
    orElse: () => ProductPackingPrice.empty(),
  );
  final variation = variationController.selectedVariation.value;
  final isVariation = variation.bulkPackUnit!.isNotEmpty;
  final isTaxable = product.taxRate > 0.0;
  final isRsp = AuthenticationRepository.instance.isRetailPrice.value; // Accessing .value for RxBool
    // print("Rsp ${product.rspIncVat}, bulkPackUPrice ${selectedVariation.value.bulkPackUPrice}, basePackQty ${selectedVariation.value.basePackQty!} " );
  
  // Determine the final price when in retail price or WSP price
  final priceWRSP = isVariation 
        ?  isRsp
          ? (product.rspIncVat * variation.basePackQty!)
          : variation.bulkPackUPrice 
        : (product.wspIncVat > 0.0 ? product.wspIncVat : product.rspIncVat);
  final price = isQuantityPrice ? productPackaging.bulkPackUPrice!.toDouble() : priceWRSP;
  final taxAmount = isTaxable ? quantity * ((product.taxRate * price!) / (product.taxRate+100)) : 0.0;
  final exVat =(quantity* price!) - taxAmount;
  // print("isQuantityPrice $isQuantityPrice, variation ${productPackaging.bulkPackUPrice}");
  // print("price: $price, exVat: $exVat, taxAmount: $taxAmount");
  return CartItemModel(
    itmCode: product.itmCode, 
    title: product.longName,
    unit: isVariation ? variation.bulkPackUnit! : product.unit!,
    basicUnit: product.unit!,
    defaultPricing: isQuantityPrice ? "FUM": isRsp ? "RSP" : "QSP",
    price: price!.toDouble(),
    exVat:double.parse(exVat.toStringAsFixed(2)),
    taxAmount: double.parse(taxAmount.toStringAsFixed(2)),
    quantity: quantity,
    vatRate: product.taxRate,
    vatCode: product.taxCode!,
    variationId: variation.bulkPackUnit!,
    // image: isVariation ? variation.image : MImages.adidasLogo,
    // brandName: product.brand != null ? product.brand!.name : '',
    selectedVariation: isVariation ? variation.bulkPackUnit : null, 
  );
}

 //Update cart values
 void updateCart() {
  updateCartTotals();
  saveCartItems();
  cartItems.refresh();
 }

  void updateCartTotals() {
    double calculatedTotalPrice = 0.0;
    double calculatedTotalTax = 0.0;
    int calculatedNoOfItems = 0;
   
    for (var item in cartItems) {
      calculatedTotalPrice += (item.price) * item.quantity.toDouble();
      calculatedNoOfItems += item.quantity;
      calculatedTotalTax += item.taxAmount;
    }
    // print("tax of items in cart: $calculatedTotalTax, total price: $calculatedTotalPrice");
    totalCartPrice.value =double.parse(calculatedTotalPrice.toStringAsFixed(2)); 
    totalCartTax.value = double.parse(calculatedTotalTax.toStringAsFixed(2));
    noOfCartItems.value = calculatedNoOfItems;
  }

  void saveCartItems(){
    final cartIemStrings = cartItems.map((item) => item.toJson()).toList();
    MLocalStorage.instance().saveData('CARTITEMS', cartIemStrings);
  }

  void loadCartItems() {
    final cartItemStrings = MLocalStorage.instance().readData<List<dynamic>>('CARTITEMS');
    if (cartItemStrings != null){
      cartItems.assignAll(cartItemStrings.map((item) => CartItemModel.fromJson(item as Map<String, dynamic>)));
      updateCartTotals();
    }
  }

  int getProductQuantityInCart(String itmCode){
    final foundItem = cartItems.where((item) => item.itmCode == itmCode).fold(0, (previousValue, element) => previousValue + element.quantity);
    return foundItem;
  }

  int getAllProductQuantityInCart(ProductModels product, String variationUnit) {
    // Find all items with the matching itmCode
    final foundItems = cartItems.where((item) => item.itmCode == product.itmCode && item.variationId != variationUnit ).toList();

    int totalQuantity = 0;

    // Loop through each item and get the quantity from productPackagingPrice
    for (var item in foundItems) {
        final variationId = item.variationId;
        final variationQty = item.quantity;
        
        // Retrieve the quantity based on variationId from productPackagingPrice
        final productPackaging = product.quantityPrice!.firstWhere(
          (pack) => pack.bulkPackUnit == variationId,
          orElse: () => ProductPackingPrice.empty(),
        );
        //variation qty * cart item's variation quantity
        final quantity = productPackaging.basePackQty! * variationQty;
        // Add the quantity to totalQuantity
        totalQuantity += quantity.toInt() ?? 0; // Assuming `quantity` is nullable, default to 0 if null
    }

    // print("Total quantity for product ${product.itmCode}: $totalQuantity");
    return totalQuantity;
}


  int getVariationQuantityInCart(String itmCode, String variationId){
    final isRSP = AuthenticationRepository.instance.isRetailPrice.value ? "RSP" : "QSP";
    final foundItem = cartItems.firstWhere((item) => item.itmCode == itmCode
      && item.defaultPricing == isRSP && item.variationId == variationId,
      orElse: () => CartItemModel.empty(),
    );
    return foundItem.quantity;
  }
  void clearCart() { 
      totalCartPrice.value = 0;
      totalCartTax.value = 0;
      productQuantityInCart.value = 0;
      cartItems.clear(); // Add parentheses to invoke the method
      updateCart();
  }

}