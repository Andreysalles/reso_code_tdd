import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reso_code/core/util/input_converter.dart';

void main() {
  InputConverter? inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group(
    'stringToUnsignedInt',
    () {
      test(
        'Deve retornar um inteiro quando a string representar um inteiro positivo',
        () {
          // arrange
          const str = '123';

          // act
          final result = inputConverter!.stringToUnsignedInteger(str);

          // assert
          expect(result, const Right(123));
        },
      );

      test(
        'Deve retornar um Failure quando a string não for um inteiro',
        () {
          // arrange
          const str = 'abc';

          // act
          final result = inputConverter!.stringToUnsignedInteger(str);

          // assert
          expect(result, Left(InvalidInputFailure()));
        },
      );

      test(
        'Deve retornar um Failure quando a string for um inteiro negativo',
        () {
          // arrange
          const str = '-123';

          // act
          final result = inputConverter!.stringToUnsignedInteger(str);

          // assert
          expect(result, Left(InvalidInputFailure()));
        },
      );
    },
  );
}
