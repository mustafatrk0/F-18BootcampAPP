import 'package:flutter/material.dart';

void main() => runApp(ProfilePage());

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profil',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Profil(),
    );
  }
}

class Profil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Sayfası'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 50.0,
              backgroundImage: AssetImage('assets/profile_icon.png'),
            ),
            SizedBox(height: 16.0),
            Text(
              'Kullanıcı Adı',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'E-posta Adresi',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 16.0),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Ad Soyad'),
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('E-posta'),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Telefon'),
            ),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Adres'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Profil düzenleme sayfasına yönlendirme işlemleri burada yapılabilir.
              },
              child: Text('Profili Düzenle'),
            ),
          ],
        ),
      ),
    );
  }
}

