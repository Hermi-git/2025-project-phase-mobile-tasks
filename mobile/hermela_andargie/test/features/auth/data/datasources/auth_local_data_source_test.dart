import 'package:flutter_test/flutter_test.dart';
import 'package:hermela_andargie/core/errors/exception.dart';
import 'package:hermela_andargie/core/storage/secure_storage.dart';
import 'package:hermela_andargie/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:hermela_andargie/features/auth/data/models/auth_tokens_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';


import 'auth_local_data_source_test.mocks.dart';

@GenerateMocks([SecuredStorage])
void main() {
  late AuthLocalDataSourceImpl dataSource;
  late MockSecuredStorage mockSecuredStorage;

  setUp(() {
    mockSecuredStorage = MockSecuredStorage();
    dataSource = AuthLocalDataSourceImpl(securedStorage: mockSecuredStorage);
  });

  final tAuthTokensModel = const AuthTokensModel(
    accessToken: 'abc',
    refreshToken: 'ref',
  );

  group('cacheTokens', () {
    test('should call SecuredStorage.writeToken', () async {
      await dataSource.cacheTokens(tAuthTokensModel);
      verify(mockSecuredStorage.writeToken(tAuthTokensModel)).called(1);
    });

    test('should throw CacheException on error', () async {
      when(mockSecuredStorage.writeToken(any)).thenThrow(Exception());
      expect(
        () => dataSource.cacheTokens(tAuthTokensModel),
        throwsA(isA<CacheException>()),
      );
    });
  });

  group('getTokens', () {
    test('should return AuthTokensModel when data exists', () async {
      when(
        mockSecuredStorage.readToken(),
      ).thenAnswer((_) async => tAuthTokensModel);
      final result = await dataSource.getTokens();
      expect(result, equals(tAuthTokensModel));
    });

    test('should return null when no data exists', () async {
      when(mockSecuredStorage.readToken()).thenAnswer((_) async => null);
      final result = await dataSource.getTokens();
      expect(result, isNull);
    });

    test('should throw CacheException on error', () async {
      when(mockSecuredStorage.readToken()).thenThrow(Exception());
      expect(() => dataSource.getTokens(), throwsA(isA<CacheException>()));
    });
  });
}
