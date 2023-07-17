import 'dart:io';
import 'dart:typed_data';
import 'package:ouakr/components/text_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import '../app/app_base_view_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final userCollection = FirebaseFirestore.instance.collection("Users");

  bool isFollowing = false;

  String imageUrl = '';
  Uint8List? _image;

  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Düzenle $field",
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Yeni $field giriniz",
            hintStyle: TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(newValue),
            child: Text(
              'İptal',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(newValue),
            child: Text(
              'Kaydet',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
    if (newValue.trim().length > 0) {
      await userCollection.doc(currentUser!.email).update({field: newValue});
    }
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  buildProfileButton(){
    bool isProfileOwner;
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
                  title: const Text(
                    "Profil Sayfası",
                  ),
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),

                  backgroundColor: Colors.purple,
                  actions: [
                    IconButton(
                        onPressed: () {
                          model.ChangeTheme();
                        },
                        icon: model.theme == ThemeMode.light
                            ? Icon(Icons.dark_mode)
                            : Icon(Icons.light_mode)),
                    IconButton(onPressed: signUserOut, icon: Icon(Icons.logout))
                  ],
                ),
                body: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Users")
                      .doc(currentUser!.email)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final userData =
                          snapshot.data?.data() as Map<String, dynamic>?;

                      return ListView(
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          /*
                          UserImage(onFileChanged: (imageUrl) {
                            setState(() {
                              this.imageUrl = imageUrl;
                            });
                          }),*/

                          Center(
                            child: Stack(
                              children: [
                                _image != null
                                    ? CircleAvatar(
                                        radius: 64,
                                        backgroundImage: MemoryImage(_image!),
                                      )
                                    : CircleAvatar(
                                        radius: 64,
                                        backgroundImage: NetworkImage(
                                            'https://www.pngitem.com/pimgs/m/421-4212266_transparent-default-avatar-png-default-avatar-images-png.png'),
                                      ),
                                Positioned(
                                  child: IconButton(
                                    onPressed: () async {
                                      ImagePicker imagePicker = ImagePicker();
                                      XFile? file = await imagePicker.pickImage(
                                          source: ImageSource.gallery);

                                      Uint8List img = await file!.readAsBytes();
                                      setState(() {
                                        _image = img;
                                      });

                                      if (file == null) return;

                                      String uniqueFileName = DateTime.now()
                                          .millisecondsSinceEpoch
                                          .toString();

                                      Reference referenceRoot =
                                          FirebaseStorage.instance.ref();
                                      Reference referenceDirImages =
                                          referenceRoot.child('images');

                                      Reference referenceImageToUpload =
                                          referenceDirImages
                                              .child(uniqueFileName);

                                      try {
                                        await referenceImageToUpload
                                            .putFile(File(file!.path));

                                        imageUrl = await referenceImageToUpload
                                            .getDownloadURL();
                                      } catch (e) {}
                                    },
                                    icon: Icon(Icons.add_a_photo),
                                  ),
                                  bottom: -10,
                                  left: 80,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            currentUser!.email!,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25.0),
                            child: Text(
                              "Kullanıcı Detayları",
                              style: TextStyle(color: Colors.deepOrange),
                            ),
                          ),
                          MyTextBox(
                            text: userData?['username'] ?? '',
                            sectionName: 'Kullanıcı Adı',
                            onPressed: () => editField('username'),
                          ),
                          MyTextBox(
                            text: userData?['name'] ?? '',
                            sectionName: 'Ad',
                            onPressed: () => editField('name'),
                          ),
                          MyTextBox(
                            text: userData?['surname'] ?? '',
                            sectionName: 'Soyad',
                            onPressed: () => editField('surname'),
                          ),
                          MyTextBox(
                            text: userData?['bio'] ?? '',
                            sectionName: 'Hakkında',
                            onPressed: () => editField('bio'),
                          ),

                          const SizedBox(
                            height: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25.0),
                            child: Text(
                              "Kullanıcı Postları",
                              style: TextStyle(color: Colors.deepOrange),
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text("Hata: ${snapshot.error}"),
                      );
                    }

                    return Center(child: const CircularProgressIndicator());
                  },
                ),
              ),
            ));
  }
}
