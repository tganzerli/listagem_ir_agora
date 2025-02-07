import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:lista_ir_agora/core/core.dart';
import 'package:lista_ir_agora/data/adapters/motels/go_now_list_adapter.dart';

import '../../../mocks/response_list_mock.dart';

void main() {
  late Map<String, dynamic> defaultResponseMap;

  setUp(() {
    defaultResponseMap = json.decode(ResponseListMock.mock);
  });

  Map<String, dynamic> generateModifiedResponse({
    required String keyPath,
    required dynamic newValue,
  }) {
    final modifiedMap = json.decode(ResponseListMock.mock);
    List<String> keys = keyPath.split('.');

    dynamic current = modifiedMap;
    for (int i = 0; i < keys.length - 1; i++) {
      if (current is Map<String, dynamic> && current.containsKey(keys[i])) {
        current = current[keys[i]];
      } else if (current is List && int.tryParse(keys[i]) != null) {
        int index = int.parse(keys[i]);
        if (index >= 0 && index < current.length) {
          current = current[index];
        } else {
          return modifiedMap;
        }
      } else {
        return modifiedMap;
      }
    }

    if (current is Map<String, dynamic>) {
      current[keys.last] = newValue;
    }

    return modifiedMap;
  }

  group('GoNowListAdapter - fromMap()', () {
    test('should successfully parse a valid response', () {
      final result = GoNowListAdapter.fromMap(defaultResponseMap);

      expect(result.isRight, isTrue);
      final motels = result.getOrNull();
      expect(motels, isNotNull);
      expect(motels!.length, greaterThan(0));
      expect(motels[0].name, 'Motel Le Nid');
    });

    test('should return failure when map is empty', () {
      final result = GoNowListAdapter.fromMap({});

      expect(result.isLeft, isTrue);
      expect(result.getLeftOrNull(), isA<FormatedException>());
    });

    test('should return failure when "data" key is missing', () {
      final modifiedResponse = generateModifiedResponse(
        keyPath: 'data',
        newValue: null,
      );

      final result = GoNowListAdapter.fromMap(modifiedResponse);

      expect(result.isLeft, isTrue);
      expect(result.getLeftOrNull(), isA<FormatedException>());
    });

    test('should return failure when "moteis" key is missing in "data"', () {
      final modifiedResponse = generateModifiedResponse(
        keyPath: 'data.moteis',
        newValue: null,
      );

      final result = GoNowListAdapter.fromMap(modifiedResponse);

      expect(result.isLeft, isTrue);
      expect(result.getLeftOrNull(), isA<FormatedException>());
    });

    test('should return failure when "moteis" is not a list', () {
      final modifiedResponse = generateModifiedResponse(
        keyPath: 'data.moteis',
        newValue: "invalid_type",
      );

      final result = GoNowListAdapter.fromMap(modifiedResponse);

      expect(result.isLeft, isTrue);
      expect(result.getLeftOrNull(), isA<FormatedException>());
    });

    test('should return failure when a motel has an invalid structure', () {
      final modifiedResponse = generateModifiedResponse(
        keyPath: 'data.moteis.0.logo',
        newValue: 123,
      );

      final result = GoNowListAdapter.fromMap(modifiedResponse);

      expect(result.isLeft, isTrue);
      expect(result.getLeftOrNull(), isA<FormatedException>());
    });

    test('should return failure when a motel contains an invalid room', () {
      final modifiedResponse = generateModifiedResponse(
        keyPath: 'data.moteis.0.suites.0.fotos',
        newValue: "invalid_fotos_list",
      );

      final result = GoNowListAdapter.fromMap(modifiedResponse);

      expect(result.isLeft, isTrue);
      expect(result.getLeftOrNull(), isA<FormatedException>());
    });

    test('should return failure when a room has an invalid period', () {
      final modifiedResponse = generateModifiedResponse(
        keyPath: 'data.moteis.0.suites.0.periodos.0.valor',
        newValue: "invalid_value",
      );

      final result = GoNowListAdapter.fromMap(modifiedResponse);

      expect(result.isLeft, isTrue);
      expect(result.getLeftOrNull(), isA<FormatedException>());
    });

    test('should return failure when "periodos" contain invalid discount data',
        () {
      final modifiedResponse = generateModifiedResponse(
        keyPath: 'data.moteis.0.suites.0.periodos.0.valor',
        newValue: 0.0,
      );

      final result = GoNowListAdapter.fromMap(modifiedResponse);

      expect(result.isLeft, isTrue);
      final exception = result.getLeftOrNull();
      expect(exception, isA<FormatedException>());
      expect(exception?.message, contains("Full Amount não é inválido"));
    });

    test('should return failure when a motel name is missing', () {
      final modifiedResponse = generateModifiedResponse(
        keyPath: 'data.moteis.0.fantasia',
        newValue: null,
      );

      final result = GoNowListAdapter.fromMap(modifiedResponse);

      expect(result.isLeft, isTrue);
      expect(result.getLeftOrNull(), isA<ValidationException>());
    });
  });
}
