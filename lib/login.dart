import 'package:admin_dashboard_app/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Background image
          Image.asset(
            'images/book.jpg', // Use the correct path to your image
            fit: BoxFit.cover,
          ),
          // Login form
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 10),
                Image.asset(
                  'images/logolibrary.png',
                  height: 100,
                  width: 100,
                ),
                const Text(
                  'AJRAK CLUB LMS',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 17),
                const LoginField(hintText: "Password"),
                const SizedBox(height: 20),
                const LoginButton(),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white10,
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Navigate to the next screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      },
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(125, 45),
      ),
      child: const Text(
        'Log in',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 17,
        ),
      ),
    );
  }
}

class LoginField extends StatelessWidget {
  final String hintText;

  const LoginField({super.key, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 300, // Adjust the width as needed
      ),
      child: TextField(
        style: const TextStyle(fontSize: 12, backgroundColor: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          prefixIcon: const Icon(
            Icons.lock,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
