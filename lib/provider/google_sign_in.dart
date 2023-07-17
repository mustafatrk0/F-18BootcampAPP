import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier{
  bool loading = false;

  void updateLoading(bool deger){

    loading=!deger;
    notifyListeners();
  }

  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogin() async{
    final googleUser = await GoogleSignIn().signIn();

    if(googleUser==null) return;
    _user = googleUser;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );


    await FirebaseAuth.instance.signInWithCredential(credential).then((value){
      if(value.user != null){
        updateLoading(true);
      }
    });

    notifyListeners();
  }

}