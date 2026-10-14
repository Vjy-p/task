import 'dart:convert';

import 'package:assessment/features/profile/models/user_model.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CommonServices {
  Box<String> get userBox => Hive.box<String>("user");
  Box<List<String>> get userBoxList => Hive.box<List<String>>("userIds");

  Future<void> setUserUid({required String uid}) async {
    await userBox.put("uid", uid);
    List<String> uids = getUsersUidList();
    uids.addIf(!uids.contains(uid), uid);
    await setUsersUidList(uids: uids);
  }

  String getUserUid() {
    if (!Hive.isBoxOpen("user")) return "";
    String uid = userBox.get("uid") ?? "";
    return uid;
  }

  Future<void> setUsersUidList({required List<String> uids}) async {
    await userBoxList.put("uidList", uids);
  }

  List<String> getUsersUidList() {
    if (!Hive.isBoxOpen("userIds")) return [];
    List<String> uids = userBoxList.get("uidList") ?? [];
    return uids;
  }

  String userScopedKey(String key) {
    final uid = getUserUid();
    return "${uid}_$key";
  }

  Future<void> setUserDetails({required UserModel user}) async {
    await setUserUid(uid: user.mobileNumber);
    String value = jsonEncode(user.toMap());
    await userBox.put(userScopedKey("userDetails"), value);
    List<String> uids = getUsersUidList();
    uids.addIf(!uids.contains(user.mobileNumber), user.id);
    await setUsersUidList(uids: uids);
    // log("\nset userDetaials: $user");
  }

  UserModel? getUserDetails() {
    if (!Hive.isBoxOpen("user")) return null;
    String user = userBox.get(userScopedKey("userDetails")) ?? "";
    // log("userDetails : $user ${userBox.values.toString()}");
    if (user.isEmpty) {
      return null;
    }
    Map<String, dynamic> userMap = jsonDecode(user);
    return UserModel.fromMap(userMap);
  }

  Future<void> setToken({
    required String token,
    required String refreshToken,
  }) async {
    await userBox.put(userScopedKey("token"), token);
    await userBox.put(userScopedKey("refreshToken"), refreshToken);
  }

  Future<String> getToken() async {
    return userBox.get(userScopedKey("token")) ?? "";
  }

  Future<String> getRefreshToken() async {
    return userBox.get(userScopedKey("refreshToken")) ?? "";
  }

  bool getUserLoggedIn() {
    String isLoggedIn = userBox.get("userLoggedIn") ?? "";
    return isLoggedIn == "true";
  }

  Future setUserLoggedIn({required bool value}) async {
    await userBox.put("userLoggedIn", value.toString());
  }
}
