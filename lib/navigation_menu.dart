import 'package:easyapp/data/repositories/authentication/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:easyapp/features/personalization/views/settings/settings.dart';
import 'package:easyapp/features/shop/screens/customer/customer.dart';
import 'package:easyapp/features/shop/screens/home/home.dart';
import 'package:easyapp/features/shop/screens/order/order.dart';
import 'package:easyapp/utils/constants/colors.dart';
import 'package:easyapp/utils/helpers/helper_functions.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkmode =THelperFunctions.isDarkMode(context);
    
    return PopScope(
      canPop: false,
      onPopInvoked: (didpop){
        if (didpop){
          return;
        }
        _showExitDialog(context);
      },
      child: Scaffold(
        bottomNavigationBar: Obx(
          () => NavigationBar(
              height: 80,
              elevation: 0,
              selectedIndex: controller.selectedIndex.value,
              onDestinationSelected: (index) => controller.selectedIndex.value =index,
              backgroundColor: darkmode ? MColors.black: Colors.white,
              indicatorColor: darkmode ? MColors.white.withOpacity(0.1): MColors.black.withOpacity(0.1),
      
              destinations: const  [
                NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
                NavigationDestination(icon: Icon(Iconsax.shop), label: 'Orders'),
                NavigationDestination(icon: Icon(Iconsax.heart), label: 'Customers'),
                NavigationDestination(icon: Icon(Iconsax.user), label: 'Profile'),
              ],
            ),
        ),
        body: Obx(() =>controller.screens[controller.selectedIndex.value]),
      ),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex =0.obs;

  final screens= [
    const HomeScreen() ,
    const OrderScreen(),
    const CustomerScreen(),
    const SettingsScreen()];
}

Future<bool> _showExitDialog(BuildContext context) async {
  return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Exit App"),
            content: const Text("Are you sure you want to logout and exit?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  // Close the dialog first to prevent context issues
                  Navigator.of(context).pop(true);

                  // Perform logout
                  await AuthenticationRepository.instance.logout();

                  // Exit the app
                  SystemNavigator.pop(); // Closes the app on Android
                  
                },
                child: const Text("Logout & Exit"),
              ),
            ],
          );
        },
      ) ??
      false;
  }