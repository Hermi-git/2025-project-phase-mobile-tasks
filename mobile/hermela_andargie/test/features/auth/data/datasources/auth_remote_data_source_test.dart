import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hermela_andargie/core/errors/exception.dart';
import 'package:hermela_andargie/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:hermela_andargie/features/auth/data/models/auth_tokens_model.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late AuthRemoteDataSourceImpl dataSource;
  late MockClient mockHttpClient;

  const baseUrl = 'https://api.example.com/v2';

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = AuthRemoteDataSourceImpl(
      client: mockHttpClient,
      baseUrl: baseUrl,
    );
  });

  group('login', () {
    final tAuthTokensModel = const AuthTokensModel(
      accessToken: 'abc123',
      refreshToken: 'ref456',
    );

    test('should return AuthTokensModel when response code is 200', () async {
      when(
        mockHttpClient.post(
          Uri.parse('$baseUrl/login'),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer(
        (_) async => http.Response(jsonEncode(tAuthTokensModel.toJson()), 200),
      );

      final result = await dataSource.login(
        email: 'test@test.com',
        password: '123456',
      );

      expect(result, equals(tAuthTokensModel));
    });

    test(
      'should throw ServerException when response code is not 200',
      () async {
        when(
          mockHttpClient.post(
            any,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenAnswer((_) async => http.Response('Error', 404));

        expect(
          () => dataSource.login(email: 'test', password: '123'),
          throwsA(isA<ServerException>()),
        );
      },
    );
  });

  // Similar tests for register and getCurrentUser...
}
