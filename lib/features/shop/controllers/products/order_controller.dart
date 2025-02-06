import 'package:easyapp/features/shop/models/cart_item_model.dart';
import 'package:easyapp/features/shop/models/customer_model.dart';
import 'package:easyapp/features/shop/screens/cart/cart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easyapp/SQLite/sqlite.dart';
import 'package:easyapp/common/widgets/success_screen/success_screen.dart';
import 'package:easyapp/data/repositories/authentication/authentication_repository.dart';
import 'package:easyapp/data/repositories/order/order_repository.dart';
import 'package:easyapp/features/personalization/controllers/user_controller.dart';
import 'package:easyapp/features/shop/controllers/credit_customer_controller.dart';
import 'package:easyapp/features/shop/controllers/customer_controller.dart';
import 'package:easyapp/features/shop/controllers/products/cart_controller.dart';
import 'package:easyapp/features/shop/controllers/products/checkout_controller.dart';
import 'package:easyapp/features/shop/models/order_item_model.dart';
import 'package:easyapp/features/shop/models/order_model.dart';
import 'package:easyapp/navigation_menu.dart';
import 'package:easyapp/utils/constants/image_strings.dart';
import 'package:easyapp/utils/popups/loaders.dart';
import 'dart:developer';

class OrderController extends GetxController {
  static OrderController get instance => Get.find();

  //Variables
  final isLoading = false.obs;
  RxInt noOfOrderItems = 0.obs;
  final cartController = CartController.instance;
  final customerController = CustomerController.instance;
  final checkoutController = Get.put(CheckoutController());
  final orderRepository = Get.put(OrderRepository());
  RxList<CartItemModel> cartItems = <CartItemModel>[].obs;
  // Initialize the database instance here
  final LocalDatabase db = LocalDatabase.instance;

