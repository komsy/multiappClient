import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:easyapp/SQLite/sqlite.dart';
import 'package:easyapp/features/authentication/screens/login/login.dart';

class OnBoardingController extends GetxController {
  static OnBoardingController get instance => Get.find();
  // Initialize the database instance here
  final LocalDatabase db = LocalDatabase.instance;
  final localStorage = GetStorage();

  //variables
  final pageController = PageController();
  Rx<int> currentPageIndex = 0.obs;

 @override
  void onReady(){
    // Now call the async method to insert test product
    _initProductData();
  }

  Future<void> _initProductData() async {
    await db.resetDatabase();
    await db.insertTestProduct();
    
    // Get current date
    DateTime now = DateTime.now();
    
    // Format date as DDMMYYYY 
    String date = '${now.day.toString().padLeft(2, '0')}${now.month.toString().padLeft(2, '0')}${now.year}';
    
    // Save credentials for first time users
    localStorage.write('REMEMBER_ME_EMAIL', 'admin@multitech.co.ke');
    localStorage.write('REMEMBER_ME_PASSWORD', '@Admin123');
    localStorage.write('REMEMBER_ME_DATE', date);
    //  await db.readAllData();
    // print('Test product inserted successfully');
  }
  //Update current index when page scroll
  void updatepageIndiator(index) => currentPageIndex.value = index;

  //jump to the specific dot slected page
  void dotNavigationClick(index) {
    currentPageIndex.value = index;
    pageController.jumpTo(index);
  }

  //update current index & jump to next page
  void nextPage() {
    if(currentPageIndex.value == 1){

      //Update user opening the app first time to false
      final storage =GetStorage();
      storage.write('isFirstTime', false);

      Get.offAll( () =>const LoginScreen());
    } else {
      int page = currentPageIndex.value + 1;
      pageController.jumpToPage(page);
    }
  }

  //update current index & jump to next page
  void skipPage() {
    currentPageIndex.value = 1;
    pageController.jumpToPage(1);
  }


}