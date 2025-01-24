import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiapp/SQLite/sqlite.dart';
import 'package:multiapp/common/widgets/success_screen/success_screen.dart';
import 'package:multiapp/data/repositories/authentication/authentication_repository.dart';
import 'package:multiapp/data/repositories/order/order_repository.dart';
import 'package:multiapp/features/personalization/controllers/user_controller.dart';
import 'package:multiapp/features/shop/controllers/credit_customer_controller.dart';
import 'package:multiapp/features/shop/controllers/customer_controller.dart';
import 'package:multiapp/features/shop/controllers/products/cart_controller.dart';
import 'package:multiapp/features/shop/controllers/products/checkout_controller.dart';
import 'package:multiapp/features/shop/models/order_item_model.dart';
import 'package:multiapp/features/shop/models/order_model.dart';
import 'package:multiapp/navigation_menu.dart';
import 'package:multiapp/utils/constants/enums.dart';
import 'package:multiapp/utils/constants/image_strings.dart';
import 'package:multiapp/utils/popups/loaders.dart';
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

    log('order snapshot: ${snapshot}');
    // Handle null or empty result (no categories found)
    if (snapshot == null || snapshot.isEmpty) {
      return [];
    }

    // Map each product from the snapshot (SQLite result) to productModel
    final allOrders = snapshot.map((data) {
      // Ensure correct type casting
      return OrderModel.fromMap(data as Map<String, dynamic>);
    }).toList();
    log('Fetched products: ${allOrders}');
    
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
        throw Exception("Kindly load the Customers");
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
      id: generateConcatenatedString(),
      createdBy: userId,
      orderStatus: 'Pending',
      totalAmount: totalAmount,
      orderDate: DateTime.now().toIso8601String(),
      paymentMethod: checkoutController.selectedPaymentMethod.value.name,
      createdAt: DateTime.now().toIso8601String(),
      locationId: '00', //pick default location
      naration: customerController.naration.value,
      customerCode: customerController.selectedCustomer.value.cusCode,
      companyName: customerController.selectedCustomer.value.companyName, 
      cashCustomerName: creditController.customerName  ?? '', 
      cashPhoneNumber: creditController.phoneNumber  ?? '',
      cashPinNo:creditController.pinNo ?? '',
      cashAddress:creditController.address  ?? ''
    );
// print("order: ${order.cashCustomerName}: ${order.cashPhoneNumber}");
    await orderRepository.saveOrders(order);

    for (var item in cartitems) {
      final orderItem = OrderItemModel(
        defaultPricing:item.defaultPricing,
        orderId: order.id,
        locationId: '00',
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

  String generateCleanUniqueKey() {
    String rawKey = UniqueKey().toString(); // e.g., "[#cffb2]"
    return rawKey.replaceAll(RegExp(r'[\[\]#]'), ''); // Removes '[', ']', and '#'
  }


  String generateConcatenatedString() {
    String cleanKey = generateCleanUniqueKey();
    
    // Get current date
    DateTime now = DateTime.now();
    
    // Format date as DDMMYYYY
    String date = '${now.day.toString().padLeft(2, '0')}${now.month.toString().padLeft(2, '0')}${now.year}';
    
    // Assume username is fetched from a controller
    String userName = UserController.instance.user.value.userName;

    // Concatenate components
    String orderKey = '$date$userName$cleanKey';

    return orderKey;
  }

}