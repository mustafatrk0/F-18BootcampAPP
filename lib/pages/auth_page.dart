import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ouakr/pages/anasayfa.dart';
import 'login_or_register_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //user is logged in
          if(snapshot.connectionState == ConnectionState.waiting)
            {return Center(child: CircularProgressIndicator());}
          else if (snapshot.hasData) {
            return Anasayfa();
          }
          else if(snapshot.hasError){
            return Center(child: Text('Bir şeyler yanlış gitti!'));
          }
          else {
            return LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}