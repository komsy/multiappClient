import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiapp/SQLite/sqlite.dart';
import 'package:multiapp/data/repositories/authentication/authentication_repository.dart';
import 'package:multiapp/utils/constants/image_strings.dart';
import 'package:multiapp/utils/popups/full_screen_loader.dart';
import 'package:multiapp/utils/popups/loaders.dart';

import '../../authentication/models/user/user_model.dart';

class UserController extends GetxController{
  static UserController get instance => Get.find();

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

      //Form validation
      if(!updateUserNameFormKey.currentState!.validate()){
        MFullScreenLoader.stopLoading();
        return;
      }
      
      String hashedPassword = LocalDatabase.instance.hashPassword(password.text.trim());

      //Update user's first & last name in the sqlite firestore
      final users = UserModel(
        userName:userName.text.trim(),
        email: email.text.trim(),
        password: hashedPassword,
        role: "user",
        status: 1,
        createdAt: DateTime.now().toIso8601String(),
      );
      
      // print("users saving data ${users.userName}, ${users.email}, ${users.password}");

      await db.insertUser(users);

      //Remove loader
      MFullScreenLoader.stopLoading();

      //Show success message
      MLoaders.successSnackBar(title: 'Congratulations', message: 'Your Profile settings has been saved successfully. Kindly login with the new credentials.');
    
      //Reset fields
      resetFormFields();
      //Reload the settings
      fetchUserRecord();
      // print("users ${user.value.userName}, ${user.value.email}, ${user.value.password}");
      //Redirect 
      // Get.to(() => const ProfileScreen());
      // Navigator.of(Get.context!).pop();
      AuthenticationRepository.instance.logout();
    } catch (e) {
      //Remove loader
      MFullScreenLoader.stopLoading();

      //Show some generic error to the user
      MLoaders.errorSnackBar(title: 'App Setting not found', message: e.toString());
    }
  }
 //Fn to reset form fields
  void resetFormFields() {
    userName.clear();
    email.clear();
    password.clear();
    updateUserNameFormKey.currentState?.reset();
  }


}