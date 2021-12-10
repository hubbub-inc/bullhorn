import 'package:flutter/material.dart';

class FancyCard extends StatelessWidget {
  FancyCard({required this.image, required this.title});

  final Image image;
  final String title;
  TextEditingController bullhornController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[

            Container(
              width: 250,
              height: 250,
              child: image,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.headline5,
            ),
            OutlineButton(
              child: Icon(Icons.arrow_circle_up_sharp),
              onPressed: () => print("Button was tapped"),
            ),
          ],
        ),
      ),
    );
  }
}
