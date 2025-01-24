import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiapp/features/personalization/controllers/user_controller.dart';
import 'package:multiapp/features/personalization/views/profile/profile.dart';
import 'package:multiapp/utils/popups/loaders.dart';

import '../../../utils/constants/image_strings.dart';
import '../../../utils/helpers/network_manager.dart';
import '../../../utils/popups/full_screen_loader.dart';

class UpdateNameController extends GetxController{
  static UpdateNameController get instance => Get.find();

    //Variables
  final userName= TextEditingController();
  final email= TextEditingController();
  final userController = UserController.instance; //create instance of the user controller
  GlobalKey<FormState> updateUserNameFormKey = GlobalKey<FormState>();  //Form key for form validation
  


  @override
  void onInit() {
    initializeNames();
    super.onInit();
  }

  //Fetch user record and show on the fields
  Future <void> initializeNames() async {
    userName.text = userController.user.value.userName;
    email.text = userController.user.value.email;
  }

  Future<void> updateUserName() async {
    try {
      //Start loading
      MFullScreenLoader.openLoadingDialog('We are updating your information...', MImages.docerAnimation);

      //Check Internet connectivity
      // final isConnected = await NetworkManager.instance.isConnected();
      // if (!isConnected){
      //   MFullScreenLoader.stopLoading();
      //   return;
      // }

      //Form validation
      if(!updateUserNameFormKey.currentState!.validate()){
        MFullScreenLoader.stopLoading();
        return;
      }
      
      //Update user's first & last name in the sqlite firestore
      Map<String, dynamic> name = {'Firstname': userName.text.trim(),'Lastname': email.text.trim()};
     
      //Update the Rx user value
      userController.user.value.userName = userName.text.trim();
      userController.user.value.email = email.text.trim();

      //Remove loader
      MFullScreenLoader.stopLoading();

      //Show success message
      MLoaders.successSnackBar(title: 'Congratulations', message: 'Your Name has been updated.');

      //Move to previous screen
      Get.off(() => const ProfileScreen());
    } catch (e) {
      //Remove loader
      MFullScreenLoader.stopLoading();

      //Show some generic error to the user
      MLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}