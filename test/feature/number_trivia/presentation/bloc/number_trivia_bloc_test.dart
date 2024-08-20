import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:reso_code/core/error/failures.dart';
import 'package:reso_code/core/usecases/usecase.dart';
import 'package:reso_code/core/util/input_converter.dart';
import 'package:reso_code/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:reso_code/features/number_trivia/domain/usecases/get_concret_number_trivial.dart';
import 'package:reso_code/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:reso_code/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:reso_code/features/number_trivia/presentation/bloc/number_trivia_event.dart';
import 'package:reso_code/features/number_trivia/presentation/bloc/number_trivia_state.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([
  GetConcreteNumberTrivia,
  GetRandomNumberTrivia,
  InputConverter,
])
void main() {
  NumberTriviaBloc? bloc;
  MockGetConcreteNumberTrivia? mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia? mockGetRandomNumberTrivia;
  MockInputConverter? mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia!,
      getRandomNumberTrivia: mockGetRandomNumberTrivia!,
      inputConverter: mockInputConverter!,
    );
  });

  test('initialState Deve ser Empty', () {
    // assert
    expect(bloc!.state, const Empty());
  });

  group('GetTriviaForConcreteNumber', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    const tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    void setUpMockInputConverterSuccess() {
      when(mockGetConcreteNumberTrivia!(const Params(number: tNumberParsed)))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      when(mockInputConverter!.stringToUnsignedInteger(any))
          .thenReturn(const Right(tNumberParsed));
    }

    test(
      'Deve verificar se o estado está correto para a chamada de InputConverter',
      () async {
        // arrange
        setUpMockInputConverterSuccess();

        // act
        bloc!.add(const GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockInputConverter!.stringToUnsignedInteger(any));

        // assert
        verify(mockInputConverter!.stringToUnsignedInteger(tNumberString));
      },
    );

    test(
      'Deve emitir [Error] quando a entrada for inválida',
      () async {
        // arrange
        when(mockInputConverter!.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));

        // assert later
        final expected = [
          const Error(message: invalidInputFailureMessage),
        ];

        expectLater(bloc!.stream, emitsInOrder(expected));
        // act
        bloc!.add(const GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      'Deve obter dados do caso de uso concreto',
      () async {
        // arrange
        setUpMockInputConverterSuccess();

        // assert later
        final expected = [
          const Loading(),
          const Loaded(trivia: tNumberTrivia),
        ];

        expectLater(bloc!.stream, emitsInOrder(expected));
        // act
        bloc!.add(const GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      'Deve emitir [Loading, Error] quando o caso de uso concreto falhar',
      () async {
        // arrange
        setUpMockInputConverterSuccess();

        when(mockGetConcreteNumberTrivia!(
          const Params(number: tNumberParsed),
        )).thenAnswer((_) async => Left(ServerFailure()));

        // assert later
        final expected = [
          const Loading(),
          const Error(message: serverFailureMessage),
        ];

        expectLater(bloc!.stream, emitsInOrder(expected));
        // act
        bloc!.add(const GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      'Deve emitir [Loading, Error] com a mensagem correta para o erro quando a busca de dados no cache falhar',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia!(
          const Params(number: tNumberParsed),
        )).thenAnswer((_) async => Left(CacheFailure()));

        // assert later
        final expected = [
          const Loading(),
          const Error(message: cacheFailureMessage),
        ];

        expectLater(bloc!.stream, emitsInOrder(expected));
        // act
        bloc!.add(const GetTriviaForConcreteNumber(tNumberString));
      },
    );
  });

  group('GetTriviaForRandomNumber', () {
    const tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    void setUpMockInputConverterSuccess() {
      when(mockGetRandomNumberTrivia!(NoParams()))
          .thenAnswer((_) async => const Right(tNumberTrivia));
    }

    test(
      'Deve obter dados do caso de uso Random',
      () async {
        // arrange
        setUpMockInputConverterSuccess();

        // assert later
        final expected = [
          const Loading(),
          const Loaded(trivia: tNumberTrivia),
        ];

        expectLater(bloc!.stream, emitsInOrder(expected));
        // act
        bloc!.add(const GetTriviaForRandomNumber());
      },
    );

    test(
      'Deve emitir [Loading, Error] quando o caso de uso Random falhar',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetRandomNumberTrivia!(NoParams()))
            .thenAnswer((_) async => Left(ServerFailure()));

        // assert later
        final expected = [
          const Loading(),
          const Error(message: serverFailureMessage),
        ];

        expectLater(bloc!.stream, emitsInOrder(expected));
        // act
        bloc!.add(const GetTriviaForRandomNumber());
      },
    );

    test(
      'Deve emitir [Loading, Error] com a mensagem correta para o erro quando a busca de dados no cache falhar no caso de uso Random',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetRandomNumberTrivia!(NoParams()))
            .thenAnswer((_) async => Left(CacheFailure()));

        // assert later
        final expected = [
          const Loading(),
          const Error(message: cacheFailureMessage),
        ];

        expectLater(bloc!.stream, emitsInOrder(expected));
        // act
        bloc!.add(const GetTriviaForRandomNumber());
      },
    );
  });
}
