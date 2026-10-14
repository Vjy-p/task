import 'package:assessment/features/auth/controllers/auth_controller.dart';
import 'package:assessment/features/auth/views/signup_screen.dart';
import 'package:assessment/utils/colors.dart';
import 'package:assessment/utils/custom_button.dart';
import 'package:assessment/utils/custom_loading.dart';
import 'package:assessment/utils/custom_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final loginKey = GlobalKey<FormState>();

  final mobile = TextEditingController();
  final mobileFocus = FocusNode();

  final controller = Get.find<AuthController>();

  @override
  void dispose() {
    mobile.dispose();
    mobileFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Form(
        key: loginKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          physics: const BouncingScrollPhysics(),
          child: Column(
            spacing: 20,
            children: [
              CustomTextField(
                label: "Mobile Number",
                icon: const Icon(Icons.phone),
                controller: mobile,
                currentFocus: mobileFocus,
                isMobileNumber: true,
                onChanged: (p0) {
                  setState(() {});
                },
              ),
              Divider(
                indent: 100,
                endIndent: 100,
                radius: BorderRadius.circular(6),
              ),
              RichText(
                text: TextSpan(
                  text: "Don't have an account? ",
                  style: TextStyle(
                    color: CustomColors.lightColor,
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    TextSpan(
                      text: "Sign up",
                      style: TextStyle(
                        color: CustomColors.textColor,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.4,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Get.to(() => const SignupScreen()),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Obx(() {
          return controller.isLoading.value
              ? const CustomLoading()
              : CustomButton(
                  label: "Submit",
                  onPressed: () {
                    if (loginKey.currentState?.validate() == true) {
                      controller.requestOtp(
                        mobile: mobile.text.trim(),
                        isFromSignUp: false,
                      );
                    } else {
                      // customToast(text: "Enter Mobile Number");
                    }
                  },
                );
        }),
      ),
    );
  }
}
