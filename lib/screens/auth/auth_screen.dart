import 'package:chat_app/screens/auth/sign_in.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/image/home.png',
              fit: BoxFit.cover,
              width: double.infinity,
            ),

            const Padding(
              padding: EdgeInsets.only(left: 27),
              child: Align(
                alignment: AlignmentGeometry.topLeft,
                child: Column(
                  children: [
                    Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Opacity(
                      opacity: 0.6,
                      child: Text(
                        'Lorem ipsum dolor sit amet consectetur.\nLorem id sit ',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 70),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('continue'),
                const SizedBox(width: 15),
                IconButton.filled(
                  style: IconButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: const Color(0xffff8383),
                  ),
                  color: const Color(0xfffef7ff),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const SignInScreen()),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
