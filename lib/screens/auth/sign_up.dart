// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:chat_app/screens/auth/sign_in.dart';
import 'package:chat_app/screens/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    emailController.dispose();
    usernameController.dispose();
  }

  bool _obscurepassword = true;

  final _formKey = GlobalKey<FormState>();

  Future<void> submit() async {
    final valid = _formKey.currentState!.validate();
    if (!valid) {
      return;
    }
    try {
      _formKey.currentState!.save();
      final UserCredential usercredential = await _firebase
          .createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );
      if (usercredential.user != null) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created successfully')),
        );
      }
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const ChatScreen()));
      FirebaseFirestore.instance
          .collection('users')
          .doc(usercredential.user!.uid)
          .set({
            'username': usernameController.text,
            'email': emailController.text,
            'userId': usercredential.user!.uid,
            //  'createdAt': Timestamp.now(),
            'emailpassword': passwordController.text,
          });
    } on FirebaseAuthException catch (e) {
      log(e.code);
      if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('The email is already in use')),
        );
      } else if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Weak password, please choose a stronger one'),
          ),
        );
      } else if (e.code == 'invalid-email') {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('The email address is not valid')),
        );
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: ${e.message}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/image/signup.png',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Sign up',
                  style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextFormField(
                      onSaved: (newValue) {
                        emailController.text = newValue!;
                      },
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            !value.contains('@')) {
                          return 'Please enter a valid email address.';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: 'Email :',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xffff8383),
                            width: 3,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      onSaved: (newValue) {
                        usernameController.text = newValue!;
                      },
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            value.length < 4) {
                          return 'Please enter a valid user name.';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.verified_user),
                        labelText: 'User Name :',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xffff8383),
                            width: 3,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      obscureText: _obscurepassword,

                      onSaved: (newValue) {
                        passwordController.text = newValue!;
                      },
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            passwordController.text !=
                                confirmPasswordController.text) {
                          return 'Please enter a valid Password.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        helperText: 'password must be at least 6 characters',
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
                        prefixIcon: const Icon(Icons.password),
                        labelText: 'Password :',
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xffff8383),
                            width: 3,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      obscureText: _obscurepassword,
                      onSaved: (newValue) {
                        confirmPasswordController.text = newValue!;
                      },
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            passwordController.text !=
                                confirmPasswordController.text) {
                          return 'Please enter a valid password.';
                        }
                        return null;
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
                        prefixIcon: const Icon(Icons.password_outlined),
                        labelText: 'Confirm Password :',
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xffff8383),
                            width: 3,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffff8383),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Opacity(
                          opacity: 0.5,
                          child: Text(
                            'Already have an Account!',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => const SignInScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: Color(0xffff8383),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
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
