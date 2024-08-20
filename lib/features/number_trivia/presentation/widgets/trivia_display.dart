import 'package:flutter/material.dart';

import '../../domain/entities/number_trivia.dart';

class TriviaDisplay extends StatelessWidget {
  final NumberTrivia numberTrivia;

  const TriviaDisplay({
    super.key,
    required this.numberTrivia,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Flexible(
          child: Text(
            numberTrivia.number.toString(),
            style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
          ),
        ),
        IntrinsicHeight(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: const  BoxDecoration(),
              child: Text(
                numberTrivia.text,
                style: const TextStyle(fontSize: 22),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
