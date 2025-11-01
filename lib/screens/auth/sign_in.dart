import 'package:chat_app/screens/auth/sign_up.dart';
import 'package:chat_app/screens/chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _firebaseAuth = FirebaseAuth.instance;

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool value = false;
  bool _obscurepassword = true;
  final _formKey = GlobalKey<FormState>();
  var emailtext = '';
  var passwordtext = '';
  bool isLoading = false;

  Future<void> newSubmit() async {
    setState(() {
      isLoading = true;
    });
    final valid = _formKey.currentState!.validate();
    if (!valid) return;
    _formKey.currentState!.save();
    try {
      final UserCredential usersignin = await _firebaseAuth
          .signInWithEmailAndPassword(email: emailtext, password: passwordtext);
      if (usersignin.user != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Signed in successfully')));
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => const ChatScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      switch (e.code) {
        case 'network-request-failed':
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No internet connection.')),
          );
          break;
        case 'too-many-requests':
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Too many requests. Try again later.'),
            ),
          );
          break;
        case 'user-not-found':
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No user found for that email.')),
          );
          break;
        case 'invalid-credential':
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Wrong email or password provided for that user.'),
            ),
          );
          break;
        default:
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Authentication error: ${e.message}')),
          );
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Image.asset(
                  'assets/image/signin.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Sign in',
                    style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    TextFormField(
                      onSaved: (newValue) {
                        emailtext = newValue!;
                      },
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            !value.contains('@')) {
                          return 'Please enter a valid email address.';
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xffff8383),
                            width: 3,
                          ),
                        ),

                        labelText: 'Email :',
                      ),

                      keyboardType: TextInputType.emailAddress,
                    ),
                    TextFormField(
                      onSaved: (newValue) {
                        passwordtext = newValue!;
                      },
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            value.length < 6) {
                          return 'Please enter a valid Password .';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurepassword = !_obscurepassword;
                            });
                          },
                          icon: Icon(
                            _obscurepassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xffff8383),
                            width: 3,
                          ),
                        ),
                        labelText: 'password :',
                      ),

                      obscureText: _obscurepassword,
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Checkbox(
                          fillColor: WidgetStateProperty.all(
                            const Color(0xffff8383),
                          ),
                          shape: const CircleBorder(),
                          value: value,
                          onChanged: (valye) {
                            setState(() {
                              value = valye!;
                            });
                          },
                        ),
                        const Text('Remember me'),
                        const Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Forget Password?',
                            style: TextStyle(
                              color: Color(0xffff8383),
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 65),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: newSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffff8383),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: isLoading
                              ? const CircularProgressIndicator()
                              : const Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Opacity(
                          opacity: 0.7,
                          child: Text('Dont have an account?'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              PageRouteBuilder(
                                pageBuilder: (_, __, ___) =>
                                    const SignUpScreen(),
                                transitionDuration: const Duration(
                                  milliseconds: 0,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'sign up',
                            style: TextStyle(
                              color: Color(0xffff8383),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
