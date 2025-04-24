import 'package:easyapp/data/provider/api_provider.dart';
import 'package:easyapp/utils/constants/text_strings.dart';
import 'package:easyapp/utils/helpers/network_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easyapp/SQLite/sqlite.dart';
import 'package:easyapp/data/repositories/authentication/authentication_repository.dart';
import 'package:easyapp/utils/constants/image_strings.dart';
import 'package:easyapp/utils/popups/full_screen_loader.dart';
import 'package:easyapp/utils/popups/loaders.dart';import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import '../../authentication/models/user/user_model.dart';

class UserController extends GetxController{
  static UserController get instance => Get.find();
final apiProvider = ApiProvider();
  final hidePassword = true.obs; //Observable for hiding/showing 
  final profileLoading = true.obs; 
  final isLoading = true.obs; 
  final userName= TextEditingController();
  final password= TextEditingController();
  final email= TextEditingController();
  // final userController = UserController.instance; //create instance of the user controller
  GlobalKey<FormState> updateUserNameFormKey = GlobalKey<FormState>();  //Form key for form validation
  
  final verifyEmail= TextEditingController();
  final verifyPassword= TextEditingController();
  Rx<UserModel> user =UserModel.empty().obs; //Observable user
  // GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>();  //Form key for form validation
  final authRepo = AuthenticationRepository.instance; //create instance of the authentication repository

  // Initialize the database instance here
  final LocalDatabase db = LocalDatabase.instance;

  @override
  void onInit() {
    fetchUserRecord();
    initializeNames();
    super.onInit();
  }

  //Fetch user record and show on the fields
  Future <void> initializeNames() async {
    userName.text = user.value.userName;
    email.text = user.value.email;
  }
  Future<void>fetchUserRecord() async {
    try {
      //Show loader while loading users
      isLoading.value = true;
      // Start by fetching data from the database
      final snapshot = await db.getUser();

      // Handle null or empty result
        if (snapshot == null || snapshot.isEmpty) {
          user(null); // Assign null if no settings are found
          return;
        }
      // Map each product from the snapshot (SQLite result) to productModel
      final allUsers =UserModel.fromMap(snapshot);
      user(allUsers);
    } catch (e) {
      // Handle and show error message
      MLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      user(null); // Handle errors by assigning null
    } finally {
      // Remove loader or stop any loading indicator
      profileLoading.value = false;
    }
  }

  //Save user record from any registration provider
  Future updateUserName() async {
    try {
      //Start loading
      MFullScreenLoader.openLoadingDialog('Storing App Settings...', MImages.docerAnimation);
      
      // Check Internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        //Remove loader
        MFullScreenLoader.stopLoading();
        MLoaders.errorSnackBar(title: 'No Internet', message: 'Please check your internet connection and try again.');
        return;
      }
      
      //Form validation
      if(!updateUserNameFormKey.currentState!.validate()){
        MFullScreenLoader.stopLoading();
        return;
      }
      //send data to API
      final checkAppUser= await apiProvider.checkAppUser(userName.text.trim(),email.text.trim());
         
      String hashedPassword = LocalDatabase.instance.hashPassword(password.text.trim());

      //Update user's first & last name in the sqlite firestore
      final users = UserModel(
        userName:userName.text.trim(),
        email: email.text.trim(),
        password: hashedPassword,
        role: "user",
        status: 1,
        userStatus: (checkAppUser['userStatus'] == true) ? 1 : 0,
        licStatus: (checkAppUser['licStatus'] == true) ? 1 : 0,
        updatedAt: DateTime.now().toIso8601String(),
        createdAt: DateTime.now().toIso8601String(),
      );

      // print("users saving data ${users.userName}, ${users.email}, ${users.password}");

      await db.insertUser(users);

      //send email for new user
      final smtpServer = gmail(MTexts.emailusername, MTexts.emailPassword);
        final message = Message()
          ..from = const Address(MTexts.emailusername, 'Komtech')
          ..recipients.add(MTexts.emailusername)
          ..ccRecipients.addAll(['koometest@gmail.com'])
          // ..bccRecipients.add(Address('bccAddress@example.com'))
          ..subject = 'New user registered :: 😀 :: ${DateTime.now()}'
          // ..text = 'User ${userName.text.trim()} has registered with the email ${email.text.trim()} and AppKey ${authRepo.appKey.value}'
          ..html = "User ${userName.text.trim()} has registered with the email ${email.text.trim()} and AppKey ${authRepo.appKey.value} on ${authRepo.apiURL.value} \n \n<p>Hey! You know what that means 😀</p>";

        try {
          await send(message, smtpServer);
          // print('Message sent: ' + sendReport.toString());
        } on MailerException catch (e) {
          // print('Message not sent.');
          // for (var p in e.problems) {
          //   // print('Problem: ${p.code}: ${p.msg}');
          // }
           throw Exception('Failed to send email: ${e.toString()}');
        }
        
      //Remove loader
      MFullScreenLoader.stopLoading();

      // //Show success message
      MLoaders.successSnackBar(title: 'Congratulations', message: 'Your Profile settings has been saved successfully. Kindly login with the new credentials.');
    
      //Reset fields
      resetFormFields();
      //Reload the settings
      fetchUserRecord();
      // print("users ${user.value.userName}, ${user.value.email}, ${user.value.password}");
      //Redirect 
      // Get.to(() => const ProfileScreen());
      // Navigator.of(Get.context!).pop();
      authRepo.logout();
    } catch (e) {
      //Remove loader
      MFullScreenLoader.stopLoading();

      //Show some generic error to the user
      MLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }
 //Fn to reset form fields
  void resetFormFields() {
    userName.clear();
    email.clear();
    password.clear();
    updateUserNameFormKey.currentState?.reset();
  }

  void deleteAccDialog() async {
    Get.defaultDialog(
      title: 'Delete Account',
      middleText: 'Are you sure you want to delete your account?',
      // buttonColor: Colors.red,
      onConfirm: () async {
        try {     
          await deleteAccount();
        } catch (e) {
          MLoaders.errorSnackBar(title: 'Oh Snap!', message: "Something went wrong!");
        }
      },
      onCancel: () => Get.back(),
    );
  }

    Future<void> deleteAccount() async {
    try {
      //Call API to update user settings
      final email = UserController.instance.user.value.email;
      if (email.isEmpty) {
        throw Exception("User email is not available.");
      }
      // Call the API to delete the user account
      await ApiProvider().deleteUserAccount(email);

      //Reset the database
      await db.resetDatabase();
      await db.insertTestProduct();

      //Initialize default user
      await authRepo.rememberUser();

      //Clear token & logout
      await authRepo.logout();
      MLoaders.successSnackBar(title: 'Account Deleted!',message: 'Your account has been deleted Successfully.');
      
    } catch (e) {
      // throw 'Something went wrong. Please try again error: $e.';
          MLoaders.errorSnackBar(title: 'Oh Snap!', message: "Something went wrong! ${e.toString()}");
    }
  }
}