import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(String email) onLoginSuccess;
  const AuthForm({super.key, required this.onLoginSuccess});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String _email = '';
  String _password = '';

  final Map<String, String> _userDatabase = {};

  void _trySubmit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    _formKey.currentState?.save();

    if (_isLogin) {
      if (_userDatabase.containsKey(_email)) {
        if (_userDatabase[_email] == _password) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login successful!')),
          );
          widget.onLoginSuccess(_email);
        } else {
          _showErrorDialog('Incorrect password. Please try again.');
          setState(() {
            _isLogin = false;
          });
        }
      } else {
        _showErrorDialog('User not found. Please register first.');
        setState(() {
          _isLogin = false;
        });
      }
    } else {
      if (_userDatabase.containsKey(_email)) {
        _showErrorDialog('User already exists. Please login.');
        setState(() {
          _isLogin = true;
        });
      } else {
        _userDatabase[_email] = _password;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Registration successful! Please login.')),
        );
        setState(() {
          _isLogin = true;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final headingStyle = TextStyle(
      fontFamily: 'Coolvetica',
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: isDark ? Colors.lightBlue[200] : Colors.blue,
    );

    final labelStyle = TextStyle(
      fontFamily: 'Poppins',
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: isDark ? Colors.lightBlue[200] : Colors.blue,
    );

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: isDark ? Colors.lightBlue[300] : Colors.lightBlue,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : Colors.blue,
      ),
    );

    return Center(
      child: Card(
        elevation: 12,
        margin:
            EdgeInsets.symmetric(horizontal: isWide ? 300 : 24, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        color: theme.colorScheme.surfaceContainerHighest,
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _isLogin ? 'Login' : 'Register',
                    style: headingStyle,
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    key: const ValueKey('email'),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: labelStyle,
      prefixIcon: Icon(Icons.email,
                          color: isDark
                              ? Colors.lightBlue[200]
                              : Colors.lightBlue),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !value.contains('@')) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value ?? '';
                    },
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    key: const ValueKey('password'),
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: labelStyle,
      prefixIcon: Icon(Icons.lock,
                          color: isDark
                              ? Colors.lightBlue[200]
                              : Colors.lightBlue),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return 'Password must be at least 6 characters long.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value ?? '';
                    },
                  ),
                  if (!_isLogin) ...[
                    const SizedBox(height: 24),
                    TextFormField(
                      key: const ValueKey('confirm_password'),
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        labelStyle: labelStyle,
                        prefixIcon: Icon(Icons.lock_outline,
                            color: isDark
                                ? Colors.lightBlue[200]
                                : Colors.lightBlue),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return 'Passwords do not match.';
                        }
                        return null;
                      },
                    ),
                  ],
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _trySubmit,
                    style: buttonStyle,
                    child: Text(_isLogin ? 'Login' : 'Register'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child: Text(
                      _isLogin
                          ? 'Create new account'
                          : 'I already have an account',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? const Color.fromARGB(255, 255, 255, 255)
                          : Colors.blue,
                    ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
