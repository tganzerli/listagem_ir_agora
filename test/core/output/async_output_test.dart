import 'package:flutter_test/flutter_test.dart';
import 'package:lista_ir_agora/core/core.dart';

void main() {
  group('AsyncOutput<T> - Success Cases', () {
    test('AsyncOutput.success should create a successful AsyncOutput',
        () async {
      final asyncOutput = AsyncOutput.success(42);
      final result = await asyncOutput.execute();

      expect(result.isRight, isTrue,
          reason: "Expected AsyncOutput.success to return Right");
      expect(result.getOrNull(), equals(42),
          reason: "Expected Right value to be 42");
    });

    test('map should transform Right value asynchronously', () async {
      final asyncOutput = AsyncOutput.success(5);
      final mapped = asyncOutput.map((value) async => value * 2);

      final result = await mapped.execute();

      expect(result.isRight, isTrue,
          reason: "Expected mapped result to be Right");
      expect(result.getOrNull(), equals(10),
          reason: "Expected transformed value to be 10");
    });

    test('bind should chain async operations correctly', () async {
      final asyncOutput = AsyncOutput.success(5);
      final chained =
          asyncOutput.bind((value) => AsyncOutput.success(value * 3));

      final result = await chained.execute();

      expect(result.isRight, isTrue,
          reason: "Expected bind to return Right value");
      expect(result.getOrNull(), equals(15),
          reason: "Expected chained value to be 15");
    });

    test('fold should correctly apply the right function', () async {
      final asyncOutput = AsyncOutput.success("Hello");

      final result = await asyncOutput.fold(
        (error) => "Error: ${error.message}",
        (value) => "Success: $value",
      );

      expect(result, equals("Success: Hello"),
          reason: "Expected fold to execute Right function");
    });

    test('fromSync should convert Output<T> into AsyncOutput<T>', () async {
      final syncOutput = success<int>(20);
      final asyncOutput = AsyncOutput.fromSync(syncOutput);

      final result = await asyncOutput.execute();

      expect(result.isRight, isTrue,
          reason: "Expected fromSync to return a successful AsyncOutput");
      expect(result.getOrNull(), equals(20),
          reason: "Expected Right value to be 20");
    });
  });

  group('AsyncOutput<T> - Failure Cases', () {
    test('AsyncOutput.failure should create a failed AsyncOutput', () async {
      final exception = DefaultException(message: "Async failure");
      final asyncOutput = AsyncOutput.failure(exception);
      final result = await asyncOutput.execute();

      expect(result.isLeft, isTrue,
          reason: "Expected AsyncOutput.failure to return Left");
      expect(result.getLeftOrNull()?.message, equals("Async failure"),
          reason: "Expected Left value to match exception message");
    });

    test('map should not transform Left value', () async {
      final exception = DefaultException(message: "Mapping failed");
      final asyncOutput = AsyncOutput.failure(exception);
      final mapped = asyncOutput.map((value) async => value * 2);

      final result = await mapped.execute();

      expect(result.isLeft, isTrue,
          reason: "Expected map to not modify Left value");
      expect(result.getLeftOrNull()?.message, equals("Mapping failed"),
          reason: "Expected Left message to remain unchanged");
    });

    test('bind should propagate failure without executing function', () async {
      final exception = DefaultException(message: "Bind failure");
      final asyncOutput = AsyncOutput.failure(exception);
      final chained =
          asyncOutput.bind((value) => AsyncOutput.success(value * 3));

      final result = await chained.execute();

      expect(result.isLeft, isTrue,
          reason: "Expected bind to propagate failure");
      expect(result.getLeftOrNull()?.message, equals("Bind failure"),
          reason: "Expected Left message to be unchanged");
    });

    test('fold should correctly apply the left function', () async {
      final exception = DefaultException(message: "Something went wrong");
      final asyncOutput = AsyncOutput.failure(exception);

      final result = await asyncOutput.fold(
        (error) => "Error: ${error.message}",
        (value) => "Success: $value",
      );

      expect(result, equals("Error: Something went wrong"),
          reason: "Expected fold to execute Left function");
    });
  });

  group('AsyncOutput<T> - Mixed Cases', () {
    test('map should work with delayed asynchronous operations', () async {
      final asyncOutput = AsyncOutput.success(4);
      final mapped = asyncOutput.map((value) async {
        await Future.delayed(Duration(milliseconds: 100));
        return value * 5;
      });

      final result = await mapped.execute();

      expect(result.isRight, isTrue,
          reason: "Expected mapped result to be Right after delay");
      expect(result.getOrNull(), equals(20),
          reason: "Expected transformed value to be 20");
    });

    test('bind should correctly chain async transformations', () async {
      final asyncOutput = AsyncOutput.success(3);
      final chained = asyncOutput
          .bind((value) => AsyncOutput.success(value + 2))
          .bind((value) => AsyncOutput.success(value * 4));

      final result = await chained.execute();

      expect(result.isRight, isTrue,
          reason: "Expected chained result to be Right");
      expect(result.getOrNull(), equals(20),
          reason: "Expected chained computation result to be 20");
    });

    test('bind should short-circuit on first failure', () async {
      final asyncOutput = AsyncOutput.success(2);
      final chained = asyncOutput
          .bind((value) => AsyncOutput.success(value * 3))
          .bind((value) => AsyncOutput.failure(
              DefaultException(message: "Failed after second step")))
          .bind(
              (value) => AsyncOutput.success(value * 5)); // Should not execute

      final result = await chained.execute();

      expect(result.isLeft, isTrue,
          reason: "Expected bind to stop at first failure");
      expect(
          result.getLeftOrNull()?.message, equals("Failed after second step"),
          reason: "Expected first failure message to propagate");
    });
  });
}
