import 'dart:convert';

import 'package:assessment/utils/constants.dart';
import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 8)
class UserModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String? email;
  @HiveField(3)
  String mobileNumber;
  @HiveField(4)
  UserType userType;
  @HiveField(5)
  bool? isVerified;
  @HiveField(6)
  String? profilePath;

  UserModel({
    required this.id,
    required this.name,
    this.email,
    required this.mobileNumber,
    required this.userType,
    this.isVerified,
    this.profilePath,
  });

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
    id: json['id']?.toString() ?? '',
    name: json['name']?.toString() ?? '',
    email: json['email']?.toString(),
    mobileNumber: json['mobileNumber']?.toString() ?? '',
    userType: _parseUserType(json['userType'] ?? json['selectedRole'] ?? json['role']),
    isVerified: json['isVerified'] as bool?,
    profilePath: json['profilePath']?.toString(),
  );

  static UserType _parseUserType(dynamic value) {
    if (value is UserType) return value;
    if (value is String) {
      final clean = value.split('.').last.toLowerCase().trim();
      return UserType.values.firstWhere(
        (e) => e.name.toLowerCase() == clean,
        orElse: () => UserType.customer,
      );
    }
    if (value is int && value >= 0 && value < UserType.values.length) {
      return UserType.values[value];
    }
    return UserType.customer;
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "email": email,
    "mobileNumber": mobileNumber,
    "userType": userType.name,
    "isVerified": isVerified,
    "profilePath": profilePath,
  };

  String toJson() => jsonEncode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(jsonDecode(source) as Map<String, dynamic>);
}
