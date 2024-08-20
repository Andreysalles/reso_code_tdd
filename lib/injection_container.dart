import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:reso_code/core/network/network_info.dart';
import 'package:reso_code/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:reso_code/features/number_trivia/domain/usecases/get_concret_number_trivial.dart';
import 'package:reso_code/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/util/input_converter.dart';
import 'features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:http/http.dart' as http;

final getIt = GetIt.instance;

Future<void> init() async {
  //! Features - Number Trivia
  // Bloc
  getIt.registerFactory(() => NumberTriviaBloc(
        getConcreteNumberTrivia: getIt(),
        getRandomNumberTrivia: getIt(),
        inputConverter: getIt(),
      ));

  //Use cases
  getIt.registerLazySingleton(
    () => GetConcreteNumberTrivia(getIt()),
  );
  getIt.registerLazySingleton(
    () => GetRandomNumberTrivia(getIt()),
  );

  // Repository
  getIt.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      remoteDataSource: getIt<NumberTriviaRemoteDataSourceImpl>(),
      localDataSource: getIt<NumberTriviaLocalDataSourceImpl>(),
      networkInfo: getIt(),
    ),
  );

  //Data sources

  getIt.registerLazySingleton(
    () => NumberTriviaRemoteDataSourceImpl(client: getIt()),
  );

  getIt.registerLazySingleton(
    () => NumberTriviaLocalDataSourceImpl(sharedPreferences: getIt()),
  );

  //! Core
  getIt.registerLazySingleton(() => InputConverter());
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  getIt.registerLazySingleton(() => http.Client());
  getIt.registerLazySingleton(() => InternetConnectionChecker());
}

void initFeatures() {}
