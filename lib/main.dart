import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomeScreen(),
    );
  }
}

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  Future<List<Map<String, dynamic>>> getAPI() async {
    http.Response response = await http.get(Uri.parse(
        "https://apiv3.apifootball.com/?action=get_countries&APIkey=b3a2ed53a3c13a47537e7a75f663daa2084b754bc0055214fa2e2e30476ae394"));
    if (response.statusCode == 200) {
      List<Map<String, dynamic>> body =
          List<Map<String, dynamic>>.from(jsonDecode(response.body));
      return body;
    } else {
      print('api gagal');
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Home'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getAPI(),
        builder: (_, snapshot) {
          // Tidak ada data
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          // Ada data
          return SizedBox(
            child: SingleChildScrollView(
              child: Column(
                children: snapshot.data!
                    .map((value) {
                      return Container(
                        height: 80,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(1, 1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              child: Image.network(
                                (value['country_logo'] as String)
                                    .replaceAll('\\', ''),
                                errorBuilder: (_, __, ___) {
                                  return const Icon(
                                    Icons.image_not_supported_rounded,
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(value['country_name']),
                            ),
                          ],
                        ),
                      );
                    })
                    .toSet()
                    .toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
