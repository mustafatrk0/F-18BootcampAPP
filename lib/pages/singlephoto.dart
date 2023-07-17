import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'dart:math';
import 'package:ouakr/pages/anasayfa.dart';

class PhotoPage extends StatelessWidget {
  final XFile imageFile;

  const PhotoPage({required this.imageFile});

  Future<String?> uploadImage(BuildContext context) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;

      final currentUser = FirebaseAuth.instance.currentUser;
      final userCollection = FirebaseFirestore.instance.collection("Users");

      if (user == null) {
        print('Kullanıcı oturumu açık değil');
        return null;
      }

      var random = Random();

      // 0 ile 100 arasında bir random sayı üretme
      var randomNumber = random.nextInt(10001);

      final splitted = currentUser!.email!.split('@');
      final split = splitted.first;

      final Reference referansYol = FirebaseStorage.instance
          .ref()
          .child("paylasimlar")
          .child(split.toString())
          .child("resim$randomNumber.png");

      final File file = File(imageFile.path);
      final UploadTask yuklemeGorevi = referansYol.putFile(file);
      final TaskSnapshot yuklemeSnapshot = await yuklemeGorevi;
      final String url = await yuklemeSnapshot.ref.getDownloadURL();

      // İndirme URL'sini kullanmak için burada yapmak istediğiniz işlemleri gerçekleştirin
      print('Fotoğraf yüklendi: $url');

      return url; // URL'yi geri dönüş değeri olarak döndür

    } catch (e) {
      print('Hata: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fotoğraf'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.file(File(imageFile.path)),
            ElevatedButton(
              onPressed: () async {
                String? imageUrl = await uploadImage(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Anasayfa(imageUrl: imageUrl),
                  ),
                );
              },
              child: Text('Paylaş'),
            ),
          ],
        ),
      ),
    );
  }
}
