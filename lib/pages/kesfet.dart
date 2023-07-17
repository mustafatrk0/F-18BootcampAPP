import 'package:flutter/material.dart';

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

class Kesfet extends StatelessWidget {
  final List<String> popularPosts = [
    'Popüler Post 1',
    'Popüler Post 2',
    'Popüler Post 3',
    'Popüler Post 4',
    'Popüler Post 5',
    'Popüler Post 6',
  ];

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
              itemCount: (popularPosts.length / 3).ceil(),
              itemBuilder: (BuildContext context, int index) {
                final int startIndex = index * 3;
                final int endIndex = (startIndex + 3 < popularPosts.length) ? startIndex + 3 : popularPosts.length;

                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(endIndex - startIndex, (int i) {
                      final int postIndex = startIndex + i;
                      final String post = popularPosts[postIndex];

                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // Seçilen popüler posta yönlendirme işlemleri burada yapılabilir.
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.0),
                            child: Image.asset(
                              'assets/posts/post_${postIndex + 1}.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    }),
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
