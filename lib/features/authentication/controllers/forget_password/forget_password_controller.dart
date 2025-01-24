import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiapp/SQLite/sqlite.dart';
import 'package:multiapp/features/authentication/models/user/user_model.dart';
import 'package:multiapp/features/authentication/screens/password_configuration/reset_password.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';

class ForgetPasswordController extends GetxController{
  static ForgetPasswordController get instance => Get.find();

  //Variables
  final appKey= TextEditingController();
  final password= TextEditingController();
  final confirmPassword= TextEditingController();
  final hidePassword = true.obs; //Observable for hiding/showing password
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();  //Form key for form validation
  
  // Initialize the database instance here
  final LocalDatabase db = LocalDatabase.instance;

  //Reset password 
resetPassword() async {
  try {
    // Start loading
    MFullScreenLoader.openLoadingDialog('Processing your request...',MImages.docerAnimation );

    // Form validation
    if (!forgetPasswordFormKey.currentState!.validate()) {
      MFullScreenLoader.stopLoading();
      return;
    }

    // Retrieve the app key
    final setting = await db.getSingleAppSetting();
    if (setting == null || setting['appKey'] == null) {
      MFullScreenLoader.stopLoading();
      MLoaders.errorSnackBar(
        title: 'Error', 
        message: "App settings could not be retrieved. Please try again."
      );
      return;
    }

    String currentAppKey = setting['appKey'];
    String lastFiveDigits = currentAppKey.substring(currentAppKey.length - 6);
      log("Reset Password for currentAppKey: $lastFiveDigits");
      log("Reset Password for appKey1: ${appKey.text.trim()}");
    if (lastFiveDigits != appKey.text.trim()) {
      MFullScreenLoader.stopLoading();
      MLoaders.errorSnackBar(
        title: 'Invalid Input', 
        message: "App Key does not match. Please contact support."
      );
      return;
    }

    if (password.text.trim() != confirmPassword.text.trim()) {
      MFullScreenLoader.stopLoading();
      MLoaders.errorSnackBar(
        title: 'Mismatch', 
        message: "Passwords do not match. Please try again."
      );
      return;
    }

    // Hash password and update
    String hashedPassword = LocalDatabase.instance.hashPassword(password.text.trim());
    final rowsUpdated = await db.updatePassword(hashedPassword);

    MFullScreenLoader.stopLoading();

    if (rowsUpdated > 0) {
      MLoaders.successSnackBar(
        title: 'Success', 
        message: 'Your password has been reset successfully.'
      );
      Get.to(() => const ResetPasswordScreen());
    } else {
      MLoaders.errorSnackBar(
        title: 'Error', 
        message: 'Failed to reset your password. Please try again later.'
      );
    }
  } catch (e) {
    MFullScreenLoader.stopLoading();
    debugPrint('Error resetting password: $e'); // Internal logging
    MLoaders.errorSnackBar(
      title: 'Oh Snap!', 
      message: "An unexpected error occurred. Please try again later."
    );
  }
}

    resendPasswordResetEmail(String eamil) async {
    try{
         //Start loading
      MFullScreenLoader.openLoadingDialog('Processing your request...', MImages.docerAnimation);

      //Check Internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected){
        MFullScreenLoader.stopLoading();
        return;
      }

      //Form validation
      if(!forgetPasswordFormKey.currentState!.validate()){
        MFullScreenLoader.stopLoading();
        return;
      }
      
      // //Send password reset email
      // await AuthenticationRepository.instance.sendPasswordresetEmail(email.text.trim());

      // //Remove loader
      MFullScreenLoader.stopLoading();

      //Show success message
      MLoaders.successSnackBar(title: 'Congratulations', message: 'Email link sent to Reset your Password');

    } catch (e) {
      //Remove loader
      MFullScreenLoader.stopLoading();

      //Show some generic error to the user
      MLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}