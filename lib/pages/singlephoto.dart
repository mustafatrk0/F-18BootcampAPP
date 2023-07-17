import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'dart:math';
import 'package:ouakr/pages/anasayfa.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';

class PhotoPage extends StatelessWidget {
  final XFile imageFile;

  const PhotoPage({required this.imageFile});

  Future<String?> uploadImage(BuildContext context) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;

      final currentUser = FirebaseAuth.instance.currentUser;
      final photosCollection = FirebaseFirestore.instance.collection("Photos");

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

      // Konum bilgisini al
      Position position = await goToLocation();

      // Firestore'a fotoğraf ve konum bilgisini kaydet
      await photosCollection.doc('resim$randomNumber').set({
        'photoUrl': url,
        'latitude': position.latitude,
        'longitude': position.longitude,
      });

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

  Future<Position> goToLocation() async {
    // Konum izni kontrolü
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw PlatformException(
        code: 'LOCATION_SERVICES_DISABLED',
        message: 'Telefonunuzun konumu kapalı',
      );
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        throw PlatformException(
          code: 'PERMISSION_DENIED',
          message: 'Konum erişimi reddedildi',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw PlatformException(
        code: 'PERMISSION_DENIED_FOREVER',
        message: 'Konum erişimi her zaman reddedildi',
      );
    }

    Position position = await Geolocator.getCurrentPosition();

    return position;
  }

  void checkLocationPermission() async {
    try {
      await goToLocation();
      // Konum izni alındı, devam edin
    } on PlatformException catch (e) {
      // Hata mesajını telefon ekranına gönderin veya işleyin
      print('Hata kodu: ${e.code}, Hata mesajı: ${e.message}');

      // Konum izni reddedildi veya konum kapalıysa, konumu etkinleştirmek için dialog gösterin
      if (e.code == 'PERMISSION_DENIED' || e.code == 'LOCATION_SERVICES_DISABLED') {
        var context;
        await showPlatformDialog(
          context: context,
          builder: (_) => BasicDialogAlert(
            title: Text('Konum Etkinleştirme'),
            content: Text('Konumu etkinleştirmek istiyor musunuz?'),
            actions: <Widget>[
              BasicDialogAction(
                title: Text('İptal'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              BasicDialogAction(
                title: Text('Konumu Etkinleştir'),
                onPressed: () {
                  Navigator.pop(context);
                  enableLocation();
                },
              ),
            ],
          ),
        );
      }
    }
  }

  void enableLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
    }
  }
}
