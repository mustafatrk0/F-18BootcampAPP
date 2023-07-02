import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ouakr/profil.dart';
import 'package:ouakr/kesfet.dart';
import 'package:ouakr/camera.dart';
import 'package:ouakr/giris.dart';
import 'package:ouakr/singlephoto.dart';
import 'package:custom_marker/marker_icon.dart';


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

  Set<Marker> konum = { };
  List<Marker> pic = [ ];
  List<LatLng> coordinateList = [];


  int seciliSayfa = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(child: Text("Keşfet", style: TextStyle(color: Colors.black))),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings, color: Colors.black),
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
        //tiltGesturesEnabled: true,
        //compassEnabled: true,
        //scrollGesturesEnabled: true,
        markers: konum,
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

          //anlikKonum();
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
            Navigator.push(context, MaterialPageRoute(builder:(context)=>LoginPage()));
          }
          else if(index == 4){
            Navigator.push(context, MaterialPageRoute(builder:(context)=>Profil()));
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
              icon: Icon(Icons.add_box),
              label: "Ekle"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: "Bildirim"
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
    anlikKonum();
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

  Future<void> anlikKonum() async {

    Position position = await goToLocation();

    konum.clear();

    konum.add(Marker(
      markerId: MarkerId('anlikKonum'),
      position: LatLng(position.latitude,position.longitude),
      //icon: await MarkerIcon.downloadResizePictureCircle(widget.imageUrl!),
      icon: await MarkerIcon.pictureAsset(assetPath: 'assets/profile_icon.png', width: 110, height: 110),
    ),
    );
    setState(() {});
  }
  Future<void> picKonum() async {
    pic.add(Marker(
      markerId: MarkerId('picKonum'),
      position: LatLng(41.015137,28.979530),
      icon: await MarkerIcon.downloadResizePictureCircle(widget.imageUrl!),
    ),
    );
    setState(() {});
  }
}