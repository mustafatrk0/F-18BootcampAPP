import 'dart:io';

import 'package:ouakr/components/my_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/my_button.dart';
import '../components/square_tile.dart';
import '../provider/google_sign_in.dart';
import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  Future<AlertDialog?> signUserUp() async {
    /*showDialog(
      context: context,
      builder: (context) {
        return const Center(
          /*child: CircularProgressIndicator(
            color: Colors.green,
          ),*/
        );
      },
    );*/
    try {
      if (passwordController.text == passwordConfirmController.text) {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);

        FirebaseFirestore.instance.collection("Users").doc(userCredential.user!.email).set({
          'username': emailController.text.split('@')[0],
          'bio': 'empty bio',
        });

      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("Parolalar Eşleşmedi!"),
            );
          },
        );
      }



    } on FirebaseAuthException catch (e) {
      showErrorMessage(e.code);
    } finally {}
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.red,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 25),
                const Icon(
                  Icons.lock,
                  size: 50,
                ),
                const SizedBox(height: 25),
                Text(
                  'Haydi senin için bir hesap oluşturalım',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Şifre',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: passwordConfirmController,
                  hintText: 'Şifreni Doğrula',
                  obscureText: true,
                ),
                const SizedBox(height: 25),
                MyButton(
                  text: 'Kayıt Ol',
                  onTap: signUserUp,
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ), // Divider
                      ), // Expanded
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Yada şununla devam et',
                          style: TextStyle(color: Colors.grey[700]),
                        ), // Text I
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(
                        onTap: () {
                          print("SQuare çağrıldı.");

                          final provider = Provider.of<GoogleSignInProvider>(
                              context,
                              listen: false);

                          if (provider.loading == false) {
                            provider.updateLoading(true);
                            provider.googleLogin();
                          }
                        },
                        imagePath: 'lib/images/google.png'),
                    SizedBox(width: 25),
                    Platform.isIOS
                        ? SquareTile(
                            onTap: () {},
                            imagePath: 'lib/images/apple-logo.png')
                        : SizedBox(),
                  ],
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Zaten üye misin?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),

                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        'Hemen giriş yap',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                    // TextStyle
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
