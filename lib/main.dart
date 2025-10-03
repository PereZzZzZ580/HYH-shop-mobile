import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/order_provider.dart';
import 'screens/home_screen.dart';
import 'screens/appointments_screen.dart';
import 'screens/services_screen.dart';
import 'screens/barbers_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/order_history_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HyH Shop Barbería',
      debugShowCheckedModeBanner: false,
      theme: _buildHyHTheme(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'),
      ],
      home: const MainNavigator(),
      routes: {
        '/cart': (context) => const CartScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
      },
    );
  }
}

ThemeData _buildHyHTheme() {
  const Color primaryColor = Color(0xFFFFD700);
  const Color primaryColorDark = Color(0xFFC6A700);
  const Color backgroundColor = Color(0xFF000000);
  const Color surfaceColor = Color(0xFF0A0A0A);
  const Color textColor = Color(0xFFFFFFFF);
  const Color mutedColor = Color(0xFFBFBFBF);
  const Color borderColor = Color(0xFF2E2E2E);

  final baseTheme = ThemeData.dark();

  return baseTheme.copyWith(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.robotoSlab(
        color: textColor,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: const IconThemeData(color: textColor),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: mutedColor,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.bold),
      unselectedLabelStyle: GoogleFonts.inter(),
    ),
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: primaryColor,
      surface: surfaceColor,
      onPrimary: Colors.black, // Text on primary color
      onSecondary: Colors.black,
      onSurface: textColor,
      error: Color(0xFFFF4D4D),
      brightness: Brightness.dark,
    ),
    textTheme: baseTheme.textTheme.copyWith(
      displayLarge: GoogleFonts.robotoSlab(color: textColor, fontWeight: FontWeight.bold),
      displayMedium: GoogleFonts.robotoSlab(color: textColor, fontWeight: FontWeight.bold),
      displaySmall: GoogleFonts.robotoSlab(color: textColor, fontWeight: FontWeight.bold),
      headlineMedium: GoogleFonts.robotoSlab(color: textColor, fontWeight: FontWeight.bold),
      headlineSmall: GoogleFonts.robotoSlab(color: textColor, fontWeight: FontWeight.bold),
      titleLarge: GoogleFonts.robotoSlab(color: textColor, fontWeight: FontWeight.bold),
      bodyLarge: GoogleFonts.inter(color: textColor),
      bodyMedium: GoogleFonts.inter(color: textColor),
      labelLarge: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.bold), // For buttons
    ).apply(
      bodyColor: textColor,
      displayColor: textColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF0F0F0F),
      hintStyle: GoogleFonts.inter(color: mutedColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
    ),
  );
}

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _selectedIndex = 0;

  final List<Widget> _screens = <Widget>[
    HomeScreen(),
    AppointmentsScreen(),
    ServicesScreen(),
    BarbersScreen(),
    ContactScreen(),
  ];

  static const List<String> _titles = <String>[
    'Inicio',
    'Citas',
    'Servicios',
    'Barberos',
    'Contacto',
  ];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final auth = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // HYH Logo
            Image.asset(
              'assets/images/logo.png',
              width: 40,
              height: 40,
              errorBuilder: (context, error, stackTrace) {
                // Fallback if logo is not available
                return Icon(
                  Icons.store,
                  color: Theme.of(context).colorScheme.primary,
                );
              },
            ),
            const SizedBox(width: 8),
            Text(_titles[_selectedIndex]),
          ],
        ),
        actions: [
          if (_selectedIndex == 0) // Only show cart icon on Home screen
            IconButton(
              icon: Stack(
                children: [
                  const Icon(Icons.shopping_cart),
                  if (cart.itemCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${cart.itemCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                );
              },
              tooltip: 'Ver Carrito',
            ),
          // User profile icon - shows login/register if not logged in, user avatar if logged in
          if (auth.isAuth)
            PopupMenuButton(
              icon: const Icon(Icons.person),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'profile',
                  child: Text('Perfil'),
                ),
                PopupMenuItem(
                  value: 'orders',
                  child: Text('Mis Pedidos'),
                ),
                PopupMenuItem(
                  value: 'logout',
                  child: Text('Cerrar Sesión'),
                ),
              ],
              onSelected: (value) {
                if (value == 'logout') {
                  auth.logout();
                } else if (value == 'orders') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
                  );
                }
                // TODO: Handle other menu options
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              tooltip: 'Iniciar Sesión',
            ),
        ],
      ),
      body: Center(
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Citas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.content_cut_outlined),
            activeIcon: Icon(Icons.content_cut),
            label: 'Servicios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Barberos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_outlined),
            activeIcon: Icon(Icons.location_on),
            label: 'Contacto',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}