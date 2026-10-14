import 'package:assessment/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

Future customToast({required String text}) async {
  Get.showSnackbar(
    GetSnackBar(
      backgroundColor: CustomColors.blackColor,
      messageText: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14, color: CustomColors.whiteColor),
      ),
      margin: const EdgeInsets.all(20),
      borderRadius: 12,
      snackStyle: SnackStyle.FLOATING,
      duration: const Duration(seconds: 3),
      // showProgressIndicator: true,
    ),
  );
}
