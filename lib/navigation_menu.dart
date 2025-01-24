import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:multiapp/features/personalization/views/settings/settings.dart';
import 'package:multiapp/features/shop/screens/customer/customer.dart';
import 'package:multiapp/features/shop/screens/home/home.dart';
import 'package:multiapp/features/shop/screens/order/Order.dart';
import 'package:multiapp/utils/constants/colors.dart';
import 'package:multiapp/utils/helpers/helper_functions.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkmode =THelperFunctions.isDarkMode(context);
    
    return Scaffold(
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