// ignore_for_file: use_key_in_widget_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class CircularProgressComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(5),
              child: Text(
                'Aguarde por favor!',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      ],
    );
  }
}
