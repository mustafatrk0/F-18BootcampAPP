import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

void main() => runApp(KesfetPage());

class KesfetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Keşfet Sayfası',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Kesfet(),
    );
  }
}

class Kesfet extends StatefulWidget {
  @override
  _KesfetState createState() => _KesfetState();
}

class _KesfetState extends State<Kesfet> {
  List<String> imageUrls = [];

  @override
  void initState() {
    super.initState();
    getImagesFromFolders();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keşfet'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Arama',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: imageUrls.length,
              itemBuilder: (BuildContext context, int index) {
                final String imageUrl = imageUrls[index];

                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
