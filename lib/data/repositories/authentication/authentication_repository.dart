import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:multiapp/SQLite/sqlite.dart';
import 'package:multiapp/features/authentication/screens/login/login.dart';
import 'package:multiapp/features/authentication/screens/onboarding/onboarding.dart';
import 'package:multiapp/navigation_menu.dart';
import 'package:multiapp/utils/local_storage/storage_utility.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find(); 
 
  // Initialize the database instance here
  final LocalDatabase db = LocalDatabase.instance;
  RxString currentUser = ''.obs;
  RxString currentUserRole = ''.obs;
  RxString currentUserId  = ''.obs;
  // RxString isRSP  = ''.obs;
  RxBool isRetailPrice = false.obs;
  RxString appKey  = ''.obs;
  RxBool isQuantityPrice  = false.obs;
  //Variables
  final deviceStorage = GetStorage();
  // final _auth = FirebaseAuth.instance;
  // final GoogleSignIn googleSignIn = GoogleSignIn();

  //Get Authenticated user data
  // User? get authUser => _auth.currentUser;

  //Called from amin.dart on app launch
  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect(); //pass current user
    // Now call the async method to insert test product
    // _clearOrderData();
  }

  // Future<void> _clearOrderData() async {
  //   await db.resetDatabase();
  //    await db.insertTestProduct();
  //   //  await db.readAllData();
  //   // print('Test product inserted successfully');
  // }

 
Future<Map<String, dynamic>?> decodeAndVerifyToken() async {
  // Retrieve the JWT token from local storage
  final jwtToken = deviceStorage.read('jwt_token') ?? "";
  if (jwtToken.isEmpty) {
    print("No JWT token found in local storage.");
    return null;
  }

  // Retrieve the app key
  final setting = await db.getSingleAppSetting();
  if (setting == null || setting['appKey'] == null) {
    return null;
  }
  // Check if the setting exists and contains the 'IsRSP' field
  final isRsp = setting['IsRSP'] ?? 0; // Default to 0 if null

  // Update the observable value based on the 'IsRSP' field
  isRetailPrice.value = (isRsp == 1); // Assume 1 indicates true (retail price)
  appKey.value = setting['appKey'];

  final decodedToken = JWT.decode(jwtToken);

  //  Assign values to the current user variables
  currentUser.value = decodedToken.payload['username'];
  currentUserId.value = decodedToken.payload['userId'].toString();
  currentUserRole.value = decodedToken.payload['role'];
  try {
    // Verify the token using the secret key
    final jwt = JWT.verify(jwtToken, SecretKey(appKey.value));

    // Token is valid, extract the payload
    // print("Token is valid. Payload: ${jwt.payload}");
    return jwt.payload;
  } on JWTExpiredException {
    // print('Token has expired.');
    // await logout();
  } on JWTException catch (e) {
    // print('Invalid token: $e');
    await logout();
  } catch (e) {
    // print('Unexpected error during token verification: $e');
    await logout();
  }

  return null;
}

Future<String?> refreshToken() async {
  try {
    // Prepare payload for the new token
    final payload = {
      'userId': currentUserId.value,
      'username': currentUser.value,
      'role': currentUserRole.value,
    };
    
    // Fetch the App Key from the database
    final setting = await db.getSingleAppSetting();
    if (setting == null || setting['appKey'] == null) {
      return null;
    }
    final appKey = setting['appKey'];

    // Generate a new JWT token
    final jwt = JWT(payload);
    final newJwtToken = jwt.sign(SecretKey(appKey), expiresIn: const Duration(minutes: 2));

    // Save the new token to local storage
    deviceStorage.write('jwt_token', newJwtToken);

    return newJwtToken;
  } on JWTExpiredException {
    // print("Token refresh failed due to expired token.");
    return null;
  } catch (e) {
    // print("Unexpected error while refreshing token: $e");
    return null;
  }
}

  //Fn to show relevant screen
  screenRedirect() async {
    // Decode and verify the token
    final decodedPayload = await decodeAndVerifyToken();
    if (decodedPayload != null) {
      // Extract user information from the payload
      final userId = decodedPayload['userId']
          .toString(); // Now you can access fields using []

      //Initialize User specific storage
      await MLocalStorage.init(userId);
      // CartController.instance.clearCart();

      //If the user's email is verified, navigate to the main navigation menu
      Get.offAll(() => const NavigationMenu());
    } else {
    //   Get.offAll(
    //       const OnBoardingScreen()); //Redirect to Onboarding screen if it's the first time
    // }
    
      deviceStorage.writeIfNull('isFirstTime', true);
        deviceStorage.read('isFirstTime') != true 
        ? Get.offAll(() => const LoginScreen())  //Redirect to login screen if not the first time
        : Get.offAll(() =>const OnBoardingScreen());   //Redirect to Onboarding screen if it's the first time
    }
  }

  //Logout user
  Future<void> logout() async {
    try {
      //Clear token
      deviceStorage.remove('jwt_token');
      // deviceStorage.remove('isFirstTime');
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}
