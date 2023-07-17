import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ButtonWithImage extends StatelessWidget {
  ButtonWithImage({super.key});
  final GoogleSignIn _googleSignIn = new GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[200],
        ),
        child: GestureDetector(
            child: Image.asset(
              'lib/images/google.png',
              height: 40,
            ),
            onTap: () => _googleSignIn.signIn().then(
                  (value) {
                    String userName = value!.displayName!;
                    String profilPicture = value!.photoUrl!;
                  },
                )));
  }
}
