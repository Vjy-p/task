import 'package:assessment/core/bindings.dart';
import 'package:assessment/core/common_services.dart';
import 'package:assessment/core/hive_adapters.dart';
import 'package:assessment/features/auth/controllers/auth_controller.dart';
import 'package:assessment/features/auth/views/delear_onboarding_screen.dart';
import 'package:assessment/features/auth/views/login_screen.dart';
import 'package:assessment/features/auth/views/plumber_onboarding_screen.dart';
import 'package:assessment/features/auth/views/signup_screen.dart';
import 'package:assessment/features/customer/views/customer_dashboard.dart';
import 'package:assessment/features/delear/views/delear_dashboard.dart';
import 'package:assessment/features/plumber/views/plumber_dashboard.dart';
import 'package:assessment/features/profile/models/user_model.dart';
import 'package:assessment/utils/colors.dart';
import 'package:assessment/utils/constants.dart';
import 'package:assessment/utils/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  await initialise();
  runApp(const MyApp());
}

Future<void> initialise() async {
  final dir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(dir.path);
  registerHiveAdapters();
  await Hive.openBox<String>("user");
  await Hive.openBox<List<String>>("userIds");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBindings(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: CustomColors.primaryColor),
        useMaterial3: true,
        appBarTheme: AppBarTheme(backgroundColor: CustomColors.whiteColor),
        scaffoldBackgroundColor: CustomColors.whiteColor,
        inputDecorationTheme: InputDecorationTheme(
          prefixIconColor: CustomColors.primaryColor,
        ),
        iconTheme: IconThemeData(color: CustomColors.primaryColor),
        primaryIconTheme: IconThemeData(color: CustomColors.primaryColor),
        cardTheme: CardThemeData(
          elevation: 0,
          color: CustomColors.whiteColor,
          margin: EdgeInsets.zero,
        ),
      ),
      home: const SplashScreen(),
      // onGenerateRoute: (settings) {
      //   return MaterialPageRoute(builder: (context) => SplashScreen());
      // },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    if (!Get.isRegistered<AuthController>()) {
      Get.lazyPut(() => AuthController(), fenix: true);
    }
    super.initState();
    loginCheck();
  }

  Future loginCheck() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      bool isLoggedIn = CommonServices().getUserLoggedIn();
      UserModel? user = CommonServices().getUserDetails();

      if (isLoggedIn && user != null) {
        if (user.userType == UserType.customer) {
          Get.offAll(() => const CustomerDashboard());
        } else if (user.userType == UserType.dealer) {
          if (user.isVerified == true) {
            Get.offAll(() => const DelearDashboard());
          } else {
            Get.offAll(() => DelearOnboardingScreen(user: user));
          }
        } else if (user.userType == UserType.plumber) {
          if (user.isVerified == true) {
            Get.offAll(() => const PlumberDashboard());
          } else {
            Get.offAll(() => PlumberOnboardingScreen(user: user));
          }
        }
      } else if (!isLoggedIn && user != null) {
        Get.offAll(() => const LoginScreen());
      } else {
        Get.offAll(() => const SignupScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: CustomLoading());
  }
}
