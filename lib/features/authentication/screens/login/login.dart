import 'package:flutter/material.dart';
import 'package:easyapp/common/styles/spacing_styles.dart';
import 'package:easyapp/features/authentication/screens/login/widgets/login_form.dart';
import 'package:easyapp/features/authentication/screens/login/widgets/login_header.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              //Logo, Title & Subtitle
              MLoginHeader(),
              MLoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}

