import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:hyhshopmobile/providers/auth_provider.dart';
import 'package:hyhshopmobile/providers/cart_provider.dart';
import 'package:hyhshopmobile/screens/appointments_screen.dart';
import 'package:hyhshopmobile/screens/barbers_screen.dart';
import 'package:hyhshopmobile/screens/cart_screen.dart';
import 'package:hyhshopmobile/screens/contact_screen.dart';
import 'package:hyhshopmobile/screens/home_screen.dart';
import 'package:hyhshopmobile/screens/login_screen.dart';
import 'package:hyhshopmobile/screens/order_history_screen.dart';
import 'package:hyhshopmobile/screens/register_screen.dart';
import 'package:hyhshopmobile/screens/services_screen.dart';

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  final List<Widget> _screens = const <Widget>[
    HomeScreen(),
    AppointmentsScreen(),
    ServicesScreen(),
    BarbersScreen(),
    ContactScreen(),
  ];

  final List<String> _titles = const <String>[
    'HyH Shop',
    'Citas',
    'Servicios',
    'Barberos',
    'Contacto',
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: child,
                );
              },
              child: Icon(
                _mapIndexToIcon(_selectedIndex),
                key: ValueKey<int>(_selectedIndex),
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _titles[_selectedIndex],
              key: const Key('mainNavigatorTitle'),
            ),
          ],
        ),
        actions: [
          if (_selectedIndex == 0)
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
                Navigator.pushNamed(context, CartScreen.routeName);
              },
              tooltip: 'Ver carrito',
            ),
          if (auth.isAuth)
            PopupMenuButton<String>(
              icon: const Icon(Icons.person),
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: 'profile',
                  child: Text('Perfil'),
                ),
                PopupMenuItem(
                  value: 'orders',
                  child: Text('Mis pedidos'),
                ),
                PopupMenuItem(
                  value: 'logout',
                  child: Text('Cerrar sesion'),
                ),
              ],
              onSelected: (value) {
                if (value == 'logout') {
                  auth.logout();
                } else if (value == 'orders') {
                  Navigator.pushNamed(context, OrderHistoryScreen.routeName);
                }
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.routeName);
              },
              tooltip: 'Iniciar sesion',
            ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
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

  IconData _mapIndexToIcon(int index) {
    switch (index) {
      case 1:
        return Icons.calendar_today;
      case 2:
        return Icons.content_cut;
      case 3:
        return Icons.person;
      case 4:
        return Icons.location_on;
      default:
        return Icons.storefront;
    }
  }
}
