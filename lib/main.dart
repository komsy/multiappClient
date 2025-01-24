import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:multiapp/app.dart';
import 'data/repositories/authentication/authentication_repository.dart';

Future <void> main() async{
  //Add Widgets binding
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  //GetX Local Storage
  await GetStorage.init();

  //Await Splash until other items load
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  //Initialize Firebase& Authentication repository
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then(
  //   (FirebaseApp value) => Get.put(AuthenticationRepository()));
  Get.put(AuthenticationRepository());
  runApp(const App());
}