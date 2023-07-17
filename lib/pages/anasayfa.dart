import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ouakr/pages/profile_pages.dart';
import 'package:ouakr/pages/kesfet.dart';
import 'package:ouakr/pages/camera.dart';
import 'package:custom_marker/marker_icon.dart';
import 'package:ouakr/pages/time_line.dart';
import 'package:firebase_storage/firebase_storage.dart';


class Anasayfa extends StatefulWidget {
  @override
  State<Anasayfa> createState() => AnasayfaState();

  final String? imageUrl;

  const Anasayfa({this.imageUrl});

}

class AnasayfaState extends State<Anasayfa> {
  //Completer<GoogleMapController> _controller = Completer();

  late GoogleMapController googleMapController;

  LatLngBounds turkeyBounds = LatLngBounds(
    southwest: LatLng(36.0, 26.0), // Türkiye'nin güneybatı köşesi
    northeast: LatLng(42.0, 45.0), // Türkiye'nin kuzeydoğu köşesi
  );

  static final CameraPosition _initalCameraPosition = CameraPosition(
    target: LatLng(40.015137, 35.279530),
    zoom: 4.85,
  );

  Set<Marker> pic = { };
  List<String> imageUrls = [];
  //List<Marker> pice = [ ];
  //List<LatLng> coordinateList = [];

  int seciliSayfa = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(child: Text("WanderMApp", style: TextStyle(color: Colors.black))),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.favorite_border, color: Colors.grey),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Anasayfa()));
            },
          ),
        ],
      ),
      body: GoogleMap(
        myLocationButtonEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition: _initalCameraPosition,
        cameraTargetBounds: CameraTargetBounds(turkeyBounds),
        zoomControlsEnabled: false,
        myLocationEnabled: true,
        //tiltGesturesEnabled: true,
        //compassEnabled: true,
        //scrollGesturesEnabled: true,
        markers: pic,
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Position position = await goToLocation();

          googleMapController.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: LatLng(position.latitude,position.longitude),
                  tilt: 59.440717697143555,
                  zoom: 16.151926040649414,
                  bearing: 360.8334901395799)));
        },
        child: Icon(
          Icons.location_searching,
          color: Colors.purple,
          size: 60,
        ),
        backgroundColor: Colors.transparent,
        elevation: 5,
        splashColor: Colors.grey,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: seciliSayfa,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        iconSize: 35,
        fixedColor: Colors.purple,
        onTap: (index) {
          if(index == 0){
            Navigator.push(context, MaterialPageRoute(builder:(context)=>Anasayfa()));
          }
          else if(index == 1){
            Navigator.push(context, MaterialPageRoute(builder:(context)=>Kesfet()));
          }
          else if(index == 2){
            //openCamera();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CameraPage(),
              ),
            );
          }
          else if(index == 3){
            Navigator.push(context, MaterialPageRoute(builder:(context)=>TimeLine()));
          }
          else if(index == 4){
            Navigator.push(context, MaterialPageRoute(builder:(context)=>ProfilePage()));
          }
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Anasayfa"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "Keşfet"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt),
              label: "Ekle"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_add),
              label: "Topluluk"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profil"
          ),
        ],
      ),
    );
  }

  Future<Position> goToLocation() async {
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
        message: 'Konum erişimi herzaman reddedildi',
      );
    }

    Position position = await Geolocator.getCurrentPosition();

    return position;
  }

  @override
  void initState() {
    super.initState();
    checkLocationPermission();
    getImagesFromFirestore();
    //getImagesFromFolders();
    //picKonum();
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
        await showPlatformDialog(
          context: context,
          builder: (_) => BasicDialogAlert(
            title: Text('Konum Etkinleştirme'),
            content: Text('Konumu etkinleştirmek istiyor musunuz ?'),
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
/*
  Future<void> picKonum() async {

    Position position = await goToLocation();

    for(int i = 0; i < imageUrls.length ; i++){
      pic.add(Marker(
        markerId: MarkerId('picKonum'),
        position: LatLng(position.latitude,position.longitude),
        icon: await MarkerIcon.downloadResizePictureCircle(imageUrls[i]),
        //icon: await MarkerIcon.pictureAsset(assetPath: 'assets/profile_icon.png', width: 110, height: 110),
      ),
      );
    }
    setState(() {});
  }
  Future<void> getImagesFromFolders() async {
    final Reference storageRef = FirebaseStorage.instance.ref().child('paylasimlar');
    final ListResult result = await storageRef.listAll();

    for (final Reference ref in result.prefixes) {
      final ListResult subResult = await ref.listAll();

      for (final Reference subRef in subResult.items) {
        final String downloadUrl = await subRef.getDownloadURL();
        setState(() {
          imageUrls.add(downloadUrl);
        });
      }
    }
  }
*/
  Future<void> getImagesFromFirestore() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final CollectionReference photosRef = firestore.collection('Photos');

    final QuerySnapshot snapshot = await photosRef.get();

    if (snapshot != null) {
      final List<QueryDocumentSnapshot> documents = snapshot.docs;
      for (final DocumentSnapshot doc in documents) {
        final Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey('photoUrl') && data.containsKey('latitude') && data.containsKey('longitude')) {
          final String photoUrl = data['photoUrl'] as String;
          final double latitude = data['latitude'] as double;
          final double longitude = data['longitude'] as double;

          final LatLng position = LatLng(latitude, longitude);

          pic.add(Marker(
            markerId: MarkerId('picKonum_${doc.id}'),
            position: position,
            icon: await MarkerIcon.downloadResizePictureCircle(photoUrl),
          ));
        }
      }
    }

    setState(() {});
  }

}