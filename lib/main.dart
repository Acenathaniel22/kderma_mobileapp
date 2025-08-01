import 'package:flutter/material.dart';
import 'package:kderma_mobileapp/appointments.dart';
import 'package:kderma_mobileapp/dashboard.dart';
import 'package:kderma_mobileapp/profile.dart';
import 'package:kderma_mobileapp/treatment.dart';
import 'package:kderma_mobileapp/services.dart' as services;
import 'package:kderma_mobileapp/Login.dart';

import 'ClientRegistrationForm.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'K DERMA',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        primaryColor: Colors.pink,
        colorScheme:
            ColorScheme.fromSwatch(primarySwatch: Colors.pink).copyWith(
          secondary: Colors.pinkAccent,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.pink,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.pink,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.pink,
            side: const BorderSide(color: Colors.pink),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.pink.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.pink),
          ),
          labelStyle: const TextStyle(color: Colors.pink),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/': (context) => HomePage(),
        '/dashboard': (context) => Dashboard(),
        '/profile': (context) => ProfileScreen(),
        '/services': (context) => services.SkincareServicesSection(),
        '/appointments': (context) => AppointmentPage(),
        '/treatment': (context) => TreatmentTimelineSection(),
        '/login': (context) => Login(),
        '/register': (context) => ClientRegistrationForm(),
      },
    );
  }
}

class NavItem {
  final IconData icon;
  final String label;

  NavItem({required this.icon, required this.label});
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<NavItem> _navItems = [
    NavItem(icon: Icons.dashboard, label: 'Dashboard'),
    NavItem(icon: Icons.person, label: 'Profile'),
    NavItem(icon: Icons.medical_services, label: 'Services'),
    NavItem(icon: Icons.calendar_today, label: 'My Appointments'),
    NavItem(icon: Icons.history, label: 'Treatment History'),
  ];

  final List<Widget> _pages = [
    Dashboard(), // Dashboard
    ProfileScreen(), // Profile
    services.SkincareServicesSection(), // Services
    AppointmentPage(), // My Appointments (was Center(child: Text('My Appointments')))
    TreatmentTimelineSection(),
    Login()
  ];

  void _logout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      Navigator.pushReplacementNamed(context, '/login'); // Go to login page
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'K DERMA',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Daniel De Asis'),
              accountEmail: Text('Client'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.pinkAccent,
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.pinkAccent,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _navItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(_navItems[index].icon),
                    title: Text(_navItems[index].label),
                    selected: index == _selectedIndex,
                    selectedTileColor: Colors.pink[50],
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                      Navigator.pop(context); // close the drawer
                    },
                  );
                },
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}

// Dummy Profile Page
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Profile Page'));
  }
}

// Dummy Home Page
class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Home Page'));
  }
}
