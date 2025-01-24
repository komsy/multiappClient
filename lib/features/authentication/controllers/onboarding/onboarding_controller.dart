import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:multiapp/SQLite/sqlite.dart';
import 'package:multiapp/features/authentication/screens/login/login.dart';

class OnBoardingController extends GetxController {
  static OnBoardingController get instance => Get.find();
  // Initialize the database instance here
  final LocalDatabase db = LocalDatabase.instance;

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