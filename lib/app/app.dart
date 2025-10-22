import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'package:hyhshopmobile/app/navigation/main_navigator.dart';
import 'package:hyhshopmobile/core/theme/hyh_theme.dart';
import 'package:hyhshopmobile/providers/auth_provider.dart';
import 'package:hyhshopmobile/providers/cart_provider.dart';
import 'package:hyhshopmobile/providers/order_provider.dart';
import 'package:hyhshopmobile/screens/cart_screen.dart';
import 'package:hyhshopmobile/screens/login_screen.dart';
import 'package:hyhshopmobile/screens/order_history_screen.dart';
import 'package:hyhshopmobile/screens/register_screen.dart';
import 'package:hyhshopmobile/services/environment.dart';

class HyHShopMobileApp extends StatelessWidget {
  const HyHShopMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CartProvider>(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider<OrderProvider>(
          create: (_) => OrderProvider(),
        ),
      ],
      child: MaterialApp(
        title: Environment.appName,
        debugShowCheckedModeBanner: false,
        theme: HyHTheme.dark(),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('es', 'CO'),
          Locale('es', 'ES'),
        ],
        home: const MainNavigator(),
        routes: {
          CartScreen.routeName: (context) => const CartScreen(),
          LoginScreen.routeName: (context) => const LoginScreen(),
          RegisterScreen.routeName: (context) => const RegisterScreen(),
          OrderHistoryScreen.routeName: (context) => const OrderHistoryScreen(),
        },
      ),
    );
  }
}
