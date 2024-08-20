import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:reso_code/core/error/exception.dart';

import '../models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  // Chama o endpoint http://numbersapi.com/{number}.
  //
  // Lança uma [ServerException] para todos os códigos de erro.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  // Chama o endpoint http://numbersapi.com/random.
  //
  // Lança uma [ServerException] para todos os códigos de erro.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({required this.client});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) {
    return _getTriviaFromUrl('http://numbersapi.com/$number');
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() {
    return _getTriviaFromUrl('http://numbersapi.com/random');
  }

  Future<NumberTriviaModel> _getTriviaFromUrl(String url) async {
    final response = await client.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
