import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:reso_code/core/error/exception.dart';
import 'package:reso_code/core/error/failures.dart';
import 'package:reso_code/core/network/network_info.dart';
import 'package:reso_code/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:reso_code/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:reso_code/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:reso_code/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:reso_code/features/number_trivia/domain/entities/number_trivia.dart';

import 'number_trivia_repository.impl_test.mocks.dart';

@GenerateMocks([
  NumberTriviaRemoteDataSource,
  NumberTriviaLocalDataSource,
  NetworkInfo,
])
void main() {
  NumberTriviaRepositoryImpl? repository;
  MockNumberTriviaRemoteDataSource? mockRemoteDataSource;
  MockNumberTriviaLocalDataSource? mockLocalDataSource;
  MockNetworkInfo? mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource!,
      localDataSource: mockLocalDataSource!,
      networkInfo: mockNetworkInfo!,
    );
  });
  const tNumber = 1;
  const tNumberTrivialModel =
      NumberTriviaModel(number: tNumber, text: 'test trivia');
  const NumberTrivia tNumberTrivia = tNumberTrivialModel;

  void runTestsOnline(void Function() body) {
    group(
      'Dispositivo esta online',
      () {
        setUp(() {
          when(mockNetworkInfo!.isConnected).thenAnswer((_) async => true);
        });
        body();
      },
    );
  }

  void runTestsOffline(void Function() body) {
    group(
      'Dispositivo esta offline',
      () {
        setUp(() {
          when(mockNetworkInfo!.isConnected).thenAnswer((_) async => false);
        });
        body();
      },
    );
  }

  group(
    'getConcreteNumberTrivia',
    () {
      setUp(() {
        // Configuração do stub
        when(mockNetworkInfo!.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataSource!.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTrivialModel);
      });

      test(
        'Deve verificar se o dispositivo está online',
        () async {
          // Ação
          await repository!.getConcreteNumberTrivia(tNumber);

          // Verificação
          verify(mockNetworkInfo!.isConnected);
          verify(mockRemoteDataSource!.getConcreteNumberTrivia(tNumber));
          // Você também pode verificar o cache se necessário
          verify(mockLocalDataSource!.cacheNumberTrivia(tNumberTrivialModel));
        },
      );
    },
  );

  runTestsOnline(
    () {
      test(
          //em portugues
          'deve retornar dados remotos quando a chamada à fonte de dados remota for bem-sucedida',
          () async {
        // arrange
        when(mockRemoteDataSource!.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTrivialModel);
        // act
        final result = await repository!.getConcreteNumberTrivia(tNumber);
        // assert
        verify(mockRemoteDataSource!.getConcreteNumberTrivia(tNumber));
        expect(result, equals(const Right(tNumberTrivia)));
      });
      test(
        'deve armazenar em cache os dados localmente quando a chamada à fonte de dados remota for bem-sucedida',
        () async {
          // arrange
          when(mockRemoteDataSource!.getConcreteNumberTrivia(any))
              .thenAnswer((_) async => tNumberTrivialModel);
          // act
          final result = await repository!.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockRemoteDataSource!.getConcreteNumberTrivia(tNumber));
          expect(result, equals(const Right(tNumberTrivia)));
        },
      );
      test(
          //em portugues
          'Deve retornar server failure   quando a chamada à fonte de dados remota for mal-sucedida',
          () async {
        // arrange
        when(mockRemoteDataSource!.getConcreteNumberTrivia(any))
            .thenThrow(ServerException());
        // act
        final result = await repository!.getConcreteNumberTrivia(tNumber);
        // assert
        verify(mockRemoteDataSource!.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    },
  );

  runTestsOffline(
    () {
      test(
        'Deve retornar os dados em cache localmente quando os dados em cache estiverem presentes',
        () async {
          // arrange
          when(mockLocalDataSource!.getLastNumberTrivia()).thenAnswer(
            (_) async => tNumberTrivialModel,
          );
          // act
          final result = await repository!.getConcreteNumberTrivia(tNumber);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource!.getLastNumberTrivia());
          expect(result, equals(const Right(tNumberTrivialModel)));
        },
      );
      test(
        'Deve retornar falha de cache quando não houver dados em cache presentes',
        () async {
          // arrange
          when(mockLocalDataSource!.getLastNumberTrivia())
              .thenThrow(CacheException());
          // act
          final result = await repository!.getConcreteNumberTrivia(1);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource!.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    },
  );

  group(
    'getRandomNumberTrivia',
    () {
      setUp(() {
        // Configuração do stub
        when(mockNetworkInfo!.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataSource!.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTrivialModel);
      });

      test(
        'Deve verificar se o dispositivo está online',
        () async {
          // Ação
          await repository!.getRandomNumberTrivia();

          // Verificação
          verify(mockNetworkInfo!.isConnected);
          verify(mockRemoteDataSource!.getRandomNumberTrivia());
          // Você também pode verificar o cache se necessário
          verify(mockLocalDataSource!.cacheNumberTrivia(tNumberTrivialModel));
        },
      );
    },
  );

  runTestsOnline(
    () {
      test(
          //em portugues
          'Deve retornar dados remotos quando a chamada à fonte de dados remota for bem-sucedida',
          () async {
        // arrange
        when(mockRemoteDataSource!.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTrivialModel);
        // act
        final result = await repository!.getRandomNumberTrivia();
        // assert
        verify(mockRemoteDataSource!.getRandomNumberTrivia());
        expect(result, equals(const Right(tNumberTrivia)));
      });
      test(
        'Deve armazenar em cache os dados localmente quando a chamada à fonte de dados remota for bem-sucedida',
        () async {
          // arrange
          when(mockRemoteDataSource!.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTrivialModel);
          // act
          final result = await repository!.getRandomNumberTrivia();
          // assert
          verify(mockRemoteDataSource!.getRandomNumberTrivia());
          expect(result, equals(const Right(tNumberTrivia)));
        },
      );
      test(
          //em portugues
          'Deve retornar server failure   quando a chamada à fonte de dados remota for mal-sucedida',
          () async {
        // arrange
        when(mockRemoteDataSource!.getRandomNumberTrivia())
            .thenThrow(ServerException());
        // act
        final result = await repository!.getRandomNumberTrivia();
        // assert
        verify(mockRemoteDataSource!.getRandomNumberTrivia());
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    },
  );

  runTestsOffline(
    () {
      test(
        "Deve retornar os dados em cache localmente quando os dados em cache estiverem presentes",
        () async {
          // arrange
          when(mockLocalDataSource!.getLastNumberTrivia()).thenAnswer(
            (_) async => tNumberTrivialModel,
          );
          // act
          final result = await repository!.getRandomNumberTrivia();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource!.getLastNumberTrivia());
          expect(result, equals(const Right(tNumberTrivialModel)));
        },
      );
      test(
        'Deve retornar falha de cache quando não houver dados em cache presentes',
        () async {
          // arrange
          when(mockLocalDataSource!.getLastNumberTrivia())
              .thenThrow(CacheException());
          // act
          final result = await repository!.getRandomNumberTrivia();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource!.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    },
  );
}
