import 'dart:convert';

import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:reso_code/core/error/exception.dart';
import 'package:reso_code/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:reso_code/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  NumberTriviaRemoteDataSourceImpl? dataSource;
  MockClient? mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient!);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient!.get(
      any,
      headers: anyNamed('headers'),
    )).thenAnswer(
      (_) async => http.Response(fixture('trivia.json'), 200),
    );
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient!.get(
      any,
      headers: anyNamed('headers'),
    )).thenAnswer(
      (_) async => http.Response('Algo deu errado', 404),
    );
  }

  group(
    'getContreteNumberTrivia',
    () {
      const tNumber = 1;
      final tNumberTriviaModel =
          NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
      test(
        'deve realizar uma solicitação GET em uma URL com o número sendo o endpoint e com o cabeçalho application/json',
        () async {
          // arrange

          setUpMockHttpClientSuccess200();

          // act

          dataSource!.getConcreteNumberTrivia(tNumber);

          // assert

          verify(mockHttpClient!.get(
            Uri.parse('http://numbersapi.com/$tNumber'),
            headers: {'Content-Type': 'application/json'},
          ));
        },
      );
      test(
        'deve retornar NumberTrivia quando o código de resposta for 200 (sucesso)',
        () async {
          // arrange
          setUpMockHttpClientSuccess200();

          // act
          final result = await dataSource!.getConcreteNumberTrivia(tNumber);

          // assert
          expect(result, equals(tNumberTriviaModel));
        },
      );

      test(
        'deve lançar uma ServerException quando o código de resposta for diferente de 200',
        () async {
          // arrange
          setUpMockHttpClientFailure404();
          // act
          final call = dataSource!.getConcreteNumberTrivia;

          // assert
          expect(() => call(tNumber), throwsA(isA<ServerException>()));
        },
      );
    },
  );
  group(
    'getRandomNumberTrivia',
    () {
      final tNumberTriviaModel =
          NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
      test(
        'deve realizar uma solicitação GET em uma URL com o número sendo o endpoint e com o cabeçalho application/json',
        () async {
          // arrange

          setUpMockHttpClientSuccess200();

          // act

          dataSource!.getRandomNumberTrivia();

          // assert

          verify(mockHttpClient!.get(
            Uri.parse('http://numbersapi.com/random'),
            headers: {'Content-Type': 'application/json'},
          ));
          expect(1, 1);
        },
      );
      test(
        'deve retornar NumberTrivia quando o código de resposta for 200 (sucesso)',
        () async {
          // arrange
          setUpMockHttpClientSuccess200();

          // act
          final result = await dataSource!.getRandomNumberTrivia();

          // assert
          expect(result, equals(tNumberTriviaModel));
        },
      );

      test(
        'deve lançar uma ServerException quando o código de resposta for diferente de 200',
        () async {
          // arrange
          setUpMockHttpClientFailure404();
          // act
          final call = dataSource!.getRandomNumberTrivia;

          // assert
          expect(() => call(), throwsA(isA<ServerException>()));
        },
      );
    },
  );
}