  @override
  void onInit() {
    fetchOrders();
    super.onInit();
  }
  //Fetch order history
Future<List<OrderModel>>fetchOrders() async {
  try {
    //Show loader while loading products
    isLoading.value = true;
    // Start by fetching data from the database
    final snapshot = await db.getOrders();

    // log('order snapshot: ${snapshot}');
    // Handle null or empty result (no categories found)
    if (snapshot == null || snapshot.isEmpty) {
      return [];
    }

    // Map each product from the snapshot (SQLite result) to productModel
    final allOrders = snapshot.map((data) {
      // Ensure correct type casting
      return OrderModel.fromMap(data as Map<String, dynamic>);
    }).toList();
    // log('Fetched products: ${allOrders}');
    isLoading.value = false;
    return allOrders;
  } catch (e) {
    // Handle and show error message
    MLoaders.errorSnackBar(title: 'Oh Snaped!', message: e.toString());
    return [];
  // } finally {
  //   // Remove loader or stop any loading indicator
  //   isLoading.value = false;
  }
}
  // Add methods for order processing
void processOrder(double totalAmount) async {
  try {
    // Fetch the current settings
    final currentSetting = await db.getSingleAppSetting();
    if (currentSetting == null) {
      throw Exception("App Setting not found!");
    }
    //check if customer exists
    final cusCode = customerController.selectedCustomer.value.cusCode;
    // print("cusCode $cusCode");
    if (cusCode == null || cusCode.isEmpty) {
        throw Exception("Kindly select or load the Customers");
      }

    // print('Processing order...$currentSetting ');
    final cartitems = cartController.cartItems.toList();
    // final decodedPayload = await AuthenticationRepository.instance.decodeAndVerifyToken();
    
    // print('Processing order... $decodedPayload');
    // if (decodedPayload == null || decodedPayload.isEmpty) return;

    // Decode and verify the JWT token
    var decodedPayload = await AuthenticationRepository.instance.decodeAndVerifyToken();
    if (decodedPayload == null || decodedPayload.isEmpty) {
      // print("Token expired or invalid. Attempting to refresh the token...");
      
      // Try refreshing the token if it's invalid or expired
      final newToken = await AuthenticationRepository.instance.refreshToken();
      if (newToken == null) {
        // throw Exception("Failed to refresh token. Please reauthenticate.");
        await AuthenticationRepository.instance.logout();
      }
      
      // Retry decoding and verifying the new token after refreshing
      decodedPayload = await AuthenticationRepository.instance.decodeAndVerifyToken();
      if (decodedPayload == null || decodedPayload.isEmpty) {
        throw Exception("Failed to decode or verify the refreshed token. Please reauthenticate.");
      }

    }
    final userId = decodedPayload['username'].toString();
    
    //check if username changed
    if(userId == 'admin'){
      throw Exception("Kindly update your Username!");
    }
    final creditController = CreditCustomerController.instance.selectedCrClient.value;
      // print(" cash customer ${CreditCustomerController.instance.selectedCrClient.value.phoneNumber}");
      // print(" narration: ${customerController.naration.value}");
    final order = OrderModel(
      id: await generateConcatenatedString(),
      createdBy: userId,
      orderStatus: 'Pending',
      totalAmount: totalAmount,
      orderDate: DateTime.now().toIso8601String(),
      paymentMethod: checkoutController.selectedPaymentMethod.value.name,
      createdAt: DateTime.now().toIso8601String(),
      locationId: currentSetting['locationId'] ?? '00', //pick default location
      naration: customerController.naration.value,
      customerCode: customerController.selectedCustomer.value.cusCode,
      companyName: customerController.selectedCustomer.value.companyName, 
      cashCustomerName: creditController.customerName  ?? '', 
      cashPhoneNumber: creditController.phoneNumber  ?? '',
      cashPinNo:creditController.pinNo ?? '',
      cashAddress:creditController.address  ?? ''
    );

    await orderRepository.saveOrders(order);

    for (var item in cartitems) {
      final orderItem = OrderItemModel(
        defaultPricing:item.defaultPricing,
        orderId: order.id,
        locationId: currentSetting['locationId'] ?? '00',
        itmCode: item.itmCode,
        longName: item.title,
        quantity: item.quantity, 
        unit: item.unit,
        basicUnit: item.basicUnit,
        vatCode: item.vatCode,
        vatRate: item.vatRate,
        exVat: item.exVat,
        vatAmount: item.taxAmount,
        amount: item.price * item.quantity,
        costPrice: item.price,
        createdBy: userId,
        createdAt: DateTime.now().toIso8601String(),
      );

     await orderRepository.saveOrderItems(orderItem); // Inserts all items
    }
    
    //Clear cart items
    cartController.clearCart();

    await CreditCustomerController.instance.clearCashCustomer(); // Clear the cash customer details from db and observable if any exists.

    // Show success screen
    Get.off(() => SuccessScreen(
        image: MImages.successfulPaymentIcon,
        title: 'Order Success!',
        subtitle: 'Thank you for shopping with us!',
        onPressed: () => Get.offAll(() => const NavigationMenu()),
      )); 
    } catch (e) { 
      MLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  generateCleanUniqueKey() async {
    String rawKey = UniqueKey().toString(); // e.g., "[#cffb2]"
    return rawKey.replaceAll(RegExp(r'[\[\]#]'), ''); // Removes '[', ']', and '#'
  }


  generateConcatenatedString() async {
    String cleanKey =  await generateCleanUniqueKey();
    
    // Get current date
    DateTime now = DateTime.now();
    
    // Format date as DDMMYYYY
    String date = '${now.day.toString().padLeft(2, '0')}${now.month.toString().padLeft(2, '0')}${now.year}${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';
    // Assume username is fetched from a controller
    String userName = UserController.instance.user.value.userName;

    // Concatenate components
    // String orderKey = '$date$userName$cleanKey';
    String orderKey = '$date$userName';

    return orderKey;
  }
  
  void editOrder(OrderModel order) {
    //check if cart !empty ? return  : addtoCart
    final cartitems = cartController.cartItems.toList();
    print("cartitems $cartitems");
    if (cartitems.isNotEmpty) {
      MLoaders.errorSnackBar(title: 'Oh Snap!', message: "Empty your cart and try again!");
      return;
    }
    editOrderDialog(order);
  }
void editOrderDialog(OrderModel order) async {
  Get.defaultDialog(
    title: 'Edit Order of Ksh ${order.totalAmount}',
    middleText: 'Are you sure you want to edit this Order?',
    onConfirm: () async {
      try {
        if (order.orderItems == null || order.orderItems!.isEmpty) {
          MLoaders.errorSnackBar(title: 'Oh Snap!',message: "This order has no items.");
          return;
        }        

        // Loop through order items and add each to the cart
        for (var item in order.orderItems!) {
          final cartItem = CartItemModel(
            itmCode: item.itmCode,
            title: item.longName,
            unit: item.unit,
            basicUnit: item.basicUnit,
            defaultPricing: item.defaultPricing,
            price: item.costPrice,
            exVat: item.exVat,
            taxAmount: item.vatAmount,
            quantity: item.quantity,
            vatRate: item.vatRate,
            vatCode: item.vatCode,
            variationId: item.unit,
            selectedVariation: item.unit,
          );

        cartController.addOneToCart(cartItem); 
        }

        cartController.updateCart();

        // Update default customer
        // customerController.selectedOrderCustomer.value = 
        //     customerController.featuredCustomers.firstWhere(
        //   (customer) => customer.companyName == order.companyName,
        //   orElse: () => CustomerModel.empty(),
        // );

        // await db.deleteOrder(order.id);
      
        MLoaders.customToast(message: 'Order moved to cart.');
        AuthenticationRepository.instance.screenRedirect();
      } catch (e) {
        MLoaders.errorSnackBar(title: 'Oh Snap!', message: "Empty your cart and try again!");
      }
    },
    onCancel: () => Get.back(),
  );
}

}