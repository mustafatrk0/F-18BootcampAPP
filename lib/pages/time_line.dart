import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference usersRef =
    FirebaseFirestore.instance.collection("Users");

class TimeLine extends StatefulWidget {
  const TimeLine({super.key});

  @override
  State<TimeLine> createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {
  List<dynamic> users = [];

  @override
  void initState() {
    getUsers();
    //getUserById();
    //getUserByUserName();
    super.initState();
  }

  getUsers() async {
    final QuerySnapshot snapshot = await usersRef.get();

    for (var doc in snapshot.docs) {
      print(doc.data());
      print(doc.data().runtimeType);
    }

    setState(() {
      users = snapshot.docs;
    });
  }


/*
  getUsers() async {

    final QuerySnapshot snapshot = await usersRef.get();

    setState(() {
      users = snapshot.docs;
    });
  }*/

/*
  getUsers() async {
    /*await usersRef.get().then((QuerySnapshot snapshot){
      snapshot.docs.forEach((DocumentSnapshot doc) {
        print(doc.data());
      });
    });*/

    final QuerySnapshot snapshot = await usersRef.get();

    setState(() {
      users = snapshot.docs;
    });
  }
  */

/*
  getUserById() async {
    final String id = 'serkan@gmail.com';
    final DocumentSnapshot doc = await usersRef.doc(id).get();
    if (doc.exists) {
      // Eğer belge varsa, alanlara erişebilirsiniz
      final userData = doc.data();
      print(userData['username']);
    } else {
      // Belge bulunamazsa hata işleme yapabilirsiniz
      print('Belge bulunamadı');
    }
  }
*/
/*
  getUserByUserName() async {
    final QuerySnapshot snapshot =
        await usersRef.where('username', isEqualTo: 'serkan').get();
    snapshot.docs.forEach((DocumentSnapshot doc) {
      print(doc.data());
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kullanıcı Listesi'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator(
              color: Colors.green,
            );
            /*List<dynamic> users = snapshot.data!.docs;
            return ListView(
              children: users.map((user) => Text(user['username'])).toList(),
            );*/
          } else if (snapshot.hasError) {
            // Handle the error state
            return Text('An error occurred: ${snapshot.error}');
          } else {
            final List<Text> children = snapshot.data!.docs.map((doc) => Text(doc['username'])).toList();

            return Container(
              child: ListView(
                children: children,
              ),
            );
          }
        },
      ),
    );
  }

}
