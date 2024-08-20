import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:reso_code/core/network/network_info.dart';

import 'network_info_test.mocks.dart';

@GenerateMocks([InternetConnectionChecker])
void main() {
  NetworkInfoImpl? networkInfoImpl;
  MockInternetConnectionChecker? mockInternetConnectionChecker;

  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockInternetConnectionChecker!);
  });

  group('isConnected', () {
    test(
      'deve encaminhar a chamada para InternetConnectionChecker.hasConnection',
      () async {
        final tHasConnectionFuture = Future.value(true);

        when(mockInternetConnectionChecker!.hasConnection)
            .thenAnswer((_) => tHasConnectionFuture);
        // act
        final result = networkInfoImpl!.isConnected;
        // assert
        verify(mockInternetConnectionChecker!.hasConnection);
        expect(result, tHasConnectionFuture);
      },
    );
  });
}
