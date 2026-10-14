import 'dart:io';

import 'package:assessment/core/common_services.dart';
import 'package:assessment/features/auth/controllers/auth_controller.dart';
import 'package:assessment/features/cart/views/cart_screen.dart';
import 'package:assessment/features/customer/views/customer_dashboard.dart';
import 'package:assessment/features/profile/models/user_model.dart';
import 'package:assessment/utils/colors.dart';
import 'package:assessment/utils/constants.dart';
import 'package:assessment/utils/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.onSelectTab});

  final void Function(int index)? onSelectTab;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? user = CommonServices().getUserDetails();

  void _onTabSelected(int tabIndex) {
    if (widget.onSelectTab != null) {
      Get.back();
      widget.onSelectTab!(tabIndex);
    } else {
      Get.offAll(() => CustomerDashboard(index: tabIndex));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          physics: const BouncingScrollPhysics(),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              profileWidget(),
              const Divider(),
              if (user?.userType == UserType.plumber) ...[
                listTileWidget(
                  label: "Activities",
                  onTap: () {
                    _onTabSelected(1);
                  },
                ),
              ] else ...[
                listTileWidget(
                  label: "Orders",
                  onTap: () {
                    _onTabSelected(1);
                  },
                ),
                listTileWidget(
                  label: "Cart",
                  onTap: () {
                    if (widget.onSelectTab != null) {
                      Get.back();
                    }
                    Get.to(() => const CartScreen());
                  },
                ),
              ],
              listTileWidget(
                label: "Notifications",
                onTap: () {
                  _onTabSelected(2);
                },
              ),
              listTileWidget(
                label: "Home",
                onTap: () {
                  _onTabSelected(0);
                },
              ),
              const SizedBox(height: 100),
              logout(),
            ],
          ),
        ),
      ),
    );
  }

  Widget profileWidget() {
    return Row(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: user?.profilePath?.isNotEmpty == true
              ? FileImage(File(user?.profilePath ?? ""))
              : null,
        ),
        Column(
          spacing: 2,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user?.name ?? "",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(user?.mobileNumber ?? "", style: const TextStyle(fontSize: 14)),
            if (user?.email?.isNotEmpty == true)
              Text(user?.email ?? "", style: const TextStyle(fontSize: 14)),
          ],
        ),
      ],
    );
  }

  Widget listTileWidget({required String label, required onTap}) {
    return MaterialButton(
      onPressed: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(10),
      ),
      color: CustomColors.whiteColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 20),
        ],
      ),
    );
  }

  Widget logout() {
    return CustomButton(
      label: "Logout",
      onPressed: () {
        openDialogBox();
      },
    );
  }

  Future<dynamic> openDialogBox() {
    return Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(16),
        ),
        child: Container(
          // height: Get.height * 0.4,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.all(20),
          child: Column(
            spacing: 50,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Are you sure to Logout!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.2,
                  color: CustomColors.textColor,
                ),
              ),
              Row(
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    label: "No",
                    buttonColor: CustomColors.lightColor,
                    onPressed: () {
                      Get.back();
                    },
                  ),
                  CustomButton(
                    label: "Yes",
                    onPressed: () {
                      Get.find<AuthController>().signout();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
