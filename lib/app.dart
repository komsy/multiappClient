import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:multiapp/bindings/general_bindings.dart';
import 'package:multiapp/utils/constants/colors.dart';
import 'package:multiapp/utils/constants/text_strings.dart';
import 'package:multiapp/utils/theme/theme.dart';

import 'routes/app_routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: MTexts.appName,
      themeMode: ThemeMode.system,
      theme: MAppTheme.lightTheme,
      darkTheme: MAppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      initialBinding: GeneralBindings(), //Initiate Nretwork Manger
      getPages: AppRoutes.pages,

      //Show loader or circular progress indicator meanwhile authentication repository is decidding to show relevant screen
      home: const Scaffold(backgroundColor: MColors.primary,body: Center(child: CircularProgressIndicator(color: Colors.white))),
      // home: const OnBoardingScreen()
    );
  }
}
