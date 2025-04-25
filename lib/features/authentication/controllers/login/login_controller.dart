import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:easyapp/data/provider/api_provider.dart';
import 'package:easyapp/features/authentication/models/user/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:easyapp/SQLite/sqlite.dart';
import 'package:easyapp/data/repositories/authentication/authentication_repository.dart';
import 'package:easyapp/utils/constants/image_strings.dart';
import 'package:easyapp/utils/helpers/network_manager.dart';
import 'package:easyapp/utils/popups/full_screen_loader.dart';
import 'package:easyapp/utils/popups/loaders.dart';


class LoginController extends GetxController{
  static LoginController get instance =>Get.find();
  // Initialize the database instance here
  final LocalDatabase db = LocalDatabase.instance;
  final apiProvider = ApiProvider();
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


    // Form validation
    if (!loginFormKey.currentState!.validate()) {
      MLoaders.errorSnackBar(title: 'Validation Error', message: 'Please enter valid credentials.');
      return;
    }
    // Get current date
    DateTime now = DateTime.now();
    
    // Format date as DDMMYYYY 
    String date = '${now.day.toString().padLeft(2, '0')}${now.month.toString().padLeft(2, '0')}${now.year}';

    // Save data if "remember me" is selected
    if (rememberMe.value) {   
      localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
      localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      localStorage.write('REMEMBER_ME_DATE', date);
    }

    // Check if the saved date is more than 2 days old
    String? savedDate = localStorage.read('REMEMBER_ME_DATE');
    if (savedDate != null) {
      DateTime savedDateTime = DateTime.parse('${savedDate.substring(4)}-${savedDate.substring(2, 4)}-${savedDate.substring(0, 2)}');
      if (now.difference(savedDateTime).inDays > 2) {
      localStorage.remove('REMEMBER_ME_EMAIL');
      localStorage.remove('REMEMBER_ME_PASSWORD');
      localStorage.remove('REMEMBER_ME_DATE');
      }
    }

    // Log in the user from SQLite db
    final result = await db.login(email.text.trim());

    if (result != null) {
      final setting = await db.getSingleAppSetting();
      if (setting == null || setting['appKey'] == null) {
        throw Exception("APP Key not found!");
      }

      String storedPassword = result[0]['password'];
      bool passwordMatches = comparePassword(password.text.trim(), storedPassword);
      int userStatus = result[0]['userStatus'];
      int licStatus = result[0]['licStatus'];
      String username = result[0]['username'];
      if (passwordMatches) {
        
        // Non-admin user login logic
        if (username != 'admin') {
          if (licStatus == 0 ||  userStatus == 0) {
            // Check Internet connectivity
            final isConnected = await NetworkManager.instance.isConnected();
            if (!isConnected) {
              MLoaders.errorSnackBar( title: 'No Internet',message: 'Please check your internet connection and try again.');
              return;
            }
            
            // Query user status from API
            final checkAppUser = await apiProvider.checkAppUser(username, email.text.trim());
           
            if (checkAppUser['userStatus'] == 0 || checkAppUser['licStatus'] == 0) {
              MLoaders.errorSnackBar(title: 'Authentication Error',message: 'Account locked. Kindly connect to the internet or contact your administrator!');
              return;
            }

            // Update local DB and proceed to login
            final users = UserModel(
              userName: username,
              email: email.text.trim(),
              password: storedPassword,
              role: "user",
              status: 1,
              userStatus: (checkAppUser['userStatus'] == 1) ? 1 : 0,
              licStatus: (checkAppUser['licStatus'] == 1) ? 1 : 0,
              updatedAt: DateTime.now().toIso8601String(),
              createdAt: DateTime.now().toIso8601String(),
            );

            await db.insertUser(users);
          }
        }
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
  bool comparePassword(String inputPassword, String storedPassword) {
    // Hash the input password
    String hashedInputPassword = hashPassword(inputPassword);

    // Compare the hashed input password with the stored password
    return hashedInputPassword == storedPassword;
  }

  // Function to generate JWT
  // String _generateJWT(Map<String, dynamic> payload) {
  //   final jwt = JWT(payload);

  //   // Sign the token with a secret key and set expiration to 8 hours
  //   return jwt.sign(SecretKey(Env.accessToken), expiresIn: const Duration(hours: 24));
  // }

 hashPassword(String password) {
    var bytes = utf8.encode(password);  // Convert the password to a list of bytes
    var digest = sha256.convert(bytes);  // Hash using SHA-256
    return digest.toString();  // Convert hash to a hex string
  }

}