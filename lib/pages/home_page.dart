import 'package:ouakr/app/app_base_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';


class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  void signUserOut(){
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AppBaseViewModel>.reactive(
      viewModelBuilder: () => AppBaseViewModel(),
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(),
        darkTheme: ThemeData.dark(),
        themeMode: model.theme,
        home: Scaffold(
                  appBar: AppBar(
                    actions: [
                      IconButton(
                          onPressed: () {
                            model.ChangeTheme();
                          },
                          icon: model.theme == ThemeMode.light
                              ? Icon(Icons.dark_mode)
                              : Icon(Icons.light_mode)),
                      IconButton(onPressed: signUserOut, icon: Icon (Icons. logout))
                    ],
                  ),
                  body: Container(
                    child: Center(
                        child: Text(
                      "Halloo "+ user.email!,
                      style: TextStyle(fontSize: 25),
                    )
                    ),
                  ),
                )),
      );

  }
}
