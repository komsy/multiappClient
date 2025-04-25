import 'package:easyapp/common/widgets/success_screen/success_screen.dart';
import 'package:easyapp/features/personalization/controllers/location_controller.dart';
import 'package:easyapp/features/personalization/models/location_model.dart';
import 'package:easyapp/features/shop/models/cart_item_model.dart';
import 'package:easyapp/navigation_menu.dart';
import 'package:easyapp/utils/constants/image_strings.dart';
import 'package:easyapp/utils/helpers/network_manager.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:easyapp/SQLite/sqlite.dart';
import 'package:easyapp/data/repositories/authentication/authentication_repository.dart';
import 'package:easyapp/data/repositories/order/order_repository.dart';
import 'package:easyapp/features/personalization/controllers/user_controller.dart';
import 'package:easyapp/features/shop/controllers/credit_customer_controller.dart';
import 'package:easyapp/features/shop/controllers/customer_controller.dart';
import 'package:easyapp/features/shop/controllers/products/cart_controller.dart';
import 'package:easyapp/features/shop/controllers/products/checkout_controller.dart';
import 'package:easyapp/features/shop/models/order_item_model.dart';
import 'package:easyapp/features/shop/models/order_model.dart';
import 'package:easyapp/utils/popups/loaders.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.find();

  //Variables
  final isLoading = false.obs;
  RxInt noOfOrderItems = 0.obs;
  final cartController = CartController.instance;
  final customerController = CustomerController.instance;
  final checkoutController = Get.put(CheckoutController());
  final locationController = Get.put(LocationController());
  final orderRepository = Get.put(OrderRepository());
  RxList<CartItemModel> cartItems = <CartItemModel>[].obs;
  // Initialize the database instance here
  final LocalDatabase db = LocalDatabase.instance;
  // Empty List for orderRecords
  final RxList<Map<String, dynamic>> orderRecords = <Map<String, dynamic>>[].obs;
  final authRepo = AuthenticationRepository.instance;


  @override
  void onInit() {
    fetchOrders();
    // print("authRepo.goLive.value ${authRepo.goLive.value}");
    super.onInit();
  }
  //Fetch order history
  Future<List<OrderModel>>fetchOrders() async {
    try {
      //Show loader while loading products
      isLoading.value = true;
      final orderDays = authRepo.orderDays.value;
      const isSending=false;
      // Start by fetching data from the database
      final snapshot = await db.getOrders(orderDays, isSending);

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
      
      //check if any order older than required days then delete 
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
    
  Future<void> fetchOrderRecords() async {
    try {
      
      final List<Map<String, dynamic>> result = await db.getAllOrderRecords();

      orderRecords.assignAll(result); // Updates the reactive list
    } catch (e) {
      MLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }


  Future<Map<String, dynamic>?>  getUserId() async 
    {
      try {
          // final decodedPayload = await authRepo.decodeAndVerifyToken();
    
          // print('Processing order... $decodedPayload');
          // if (decodedPayload == null || decodedPayload.isEmpty) return;

          // Decode and verify the JWT token
          var decodedPayload = await authRepo.decodeAndVerifyToken();
          if (decodedPayload == null || decodedPayload.isEmpty) {
            // print("Token expired or invalid. Attempting to refresh the token...");
            
            // Try refreshing the token if it's invalid or expired
            final newToken = await authRepo.refreshToken();
            if (newToken == null) {
              // throw Exception("Failed to refresh token. Please reauthenticate.");
              await authRepo.logout();
            }
            
            // Retry decoding and verifying the new token after refreshing
            decodedPayload = await authRepo.decodeAndVerifyToken();
            if (decodedPayload == null || decodedPayload.isEmpty) {
              throw Exception("Failed to decode or verify the refreshed token. Please reauthenticate.");
            }

          }
          
          return decodedPayload;
        } catch (e) {
        MLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
        // print('Error ack customer data: $e');
        return null;
      }
    }
  
  // Add methods for order processing
  void processOrder(double totalAmount) async {
    try {
      // if live Check Internet connectivity
      if(authRepo.goLive.value){
        final isConnected = await NetworkManager.instance.isConnected();
        if (!isConnected) {
          MLoaders.errorSnackBar( title: 'No Internet',message: 'Please check your internet connection and try again. You are on Live mode!');
          return;
        }
        // Get the current location
        await getCurrLocation();
        
        //Ensure location is not empty
        final location = authRepo.currLocation.value;
        if (location.isEmpty) {
          MLoaders.errorSnackBar(title: 'Location Error', message: 'Unable to fetch current location. Please try again.');
          return;
        }
      }

      // Fetch the current settings
      final currentSetting = await db.getSingleAppSetting();
      if (currentSetting == null) {
        throw Exception("App Setting not found!");
      }

      //check if customer exists
      final cusCode = customerController.selectedCustomer.value.cusCode;
      // print("cusCode $cusCode");
      if (cusCode.isEmpty) {
        throw Exception("Kindly select or load the Customers");
      }

      // print('Processing order...$currentSetting ');
      final cartitems = cartController.cartItems.toList();
      final decodedPayload = await getUserId();
      final userId = decodedPayload?['username'].toString();

      //check if username changed
      if(userId == 'admin'){
        throw Exception("Kindly update your Username!");
      }
      final creditController = CreditCustomerController.instance.selectedCrClient.value;
        // print(" cash customer ${CreditCustomerController.instance.selectedCrClient.value.phoneNumber}");
        // print(" narration: ${customerController.naration.value}");
      final order = OrderModel(
        id: await generateConcatenatedString(),
        isSent: 0,
        createdBy: userId ?? 'admin',
        orderStatus: 'Pending',
        totalAmount: totalAmount,
        orderDate: DateTime.now().toIso8601String(),
        paymentMethod: checkoutController.selectedPaymentMethod.value.name,
        createdAt: DateTime.now().toIso8601String(),//'2025-02-11T16:30:57.555826',  //
        locationId: currentSetting['locationId'] ?? '00', //pick default location
        naration: customerController.naration.value,
        customerCode: customerController.selectedCustomer.value.cusCode,
        companyName: customerController.selectedCustomer.value.companyName, 
        cashCustomerName: creditController.customerName, 
        cashPhoneNumber: creditController.phoneNumber,
        cashPinNo:creditController.pinNo ?? '',
        cashAddress:creditController.address  ?? ''
      );

      //save current location latitude and longitude
      final snippet = customerController.selectedCustomer.value.companyName.contains('Cash') ? 'Cash Account For: ${creditController.customerName}' : customerController.selectedCustomer.value.companyName;
      final title = authRepo.currLocationAddress.value.isNotEmpty ? authRepo.currLocationAddress.value : 'Default Location';
      final locationdata = LocationModel(
        makerId: order.id,
        title: title,
        snippet: snippet,
        location: authRepo.currLocation.value,
        date: DateTime.now().toIso8601String(),
      );

      // Save the location data to the database if the user is in live mode
      if(authRepo.goLive.value) await db.saveCurrlocationdata(locationdata);
      
      // Save the order to the database
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
          createdBy: userId  ?? 'admin',
          createdAt: DateTime.now().toIso8601String(),
        );

        await orderRepository.saveOrderItems(orderItem); // Inserts all items
      }
      
      //Clear cart items
      cartController.clearCart();

      await CreditCustomerController.instance.clearCashCustomer(); // Clear the cash customer details from db and observable if any exists.
      final locationInfo = authRepo.goLive.value
        ? 'at ${authRepo.currLocationAddress.value}'
        : '';
      // Show success screen
      Get.off(() => SuccessScreen(
          image: MImages.successfulPaymentIcon,
          title: 'Order Success!',
          subtitle: 'Thank you for placing the order $locationInfo!',
          onPressed: () => Get.offAll(() => const NavigationMenu()),
        )); 
      } catch (e) { 
        MLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      }
    }
  Future<String?> getCurrLocation() async {
    try {
      final location = await locationController.getUserLocation();

      List<Placemark> placemarks = await placemarkFromCoordinates(location.latitude, location.longitude);
      Placemark place = placemarks.reversed.last;

      String formattedAddress = '${place.thoroughfare?.isNotEmpty == true ? '${place.thoroughfare}, ' : ''}'
          '${place.locality}, ${place.administrativeArea}, ${place.country}';

      authRepo.currLocation = '${location.latitude}, ${location.longitude}'.obs;
      authRepo.currLocationAddress = formattedAddress.obs;

      return formattedAddress;
    } catch (e) {
      // print('Error getting location: $e');
      MLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      return null;
    }
  }


  generateCleanUniqueKey() async {
    String rawKey = UniqueKey().toString(); // e.g., "[#cffb2]"
    return rawKey.replaceAll(RegExp(r'[\[\]#]'), ''); // Removes '[', ']', and '#'
  }


  generateConcatenatedString() async {
    // String cleanKey =  await generateCleanUniqueKey();
    
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
   
    if (cartitems.isNotEmpty) {
      MLoaders.errorSnackBar(title: 'Oh Snap!', message: "Empty your cart and try again!");
      return;
    }
    editOrderDialog(order);
  }
  
  
  void deleteOrderDialog(OrderModel order) async {
    Get.defaultDialog(
      title: 'Delete Order of Ksh ${order.totalAmount}',
      middleText: 'Are you sure you want to delete this Order?',
      // buttonColor: Colors.red,
      onConfirm: () async {
        try {
          if (order.orderItems == null || order.orderItems!.isEmpty) {
            MLoaders.errorSnackBar(title: 'Oh Snap!',message: "This order has no items.");
            return;
          }        

          await db.deleteOrder(order.id);
        
          authRepo.screenRedirect();
        } catch (e) {
          MLoaders.errorSnackBar(title: 'Oh Snap!', message: "Empty your cart and try again!");
        }
      },
      onCancel: () => Get.back(),
    );
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

          
          await db.deleteOldlocationdata(order.id);//delete location data for the specified order
          await db.deleteOrder(order.id);
          await getUserId(); //  refresh token incase it has expired
          MLoaders.customToast(message: 'Order moved to cart.');
          authRepo.screenRedirect();
        } catch (e) {
          MLoaders.errorSnackBar(title: 'Oh Snap!', message: "Empty your cart and try again!");
        }
      },
      onCancel: () => Get.back(),
    );
  }

}