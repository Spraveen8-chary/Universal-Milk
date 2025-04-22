import 'package:flutter/material.dart';
import 'auth_form.dart';
import 'home_screen.dart';

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
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
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
    brightness: Brightness.light,
    fontFamily: 'Poppins',
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color(0xFFB98068), // warm earthy brown
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: Color(0xFFF7F5F2),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF3EDE7),
      foregroundColor: Colors.black87,
      elevation: 0,
    ),
  );

  final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Poppins',
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color(0xFFE1AD7E), // warm light caramel
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: Color(0xFF1C1C1C),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF2A2A2A),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Try On',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Try On'),
          actions: [
            IconButton(
              icon: Icon(
                _themeMode == ThemeMode.light
                    ? Icons.dark_mode
                    : Icons.light_mode,
              ),
              onPressed: _toggleTheme,
              tooltip: 'Toggle Theme',
            ),
          ],
        ),
        body: _loggedInUser == null
            ? AuthForm(onLoginSuccess: _handleLoginSuccess)
            : HomeScreen(
                userEmail: _loggedInUser!,
                onLogout: _handleLogout,
              ),
      ),
    );
  }
}
