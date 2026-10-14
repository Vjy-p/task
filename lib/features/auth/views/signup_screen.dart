import 'package:assessment/features/auth/controllers/auth_controller.dart';
import 'package:assessment/features/auth/views/otp_screen.dart';
import 'package:assessment/features/profile/models/user_model.dart';
import 'package:assessment/utils/colors.dart';
import 'package:assessment/utils/constants.dart';
import 'package:assessment/utils/custom_button.dart';
import 'package:assessment/utils/custom_text_field.dart';
import 'package:assessment/utils/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final signUpKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final nameFocus = FocusNode();

  final email = TextEditingController();
  final emailFocus = FocusNode();

  final mobile = TextEditingController();
  final mobileFocus = FocusNode();

  UserType? userType;

  @override
  void initState() {
    if (!Get.isRegistered<AuthController>()) {
      Get.lazyPut(() => AuthController(), fenix: true);
    }
    super.initState();
  }

  @override
  void dispose() {
    name.dispose();
    nameFocus.dispose();
    mobile.dispose();
    mobileFocus.dispose();
    email.dispose();
    emailFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Form(
        key: signUpKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          physics: const BouncingScrollPhysics(),
          child: Column(
            spacing: 26,
            children: [
              CustomTextField(
                label: "Full Name",
                icon: const Icon(Icons.person),
                controller: name,
                currentFocus: nameFocus,
                nextFocus: mobileFocus,
              ),
              CustomTextField(
                label: "Mobile Number",
                icon: const Icon(Icons.phone),
                controller: mobile,
                currentFocus: mobileFocus,
                nextFocus: emailFocus,
                isMobileNumber: true,
              ),
              CustomTextField(
                label: "Email",
                icon: const Icon(Icons.email),
                controller: email,
                currentFocus: emailFocus,
                isEmail: true,
              ),
              userTypeWidget(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: CustomButton(
          label: "Submit",
          onPressed: () {
            if (signUpKey.currentState?.validate() == true &&
                userType != null) {
              Get.to(
                () => OtpScreen(
                  number: mobile.text.trim(),
                  userDetails: UserModel(
                    id: "",
                    name: name.text.trim(),
                    email: email.text.trim(),
                    mobileNumber: mobile.text.trim(),
                    userType: userType!,
                  ),
                  isFromSignUp: true,
                ),
              );
            } else {
              if (userType == null) {
                customToast(text: "Select user type");
              }
            }
          },
        ),
      ),
    );
  }

  Widget userTypeWidget() {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "User Type",
          style: TextStyle(fontSize: 15, color: CustomColors.textColor),
        ),
        Align(
          alignment: AlignmentGeometry.centerLeft,
          child: Wrap(
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            spacing: 20,
            runSpacing: 16,
            children: [
              radioTile(title: "Customer", value: UserType.customer),
              radioTile(title: "Delear", value: UserType.dealer),
              radioTile(title: "Plumber", value: UserType.plumber),
            ],
          ),
        ),
      ],
    );
  }

  Widget radioTile({required String title, required UserType value}) {
    return TextButton.icon(
      style: const ButtonStyle(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
      ),
      onPressed: () {
        setState(() {
          userType = value;
        });
      },
      label: Text(
        title,
        style: TextStyle(fontSize: 14, color: CustomColors.lightColor),
      ),
      icon: Container(
        height: 16,
        width: 16,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: userType == value
              ? CustomColors.primaryColor
              : CustomColors.lightColor.withValues(alpha: 0.1),
          shape: BoxShape.circle,
          border: Border.all(
            color: userType == value
                ? CustomColors.primaryColor
                : CustomColors.primaryColor.withValues(alpha: 0.4),
            width: 2,
          ),
        ),
      ),
    );
  }
}
