import 'dart:convert';

import 'package:exemplo/artist_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

int limit = 30;

class _MyAppState extends State<MyApp> {
  Future<Map> getListArtists() async {
    http.Response response;
    response = await http.get(
      Uri.parse(
          "https://api.vagalume.com.br/rank.php?type=art&period=day&scope=internacional&limit=$limit&apikey={key}"),
    );

    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Top $limit artistas"),
        backgroundColor: Colors.blueGrey[700],
      ),
      body: FutureBuilder(
        future: getListArtists(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              body: Container(
                color: Colors.blueGrey[900],
                child: Column(
                  children: [
                    builderGridView(context, snapshot),
                  ],
                ),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.none ||
              snapshot.connectionState == ConnectionState.waiting) {
            return Text("A espera de dados");
          } else {
            return Text("Erro");
          }
        },
      ),
    );
  }
}

Widget builderGridView(BuildContext context, AsyncSnapshot snapshot) {
  String retornaNome(int index) {
    return snapshot.data["art"]["day"]["internacional"][index]["name"];
  }

  String retornaImagem(int index) {
    return snapshot.data["art"]["day"]["internacional"][index]["pic_medium"];
  }

  String retornaViews(int index) {
    return snapshot.data["art"]["day"]["internacional"][index]["views"];
  }

  var a = snapshot.data["art"]["day"]["internacional"][0]["rank"];

  print(a);
  return Expanded(
    child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: 30,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArtistPage(
                      retornaImagem(index),
                      retornaNome(index),
                      retornaViews(index),
                    ),
                  ));
            },
            child: Card(
              color: Colors.blueGrey[200],
              elevation: 2,
              child: Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    flex: 4,
                    child: Image.network(
                      retornaImagem(index),
                      width: 140,
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            retornaNome(index),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.blueGrey[900],
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          );
        }),
  );
}
