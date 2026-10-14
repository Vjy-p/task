import 'package:hive/hive.dart';

part 'constants.g.dart';

class Constants {
  static String baseUrl = const String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://dummyjson.com',
  );
}

@HiveType(typeId: 9)
enum UserType {
  @HiveField(0)
  customer,
  @HiveField(1)
  dealer,
  @HiveField(2)
  plumber,
}
