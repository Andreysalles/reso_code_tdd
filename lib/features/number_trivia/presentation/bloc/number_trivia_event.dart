import 'package:equatable/equatable.dart';

abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent([List<Object?> props = const <Object>[]]) : super();
}

class GetTriviaForConcreteNumber extends NumberTriviaEvent {
  final String numberString;

  const GetTriviaForConcreteNumber(this.numberString);

  @override
  List<Object?> get props => [numberString];
}

class GetTriviaForRandomNumber extends NumberTriviaEvent {
  const GetTriviaForRandomNumber();

  @override
  List<Object?> get props => [];
}
