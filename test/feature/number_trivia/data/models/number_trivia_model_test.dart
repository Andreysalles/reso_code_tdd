import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:reso_code/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:reso_code/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test Text');

  test(
    // em portugues:
    'Deve ser uma subclasse da entidade NumberTrivia',
    () async {
      // assert
      expect(tNumberTriviaModel, isA<NumberTrivia>());
    },
  );

  group(
    "fromJson",
    () {
      test(
        'Deve retornar um modelo válido quando o JSON number é um inteiro',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap = json.decode(
            fixture('trivia.json'),
          );
          // act
          final result = NumberTriviaModel.fromJson(jsonMap);
          // assert
          expect(result, tNumberTriviaModel);
        },
      );

      test(
        // em portugues:
        'Deve retornar um modelo válido quando o JSON number é considerado um double',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap = json.decode(
            fixture('trivia_double.json'),
          );
          // act
          final result = NumberTriviaModel.fromJson(jsonMap);
          // assert
          expect(result, tNumberTriviaModel);
        },
      );
    },
  );
  group('toJson', () {
    test(
      'Deve retornar um JSON map contendo os dados corretos',
      () async {
        // act
        final result = tNumberTriviaModel.toJson();
        // assert
        final expectedMap = {
          "text": "Test Text",
          "number": 1,
        };
        expect(result, expectedMap);
      },
    );
  });
}
