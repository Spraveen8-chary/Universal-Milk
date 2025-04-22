import 'package:flutter/material.dart';
import 'auth_form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;
  String? _loggedInUser;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          (_themeMode == ThemeMode.light) ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _handleLoginSuccess(String email) {
    setState(() {
      _loggedInUser = email;
    });
  }

  void _handleLogout() {
    setState(() {
      _loggedInUser = null;
    });
  }

  final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue.shade200),
    useMaterial3: true,
    brightness: Brightness.light,
  );

  final ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.lightBlue, brightness: Brightness.dark),
    useMaterial3: true,
    brightness: Brightness.dark,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Try On',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Try On'),
          actions: [
            IconButton(
              icon: Icon(_themeMode == ThemeMode.light
                  ? Icons.dark_mode
                  : Icons.light_mode),
              onPressed: _toggleTheme,
              tooltip: 'Toggle Theme',
            ),
          ],
        ),
        body: _loggedInUser == null
            ? AuthForm(onLoginSuccess: _handleLoginSuccess)
            : WelcomePage(userEmail: _loggedInUser!, onLogout: _handleLogout),
      ),
    );
  }
}

class WelcomePage extends StatelessWidget {
  final String userEmail;
  final VoidCallback onLogout;

  const WelcomePage(
      {super.key, required this.userEmail, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: size.width,
            height: size.height * 0.3,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/banners/banner_1.jpg'),
                fit: BoxFit.cover,
                colorFilter: isDark
                    ? ColorFilter.mode(
                        Colors.black.withOpacity(0.6), BlendMode.darken)
                    : null,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              'Welcome, $userEmail!',
              style: const TextStyle(
                fontFamily: 'Coolvetica',
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 8,
                    color: Colors.black54,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Explore our latest collections and enjoy your shopping experience!',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: onLogout,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlue,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              textStyle: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: const Text('Logout'),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
