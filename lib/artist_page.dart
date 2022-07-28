import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ArtistPage extends StatelessWidget {
  const ArtistPage(this.image, this.nome, this.views, {Key? key})
      : super(key: key);

  final String image;
  final String nome;
  final String views;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[700],
      ),
      body: Center(
        child: Column(
          children: [
            Card(
              elevation: 2,
              child: Container(
                child: Column(
                  children: [
                    Image.network(image),
                    BuilderDadosText(nome),
                    BuilderDadosText("Views: $views"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget BuilderDadosText(String dado) {
    return Text(
      dado,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
    );
  }
}
