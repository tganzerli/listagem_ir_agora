import 'package:flutter_test/flutter_test.dart';
import 'package:lista_ir_agora/data/datasources/motels/motels_client_http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lista_ir_agora/core/core.dart';

class MockRestClient extends Mock implements RestClient {}

class MockRestClientResponse extends Mock implements RestClientResponse {}

class FakeRestClientRequest extends Fake implements RestClientRequest {}

void main() {
  late MockRestClient mockRestClient;
  late MotelsClientHttp motelsClientHttp;
  late MockRestClientResponse mockResponse;

  setUpAll(() {
    registerFallbackValue(FakeRestClientRequest());
  });

  setUp(() {
    mockRestClient = MockRestClient();
    mockResponse = MockRestClientResponse();
    motelsClientHttp = MotelsClientHttp(restClient: mockRestClient);
  });

  void mockRequestResponse(dynamic responseData) {
    when(() => mockResponse.data).thenReturn(responseData);
    when(() => mockResponse.statusCode).thenReturn(200);
    when(() => mockRestClient.request(any()))
        .thenAnswer((_) async => mockResponse);
  }

  group('MotelsClientHttp - getGoNowList', () {
    test('should return success when API response contains a valid', () async {
      final validResponse = {'id': 1, 'name': 'Motel A'};
      mockRequestResponse(validResponse);

      final result = await motelsClientHttp.getGoNowList();

      expect(result.isRight, true);
      expect(result.getOrNull(), validResponse);
    });

    test(
        'should return failure with FormatedException when API response is a map',
        () async {
      final invalidResponse = {'error': 'Invalid format'};
      mockRequestResponse(invalidResponse);

      final result = await motelsClientHttp.getGoNowList();

      expect(result.isLeft, true);
      expect(result.getLeftOrNull(), isA<FormatedException>());
      expect(
          result.getLeftOrNull()?.message, 'Return with different formatting');
    });

    test('should rethrow ValidationException when thrown by RestClient',
        () async {
      final exception = ValidationException(message: 'Invalid data format');
      when(() => mockRestClient.request(any())).thenThrow(exception);

      expect(() => motelsClientHttp.getGoNowList(),
          throwsA(isA<ValidationException>()));
    });

    test(
        'should return failure with DefaultException when an unexpected error occurs',
        () async {
      final errorMessage = 'Unexpected error';
      when(() => mockRestClient.request(any()))
          .thenThrow(Exception(errorMessage));

      final result = await motelsClientHttp.getGoNowList();

      expect(result.isLeft, true);
      expect(result.getLeftOrNull(), isA<DefaultException>());

      final exceptionMessage = result.getLeftOrNull()?.message ?? '';
      expect(exceptionMessage, contains(errorMessage));
    });

    test(
        'should return failure with FormatedException when API response is not a Map<String, dynamic>',
        () async {
      final invalidResponse = ['Not a Map'];
      mockRequestResponse(invalidResponse);

      final result = await motelsClientHttp.getGoNowList();

      expect(result.isLeft, true);
      expect(result.getLeftOrNull(), isA<FormatedException>());
      expect(
          result.getLeftOrNull()?.message, 'Return with different formatting');
    });
  });
}
