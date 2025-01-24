import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:multiapp/SQLite/sqlite.dart';
import 'package:multiapp/data/repositories/authentication/authentication_repository.dart';
import 'package:multiapp/env.dart';
import 'package:multiapp/features/personalization/controllers/user_controller.dart';
import 'package:multiapp/utils/constants/image_strings.dart';
import 'package:multiapp/utils/helpers/network_manager.dart';
import 'package:multiapp/utils/popups/full_screen_loader.dart';
import 'package:multiapp/utils/popups/loaders.dart';


class LoginController extends GetxController{
  static LoginController get instance =>Get.find();
  // Initialize the database instance here
  final LocalDatabase db = LocalDatabase.instance;

  //Variables
  final localStorage = GetStorage();
  final hidePassword = true.obs; //Observable for hiding/showing password
  final rememberMe = false.obs; //Observable for privacy policy acceptance
  final privacyPolicy = true.obs; //Observable for privacy policy acceptance
  final email= TextEditingController();
  final password= TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();  //Form key for form validation
  // final userController = UserController.instance; //create instance of the user controller

  @override
  void onInit() {
    email.text = localStorage.read('REMEMBER_ME_EMAIL') ?? "";
    password.text = localStorage.read('REMEMBER_ME_PASSWORD') ?? "";
    super.onInit();
  }
  //Sigup
 Future<void> emailAndPasswordSignin() async {
  try {
    // Start loading
    MFullScreenLoader.openLoadingDialog('Logging you in...', MImages.docerAnimation);

    // Check Internet connectivity
    // final isConnected = await NetworkManager.instance.isConnected();
    // if (!isConnected) {
    //   MLoaders.errorSnackBar(title: 'No Internet', message: 'Please check your internet connection and try again.');
    //   return;
    // }

    // Form validation
    if (!loginFormKey.currentState!.validate()) {
      MLoaders.errorSnackBar(title: 'Validation Error', message: 'Please enter valid credentials.');
      return;
    }

    // Save data if "remember me" is selected
    if (rememberMe.value) {
      localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
      localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
    }

    // Log in the user from SQLite db
    final result = await db.login(email.text.trim(), password.text.trim());

    if (result != null) {
      final setting = await db.getSingleAppSetting();
      if (setting == null || setting['appKey'] == null) {
        throw Exception("APP Key not found!");
      }

      String storedPassword = result[0]['password'];
      bool passwordMatches = _comparePassword(password.text.trim(), storedPassword);

      if (passwordMatches) {
        // Prepare payload for JWT
        var payload = {
          'userId': result[0]['id'],
          'role': result[0]['role'],
          'email': result[0]['email'],
          'username': result[0]['username'],
        };

        final jwt = JWT(payload);
        String jwtToken = jwt.sign(SecretKey(setting['appKey']), expiresIn: const Duration(minutes: 30));
        localStorage.write('jwt_token', jwtToken);

        // Redirect after successful login
        AuthenticationRepository.instance.screenRedirect();
      } else {
        MLoaders.errorSnackBar(title: 'Login Failed', message: 'Incorrect Username or Password.');
      }
    } else {
      MLoaders.errorSnackBar(title: 'Login Failed', message: 'User not found.');
    }
  } catch (e) {
    // if (e is NetworkException) {
    //   MLoaders.errorSnackBar(title: 'Network Error', message: 'Unable to connect. Please check your network.');
    // } else {
      MLoaders.errorSnackBar(title: 'Oh Snap!', message: 'Something went wrong. Please try again.');
    // }
  } finally {
    MFullScreenLoader.stopLoading();
  }
}

  // Function to compare password
  bool _comparePassword(String inputPassword, String storedPassword) {
    // Hash the input password
    String hashedInputPassword = hashPassword(inputPassword);

    // Compare the hashed input password with the stored password
    return hashedInputPassword == storedPassword;
  }

  // Function to generate JWT
  String _generateJWT(Map<String, dynamic> payload) {
    final jwt = JWT(payload);

    // Sign the token with a secret key and set expiration to 8 hours
    return jwt.sign(SecretKey(Env.accessToken), expiresIn: const Duration(hours: 24));
  }

 hashPassword(String password) {
    var bytes = utf8.encode(password);  // Convert the password to a list of bytes
    var digest = sha256.convert(bytes);  // Hash using SHA-256
    return digest.toString();  // Convert hash to a hex string
  }

}