import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:lista_ir_agora/core/core.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lista_ir_agora/data/datasources/motels/motels_client_http.dart';
import 'package:lista_ir_agora/data/repositories/motels/remote_motels_repository.dart';
import 'package:lista_ir_agora/domain/entities/motels_entity.dart';

import '../../../mocks/response_list_mock.dart';

class MockMotelsClientHttp extends Mock implements MotelsClientHttp {}

void main() {
  late RemoteMotelsRepository repository;
  late MockMotelsClientHttp mockClientHttp;

  setUp(() {
    mockClientHttp = MockMotelsClientHttp();
    repository = RemoteMotelsRepository(motelsClientHttp: mockClientHttp);
  });

  group('RemoteMotelsRepository - getGoNowList', () {
    test('should return a list of motels when the request is successful',
        () async {
      final mockData =
          jsonDecode(ResponseListMock.mock) as Map<String, dynamic>;

      when(() => mockClientHttp.getGoNowList())
          .thenAnswer((_) async => asyncOutputSuccess(mockData));

      final result = await repository.getGoNowList();

      expect(result.isRight, true);
      final motels = result.getOrNull();
      expect(motels, isA<List<MotelsEntity>>());
      expect(motels!.isNotEmpty, true);
      expect(motels.first.name, 'Motel Le Nid');
    });

    test(
        'should return a FormatedException when the response format is incorrect',
        () async {
      final invalidMockData = {'invalid_key': 'unexpected_value'};

      when(() => mockClientHttp.getGoNowList())
          .thenAnswer((_) async => asyncOutputSuccess(invalidMockData));

      final result = await repository.getGoNowList();

      expect(result.isLeft, true);
      expect(result.getLeftOrNull(), isA<FormatedException>());
    });

    test(
        'should return a DefaultException when an exception occurs in the client',
        () async {
      final exception = DefaultException(message: 'Network Error');

      when(() => mockClientHttp.getGoNowList())
          .thenAnswer((_) async => asyncOutputFailure(exception));

      final result = await repository.getGoNowList();

      expect(result.isLeft, true);
      expect(result.getLeftOrNull(), isA<DefaultException>());
      expect(result.getLeftOrNull()?.message, 'Network Error');
    });

    test('should handle unexpected errors gracefully', () async {
      final exception = DefaultException(message: 'Unexpected error');

      when(() => mockClientHttp.getGoNowList())
          .thenAnswer((_) async => asyncOutputFailure(exception));

      final result = await repository.getGoNowList();

      expect(result.isLeft, true);
      expect(result.getLeftOrNull(), isA<DefaultException>());
      expect(result.getLeftOrNull()?.message, 'Unexpected error');
    });
  });
}
