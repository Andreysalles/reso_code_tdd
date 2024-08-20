import 'dart:convert';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reso_code/core/error/exception.dart';
import 'package:reso_code/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:reso_code/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_local_data_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  NumberTriviaLocalDataSourceImpl? dataSource;
  MockSharedPreferences? mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences!);
  });

  group(
    'getLastNumberTrivia',
    () {
      final tNumberTriviaModel = NumberTriviaModel.fromJson(
        json.decode(
          fixture('trivia_cached.json'),
        ),
      );

      test(
          'deve retornar NumberTrivia do SharedPreferences quando houver um no cache',
          () async {
        // arrange
        when(mockSharedPreferences!.getString(any))
            .thenReturn(fixture('trivia_cached.json'));
        // act
        final result = await dataSource!.getLastNumberTrivia();
        // assert
        verify(mockSharedPreferences!.getString(cachedNumberTrivia));
        expect(result, equals(tNumberTriviaModel));
      });

      test('deve lançar uma CacheException quando não houver um valor em cache',
          () async {
        // arrange
        when(mockSharedPreferences!.getString(any)).thenReturn(null);
        // act
        final call = dataSource!.getLastNumberTrivia;
        // assert
        expect(() => call(), throwsA(isA<CacheException>()));
      });
    },
  );

  group(
    'cacheNumberTrivia',
    () {
      const tNumberTriviaModel =
          NumberTriviaModel(number: 1, text: 'test trivia');
      test('deve chamar SharedPreferences para armazenar os dados', () async {
        //arrange
        when(mockSharedPreferences!.setString(any, any))
            .thenAnswer((_) async => true);

        // act
        dataSource!.cacheNumberTrivia(tNumberTriviaModel);
        // assert
        final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
        verify(mockSharedPreferences!
            .setString(cachedNumberTrivia, expectedJsonString));
      });
    },
  );
}
