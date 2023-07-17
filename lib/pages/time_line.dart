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
    //getUsers();
    //getUserById();
    //getUserByUserName();
    super.initState();
  }
/*
  getUsers() async {
    final QuerySnapshot snapshot = await usersRef.get();

    for (var doc in snapshot.docs) {
      print(doc.data());
      print(doc.data().runtimeType);
    }

    setState(() {
      users = snapshot.docs;
    });
  }*/

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

  //Future<QuerySnapshot>? searchResultsFuture;
/*
  handleSearch(String query) {
    Future<QuerySnapshot> users =
        usersRef.where('username', isGreaterThanOrEqualTo: query).get();
    setState(() {
      searchResultsFuture = users;
    });
  }*/
/*
  buildSearchResults() {
    return FutureBuilder(
      future: searchResultsFuture,
      builder: (context, snapshot) {
        return Center(child: const CircularProgressIndicator());
        List<Text> searchResults = [];

        snapshot.data!.docs.forEach((doc) {
          User user = User.fromDocument
        })
      },
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: TextFormField(
            decoration: InputDecoration(
                hintText: 'Kullanıcı Ara...',
                filled: true,
                prefixIcon: Icon(
                  Icons.account_box,
                  size: 28.0,
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () => print('temizlendi'),
                )),
            //onFieldSubmitted: handleSearch('serkan'),
          ),
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
                final List<Text> children = snapshot.data!.docs
                    .map((doc) {
                  final Map<String, dynamic>? data =
                  doc.data() as Map<String, dynamic>?;

                  if (doc.exists &&
                      data != null &&
                      data.containsKey('username')) {
                    return Text(data['username']);
                  } else {
                    return null;
                  }
                })
                    .where((text) => text != null)
                    .map<Text>((text) => text!)
                    .toList();





                return Container(
                  child: Center(
                    child: ListView.builder(
                      itemCount: children.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.person),
                              SizedBox(width: 8.0),
                              Expanded(child: children[index]),
                              IconButton(
                                icon: Icon(Icons.add_circle),
                                onPressed: () {
                                  // İşlemi gerçekleştir
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              }
            })

    );
  }
}
