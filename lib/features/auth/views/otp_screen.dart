import 'dart:developer';

import 'package:assessment/features/auth/controllers/auth_controller.dart';
import 'package:assessment/features/profile/models/user_model.dart';
import 'package:assessment/utils/colors.dart';
import 'package:assessment/utils/custom_button.dart';
import 'package:assessment/utils/custom_loading.dart';
import 'package:assessment/utils/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:smart_auth/smart_auth.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({
    super.key,
    required this.number,
    required this.isFromSignUp,
    this.userDetails,
  });
  final bool isFromSignUp;
  final String number;
  final UserModel? userDetails;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final otpKey = GlobalKey<FormState>();
  final otp = TextEditingController();
  final otpFocus = FocusNode();
  late final SmsRetriever smsRetriever;

  final controller = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    smsRetriever = SmsRetrieverImpl(SmartAuth.instance);
  }

  @override
  void dispose() {
    otp.dispose();
    otpFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: otpKey,
      child: Scaffold(
        appBar: AppBar(title: const Text("OTP")),
        bottomNavigationBar: BottomAppBar(
          child: Obx(() {
            return controller.isLoading.value
                ? const CustomLoading()
                : CustomButton(
                    label: "Submit",
                    onPressed: () {
                      if (otpKey.currentState?.validate() == true) {
                        if (widget.isFromSignUp && widget.userDetails != null) {
                          controller.signUp(
                            name: widget.userDetails!.name,
                            mobile: widget.userDetails!.mobileNumber,
                            selectedRole: widget.userDetails!.userType,
                            email: widget.userDetails!.email,
                            otp: otp.text,
                          );
                        } else {
                          controller.login(
                            mobile: widget.number,
                            otp: otp.text,
                          );
                        }
                      } else {
                        customToast(text: "Enter correct OTP!");
                      }
                    },
                  );
          }),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 26),
          physics: const BouncingScrollPhysics(),
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("OTP sent to mobile number : ${widget.number}"),
              Center(
                child: Pinput(
                  // smsRetriever: smsRetriever,
                  controller: otp,
                  focusNode: otpFocus,
                  validator: (s) {
                    return s?.length == 4 ? null : 'Pin is incorrect';
                  },
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  showCursor: true,
                  mainAxisAlignment: MainAxisAlignment.center,
                  onCompleted: (pin) {
                    log(pin);
                  },
                  defaultPinTheme: customPinTheme(),
                  focusedPinTheme: customPinTheme(
                    textColor: CustomColors.textColor,
                  ),
                  errorPinTheme: customPinTheme(
                    textColor: CustomColors.redColor,
                  ),
                  disabledPinTheme: customPinTheme(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PinTheme customPinTheme({
    double? size,
    Color? textColor,
    double? fontSize,
    FontWeight? fontWeight,
  }) {
    return PinTheme(
      width: size ?? 52,
      height: size ?? 52,
      textStyle: TextStyle(
        fontSize: fontSize ?? 20,
        color: textColor ?? CustomColors.textColor,
        fontWeight: fontWeight ?? FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color:
              textColor?.withValues(alpha: 0.5) ??
              CustomColors.textColor.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class SmsRetrieverImpl implements SmsRetriever {
  const SmsRetrieverImpl(this.smartAuth);

  final SmartAuth smartAuth;

  @override
  Future<void> dispose() {
    return smartAuth.removeUserConsentApiListener();
  }

  @override
  Future<String?> getSmsCode() async {
    final signature = await smartAuth.getAppSignature();
    debugPrint('App Signature: $signature');
    final res = await smartAuth.getSmsWithUserConsentApi();
    return res.data?.code;
  }

  @override
  bool get listenForMultipleSms => false;
}
