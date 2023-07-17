import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/google_sign_in.dart';

class SquareTile extends StatelessWidget {
  final String imagePath;

  final Function()? onTap;

  const SquareTile({
    super.key,
    required this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
    return GestureDetector(
      onTap: (){
        print("gestureDetector çalıştı");
        onTap!();
      },
      child: Container(
        padding: const EdgeInsets.all(20), //const eklendi.
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[200],
        ),

        child: provider.loading==true ? CircularProgressIndicator(
          color: Colors.green,
        ) :
        Image.asset(
          imagePath,
          height: 40,
        ), // Image.asset
      ),
    ); // Container
  }
}
