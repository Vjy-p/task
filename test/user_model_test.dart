import 'dart:convert';
import 'package:assessment/features/profile/models/user_model.dart';
import 'package:assessment/utils/constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserModel JSON tests', () {
    test('serializes toMap and encodes to JSON without error', () {
      final user = UserModel(
        id: '123',
        name: 'Test User',
        email: 'test@example.com',
        mobileNumber: '9876543210',
        userType: UserType.customer,
      );

      final map = user.toMap();
      expect(map['userType'], 'customer');

      final jsonStr = jsonEncode(map);
      expect(jsonStr, contains('"userType":"customer"'));

      final decodedMap = jsonDecode(jsonStr) as Map<String, dynamic>;
      final fromJsonUser = UserModel.fromMap(decodedMap);

      expect(fromJsonUser.id, '123');
      expect(fromJsonUser.name, 'Test User');
      expect(fromJsonUser.userType, UserType.customer);
    });

    test('deserializes UserType correctly from different formats', () {
      final dealerMap = {
        'id': '1',
        'name': 'Dealer 1',
        'email': null,
        'mobileNumber': '111',
        'userType': 'dealer',
      };
      expect(UserModel.fromMap(dealerMap).userType, UserType.dealer);

      final plumberMap = {
        'id': '2',
        'name': 'Plumber 1',
        'email': null,
        'mobileNumber': '222',
        'userType': 'UserType.plumber',
      };
      expect(UserModel.fromMap(plumberMap).userType, UserType.plumber);

      final roleMap = {
        'id': '3',
        'name': 'User 3',
        'email': null,
        'mobileNumber': '333',
        'selectedRole': 'customer',
      };
      expect(UserModel.fromMap(roleMap).userType, UserType.customer);
    });
  });
}
