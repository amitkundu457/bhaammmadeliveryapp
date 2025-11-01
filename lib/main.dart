import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:bhamma_delivery_boy/screen/auth/login_screen.dart';
import 'package:bhamma_delivery_boy/screen/auth/signup_screen.dart';
import 'package:bhamma_delivery_boy/screen/auth/LoginWithPhone/verify_phone_number_screen.dart';
import 'package:bhamma_delivery_boy/screen/bank_details_page.dart';
import 'package:bhamma_delivery_boy/screen/change_password.dart';
import 'package:bhamma_delivery_boy/screen/document_verification/document_verification_waiting_screen.dart';
import 'package:bhamma_delivery_boy/screen/document_verification/driveing_licens_verification_secreen.dart';
import 'package:bhamma_delivery_boy/screen/document_verification/passportVerificationScreen.dart';
import 'package:bhamma_delivery_boy/screen/document_verification/submit_doc_screen.dart';
import 'package:bhamma_delivery_boy/screen/document_verification/trc_verification_screen.dart';
import 'package:bhamma_delivery_boy/screen/document_verification/vehicle_type_screen.dart';
import 'package:bhamma_delivery_boy/screen/forgot_password_screen.dart';
import 'package:bhamma_delivery_boy/screen/home_screen.dart';
import 'package:bhamma_delivery_boy/screen/orders/assigned_order_list_screen.dart';
import 'package:bhamma_delivery_boy/screen/orders/delivered_order_list_screen.dart';
import 'package:bhamma_delivery_boy/screen/orders/order_details_screen.dart';
import 'package:bhamma_delivery_boy/screen/orders/order_screen.dart';
import 'package:bhamma_delivery_boy/screen/orders/otv_set_screen.dart';
import 'package:bhamma_delivery_boy/screen/profile/pages/announcements_screen.dart';
import 'package:bhamma_delivery_boy/screen/profile/pages/dispute_items_list.dart';
import 'package:bhamma_delivery_boy/screen/profile/pages/dispute_page.dart';
import 'package:bhamma_delivery_boy/screen/profile/pages/earning_screen%20copy.dart';
import 'package:bhamma_delivery_boy/screen/profile/pages/earning_screen.dart';
import 'package:bhamma_delivery_boy/screen/profile/pages/emergency_SOS_screen.dart';
import 'package:bhamma_delivery_boy/screen/profile/pages/help_support_screen.dart';
import 'package:bhamma_delivery_boy/screen/profile/pages/incentives_screen.dart';
import 'package:bhamma_delivery_boy/screen/profile/pages/notification_screen.dart';
import 'package:bhamma_delivery_boy/screen/profile/pages/privacr_policy_screen.dart';
import 'package:bhamma_delivery_boy/screen/profile/pages/ratting_screes.dart';
import 'package:bhamma_delivery_boy/screen/profile/pages/settings_screen.dart';
import 'package:bhamma_delivery_boy/screen/profile/pages/terms_conditions_screen.dart';
import 'package:bhamma_delivery_boy/screen/profile/pages/withdrawableBalancePage.dart';
import 'package:bhamma_delivery_boy/screen/profile/profile_screen.dart';
import 'package:bhamma_delivery_boy/screen/profile/profile_update_screen.dart';
import 'package:bhamma_delivery_boy/screen/search_screen.dart';
import 'package:bhamma_delivery_boy/screen/splash_screen.dart';
import 'package:bhamma_delivery_boy/screen/withdrawals/wallet_screen.dart';
import 'package:bhamma_delivery_boy/utils/default_colors.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(MyApp(savedThemeMode: savedThemeMode));
}

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;
  MyApp({super.key, this.savedThemeMode});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: DefaultColor.white,
        primaryColorLight: DefaultColor.mainColor,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(DefaultColor.mainColor),
            foregroundColor: MaterialStateProperty.all(DefaultColor.white),
          ),
        ),
      ),
      dark: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: DefaultColor.bg,
        primaryColorDark: DefaultColor.mainColor,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(DefaultColor.mainColor),
            foregroundColor: MaterialStateProperty.all(DefaultColor.white),
          ),
        ),
      ),
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      // debugShowFloatingThemeButton: true,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'Flutter Demo',
        theme: theme,
        darkTheme: darkTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        onGenerateRoute: _pageRoute,
      ),
    );
  }

  /// Routes Map (Remove switch case)
  final Map<String, Widget Function(BuildContext)> routes = {
    '/': (context) => const SplashScreen(),
    '/home': (context) => const HomeScreen(),
    '/search': (context) => const SearchScreen(),
    '/forgot_password': (context) => const ForgotPasswordScreen(),
    '/change_password': (context) => const ChangePasswordScreen(),
    '/bank_details': (context) => const BankDetailsPage(),
    '/profile_update': (context) => const ProfileUpdateScreen(),
    '/profile': (context) => const ProfileScreen(),
    '/withdraw': (context) => const WalletScreen(),
    '/terms_conditions': (context) => const TermsAndConditionsPage(),
    '/settings': (context) => const SettingsPage(),
    '/rating': (context) => const RatingReviewsScreen(),
    '/privace_policy': (context) => const PrivacyPolicyScreen(),
    '/notification': (context) => const NotificationScreen(),
    '/incentive': (context) => const IncentivesPage(),
    '/help_support': (context) => const HelpSupportScreen(),
    '/emergency': (context) => const EmergencySOSPage(),
    '/earning': (context) => const EarningStatementPage(),
    //'/dispute': (context) => const DisputePage(),
    '/dispute_list': (context) => const DisputeItemsList(),
    '/announcements': (context) => const AnnouncementsPage(),
    '/otp': (context) => OtpScreen(),
    // '/order_tracking': (context) => const OrderTrackingPage(),
    '/order': (context) => const OrderScreen(),
    '/vehicle_type': (context) => const VehicleTypeScreen(),
    '/order_delivered': (context) => const DeliveredOrdersPage(),
    '/order_assigned': (context) => const AssignedOrdersPage(),
    '/trc_verification': (context) => const TrcVerificationScreen(),
    '/submit_doc': (context) => const SubmitDocScreen(),
    '/passport_verification': (context) => const PassportVerificationScreen(),
    '/driveing_licens_verification': (context) => const DriveingLicensVerificationSecreen(),
    '/document_verification': (context) => const DocumentVerificationWaitingPage(),
    '/verify_phone': (context) => const VerifyPhoneNumberScreen(),
    '/signup': (context) => const SignupScreen(),
    //'/otpphone': (context) => const OtpPhoneScreen(),
    '/login': (context) => const LoginScreen(),
  };

  /// Custom page transition function
  Route<dynamic> _pageRoute(RouteSettings settings) {
    final WidgetBuilder? builder = routes[settings.name];

// Handle order_details route manually
    if (settings.name == '/order_details') {
      final int orderId = settings.arguments as int;
      return PageRouteBuilder(
        settings: settings,
        transitionDuration: const Duration(milliseconds: 150),
        reverseTransitionDuration: const Duration(milliseconds: 150),
        pageBuilder: (context, animation, secondaryAnimation) =>
            OrderDetailsScreen(orderId: orderId),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      );
    }

    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 150),
      reverseTransitionDuration: const Duration(milliseconds: 150),
      pageBuilder: (context, animation, secondaryAnimation) =>
      builder != null ? builder(context) : _notFoundPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  /// 404 Not Found Page
  Widget _notFoundPage() {
    return const Scaffold(
      body: Center(
        child: Text(
          "404 Page Not Found",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}