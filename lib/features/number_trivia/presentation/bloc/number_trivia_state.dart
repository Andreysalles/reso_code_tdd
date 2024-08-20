import 'package:equatable/equatable.dart';
import 'package:reso_code/features/number_trivia/domain/entities/number_trivia.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();
}

class Empty extends NumberTriviaState {
  const Empty();

  @override
  List<Object?> get props => [];
}

class Loading extends NumberTriviaState {
  const Loading();

  @override
  List<Object?> get props => [];
}

class Loaded extends NumberTriviaState {
  final NumberTrivia trivia;

  const Loaded({required this.trivia});

  @override
  List<Object?> get props => [trivia];
}

class Error extends NumberTriviaState {
  final String message;

  const Error({required this.message});

  @override
  List<Object?> get props => [message];
}
