import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:lista_ir_agora/core/core.dart';

void main() {
  group('Command0 Tests', () {
    test('Executes successfully and returns the correct result', () async {
      final command = Command0<int>(() async => right(42));

      await command.execute();

      expect(command.rightResult, 42);
      expect(command.isSuccess, true);
      expect(command.isException, false);
    });

    test('Executes and correctly captures an exception', () async {
      final command = Command0<int>(() async {
        return left(DefaultException(message: 'Error'));
      });

      await command.execute();

      expect(command.rightResult, isNull);
      expect(command.leftResult, isA<DefaultException>());
      expect(command.isException, true);
      expect(command.isSuccess, false);
    });
  });

  group('Command1 Tests', () {
    test('Executes successfully with a parameter', () async {
      final command = Command1<String, int>((value) async {
        return right('Number: $value');
      });

      await command.execute(5);

      expect(command.rightResult, 'Number: 5');
      expect(command.param, 5);
    });

    test('Executes and correctly captures an exception', () async {
      final command = Command1<String, int>((value) async {
        return left(DefaultException(message: 'Error in parameter $value'));
      });

      await command.execute(10);

      expect(command.rightResult, isNull);
      expect(command.leftResult, isA<DefaultException>());
    });
  });

  group('Command2 Tests', () {
    test('Executes successfully with two parameters', () async {
      final command = Command2<bool, int, int>((a, b) async {
        return right(a + b > 10);
      });

      await command.execute(5, 6);

      expect(command.rightResult, true);
      expect(command.param1, 5);
      expect(command.param2, 6);
    });

    test('Executes and correctly captures an exception', () async {
      final command = Command2<bool, int, int>((a, b) async {
        return left(DefaultException(message: 'Unexpected error'));
      });

      await command.execute(3, 4);

      expect(command.rightResult, isNull);
      expect(command.leftResult, isA<DefaultException>());
    });
  });

  group('Command States', () {
    test('Checks isExecuting', () async {
      final completer = Completer<Either<BaseException, int>>();
      final command = Command0<int>(() async => completer.future);

      expect(command.isExecuting, false);

      final future = command.execute();

      expect(command.isExecuting, true);

      completer.complete(right(10));
      await future;

      expect(command.isExecuting, false);
      expect(command.rightResult, 10);
    });

    test('Checks the clean() method', () async {
      final command = Command0<int>(() async => right(100));

      await command.execute();
      expect(command.rightResult, 100);

      command.clean();

      expect(command.result, isNull);
    });
  });
}
