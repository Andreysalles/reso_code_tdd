import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reso_code/core/error/failures.dart';
import 'package:reso_code/core/usecases/usecase.dart';

import 'package:reso_code/core/util/input_converter.dart';
import 'package:reso_code/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:reso_code/features/number_trivia/domain/usecases/get_concret_number_trivial.dart';
import 'package:reso_code/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:reso_code/features/number_trivia/presentation/bloc/number_trivia_state.dart';

import 'number_trivia_event.dart';

const String serverFailureMessage = 'Falha no servidor';
const String cacheFailureMessage = 'Falha no cache';
const String invalidInputFailureMessage =
    'Entrada inválida - o número deve ser um inteiro positivo ou zero';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(const Empty()) {
    on<GetTriviaForConcreteNumber>(
      (event, emit) async {
        final inputEither =
            inputConverter.stringToUnsignedInteger(event.numberString);

        await inputEither.fold(
          (failure) async {
            emit(const Error(message: invalidInputFailureMessage));
          },
          (integer) async {
            emit(const Loading());

            final result =
                await getConcreteNumberTrivia(Params(number: integer));

            emit(
              _eitherLoadedOrErrorState(result!),
            );
          },
        );
      },
    );
    on<GetTriviaForRandomNumber>(
      (event, emit) async {
        emit(const Loading());
        var result = await getRandomNumberTrivia(NoParams());

        emit(
          _eitherLoadedOrErrorState(result!),
        );
      },
    );
  }

  NumberTriviaState _eitherLoadedOrErrorState(
    Either<Failure, NumberTrivia> failureOrTrivia,
  ) {
    var result = failureOrTrivia.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (trivia) => Loaded(trivia: trivia),
    );
    return result;
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case const (ServerFailure):
        return serverFailureMessage;
      case const (CacheFailure):
        return cacheFailureMessage;
      default:
        return 'Erro inesperado';
    }
  }
}
