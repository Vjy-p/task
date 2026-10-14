import 'dart:developer';
import 'dart:io';

import 'package:assessment/core/common_services.dart';
import 'package:assessment/features/plumber/views/plumber_dashboard.dart';
import 'package:assessment/features/profile/models/user_model.dart';
import 'package:assessment/utils/colors.dart';
import 'package:assessment/utils/custom_button.dart';
import 'package:assessment/utils/custom_text_field.dart';
import 'package:assessment/utils/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PlumberOnboardingScreen extends StatefulWidget {
  const PlumberOnboardingScreen({super.key, required this.user});
  final UserModel user;

  @override
  State<PlumberOnboardingScreen> createState() =>
      _PlumberOnboardingScreenState();
}

class _PlumberOnboardingScreenState extends State<PlumberOnboardingScreen> {
  final plumberKey = GlobalKey<FormState>();

  final aadhar = TextEditingController();
  final aadharFocus = FocusNode();

  final address = TextEditingController();
  final addressFocus = FocusNode();
  final ImagePicker imageProvider = ImagePicker();
  XFile? pickedImage;

  @override
  void dispose() {
    aadhar.dispose();
    aadharFocus.dispose();
    address.dispose();
    addressFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("On-Boarding")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: plumberKey,
          child: Column(
            spacing: 20,
            children: [
              InkWell(
                onTap: () {
                  pickImage();
                },
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: CustomColors.lightColor,
                    shape: BoxShape.circle,
                  ),
                  clipBehavior: Clip.none,
                  child: Stack(
                    children: [
                      pickedImage == null
                          ? const SizedBox()
                          : Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: CustomColors.lightColor,
                                shape: BoxShape.circle,
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image.file(
                                File(pickedImage!.path),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                      Positioned(
                        right: -1,
                        bottom: 5,
                        child: InkWell(
                          child: const Icon(Icons.add_a_photo_rounded, size: 24),
                          onTap: () {
                            pickImage();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              CustomTextField(
                label: "Aadhar Number",
                icon: const Icon(Icons.person_3),
                controller: aadhar,
                currentFocus: aadharFocus,
                nextFocus: addressFocus,
                maxCount: 12,
              ),
              CustomTextField(
                label: "Address",
                icon: const Icon(Icons.pin_drop),
                controller: address,
                currentFocus: addressFocus,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: CustomButton(
          label: "Submit",
          onPressed: () {
            if (plumberKey.currentState?.validate() == true &&
                pickedImage != null) {
              widget.user.isVerified = true;
              CommonServices().setUserDetails(user: widget.user);
              Get.offAll(() => const PlumberDashboard());
            } else {
              if (pickedImage == null) {
                customToast(text: "Select profile image");
              }
            }
          },
        ),
      ),
    );
  }

  Future pickImage() async {
    try {
      pickedImage = await imageProvider.pickImage(source: ImageSource.gallery);
      setState(() {});
    } catch (e) {
      log("Error in pick image $e");
      customToast(text: "Something went wrong!");
    }
  }
}
