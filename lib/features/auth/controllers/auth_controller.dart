import 'dart:developer';

import 'package:assessment/core/bindings.dart';
import 'package:assessment/core/common_services.dart';
import 'package:assessment/features/auth/views/delear_onboarding_screen.dart';
import 'package:assessment/features/auth/views/otp_screen.dart';
import 'package:assessment/features/auth/views/plumber_onboarding_screen.dart';
import 'package:assessment/features/customer/views/customer_dashboard.dart';
import 'package:assessment/features/delear/views/delear_dashboard.dart';
import 'package:assessment/features/plumber/views/plumber_dashboard.dart';
import 'package:assessment/features/profile/models/user_model.dart';
import 'package:assessment/main.dart';
import 'package:assessment/utils/constants.dart';
import 'package:assessment/utils/custom_toast.dart';
import 'package:get/get.dart';

import '../data/auth_repository.dart';

class AuthController extends GetxController {
  AuthController({AuthRepository? repository})
    : _repository = repository ?? AuthRepository();
  final AuthRepository _repository;

  final isLoading = false.obs;

  Future login({required String mobile, required String otp}) async {
    isLoading.value = true;

    try {
      final resp = await _repository.loginWithOtp(mobile: mobile, otp: otp);
      log("login resp $resp");
      if (resp != null) {
        await CommonServices().setUserUid(uid: mobile);
        CommonServices().getUserDetails();
        await CommonServices().setUserLoggedIn(value: true);
        await CommonServices().setToken(token: "", refreshToken: "");
        InitialBindings().dependencies();
        if (resp.userType == UserType.customer) {
          Get.offAll(() => const CustomerDashboard());
        } else if (resp.userType == UserType.dealer) {
          if (resp.isVerified == true) {
            Get.offAll(() => const DelearDashboard());
          } else {
            Get.offAll(() => DelearOnboardingScreen(user: resp));
          }
        } else if (resp.userType == UserType.plumber) {
          if (resp.isVerified == true) {
            Get.offAll(() => const PlumberDashboard());
          } else {
            Get.offAll(() => PlumberOnboardingScreen(user: resp));
          }
        }
      }
      isLoading.value = false;
      return true;
    } catch (error, stackTree) {
      log("Error login $error $stackTree");
      isLoading.value = false;
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> requestOtp({
    required String mobile,
    required bool isFromSignUp,
  }) async {
    isLoading.value = true;

    try {
      // await _repository.requestOtp(mobile: mobile);
      // final user = CommonServices().getUserDetails();
      final uids = CommonServices().getUsersUidList();
      if (uids.contains(mobile)) {
        await CommonServices().setUserUid(uid: mobile);
        Get.to(() => OtpScreen(isFromSignUp: isFromSignUp, number: mobile));
      } else {
        customToast(text: "Don't have an account with this number");
      }
      isLoading.value = false;
      return true;
    } catch (error, stackTree) {
      log("Error request otp $error $stackTree");
      isLoading.value = false;
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future signUp({
    required String name,
    required String mobile,
    String? email,
    required UserType selectedRole,
    required String otp,
  }) async {
    isLoading.value = true;

    try {
      // final resp = await _repository.signupAndVerifyOtp(
      //   name: name,
      //   mobile: mobile,
      //   email: email,
      //   selectedRole: selectedRole.toString(),
      //   otp: otp,
      // );
      // if (resp != null) {
      UserModel user = UserModel(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        name: name,
        email: email,
        mobileNumber: mobile,
        userType: selectedRole,
      );
      await CommonServices().setUserDetails(user: user);
      await CommonServices().setUserLoggedIn(value: true);
      await CommonServices().setToken(token: "", refreshToken: "");

      InitialBindings().dependencies();
      if (selectedRole == UserType.customer) {
        Get.offAll(() => const CustomerDashboard());
      } else if (selectedRole == UserType.dealer) {
        Get.offAll(() => DelearOnboardingScreen(user: user));
      } else if (selectedRole == UserType.plumber) {
        Get.offAll(() => PlumberOnboardingScreen(user: user));
      }
      // }
      isLoading.value = false;
    } catch (error, stackTree) {
      log("Error sign up $error $stackTree");
      isLoading.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  Future signout() async {
    isLoading.value = true;

    try {
      await CommonServices().setUserLoggedIn(value: false);
      isLoading.value = false;
      Get.deleteAll();
      InitialBindings().dependencies();
      Get.offAll(() => const SplashScreen());
    } catch (error) {
      isLoading.value = false;
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
