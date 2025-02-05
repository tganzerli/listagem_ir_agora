import 'package:flutter_test/flutter_test.dart';
import 'package:lista_ir_agora/core/core.dart';

void main() {
  group('Output<T> - Success Cases', () {
    test('success should create a Right instance', () {
      final output = success<int>(42);

      expect(output.isRight, isTrue, reason: "Expected success to be Right");
      expect(output.isLeft, isFalse, reason: "Expected success to not be Left");
      expect(output.getOrNull(), equals(42),
          reason: "Expected Right value to be 42");
      expect(output.getLeftOrNull(), isNull,
          reason: "Expected Left value to be null");
    });

    test('getOrElse should return actual value for success', () {
      final output = success<int>(100);

      final result = output.getOrElse((error) => -1);
      expect(result, equals(100),
          reason: "Expected getOrElse to return the original success value");
    });

    test('fold should return right value for success', () {
      final output = success<String>("Success!");

      final result = output.fold(
        (error) => "Error: ${error.message}",
        (value) => "Value: $value",
      );

      expect(result, equals("Value: Success!"),
          reason: "Expected fold to return the right-side function result");
    });

    test('map should transform Right value', () {
      final output = success<int>(5);
      final mapped = output.map((r) => r * 2);

      expect(mapped.isRight, isTrue,
          reason: "Expected mapped result to be Right");
      expect(mapped.getOrNull(), equals(10),
          reason: "Expected mapped value to be 10");
    });

    test('leftMap should not transform Right value', () {
      final output = success<int>(10);
      final mapped =
          output.leftMap((e) => DefaultException(message: "Should not change"));

      expect(mapped.isRight, isTrue,
          reason: "Expected leftMap not to affect Right value");
      expect(mapped.getOrNull(), equals(10),
          reason: "Expected Right value to remain unchanged");
    });

    test('when should execute right function for success', () {
      final output = success<int>(99);

      final result = output.when(
        left: (error) => "Error: ${error.message}",
        right: (value) => "Success: $value",
      );

      expect(result, equals("Success: 99"),
          reason: "Expected when to return success branch result");
    });
  });

  group('Output<T> - Failure Cases', () {
    test('failure should create a Left instance', () {
      final exception = DefaultException(message: "An error occurred");
      final output = failure<int>(exception);

      expect(output.isLeft, isTrue, reason: "Expected failure to be Left");
      expect(output.isRight, isFalse,
          reason: "Expected failure to not be Right");
      expect(output.getLeftOrNull(), equals(exception),
          reason: "Expected Left value to match exception");
      expect(output.getOrNull(), isNull,
          reason: "Expected Right value to be null");
    });

    test('getOrElse should return default value for failure', () {
      final output = failure<int>(DefaultException(message: "Failure"));

      final result = output.getOrElse((error) => -1);
      expect(result, equals(-1),
          reason: "Expected getOrElse to return fallback value on failure");
    });

    test('fold should return left function result for failure', () {
      final exception = DefaultException(message: "Something went wrong");
      final output = failure<String>(exception);

      final result = output.fold(
        (error) => "Error: ${error.message}",
        (value) => "Value: $value",
      );

      expect(result, equals("Error: Something went wrong"),
          reason: "Expected fold to return left-side function result");
    });

    test('map should not transform Left value', () {
      final output = failure<int>(DefaultException(message: "Mapping failed"));
      final mapped = output.map((r) => r * 2);

      expect(mapped.isLeft, isTrue,
          reason: "Expected map not to affect Left value");
      expect(mapped.getLeftOrNull()?.message, equals("Mapping failed"),
          reason: "Expected Left value to remain unchanged");
    });

    test('leftMap should transform Left value', () {
      final output = failure<int>(DefaultException(message: "Original Error"));
      final mapped = output
          .leftMap((e) => DefaultException(message: "Modified: ${e.message}"));

      expect(mapped.isLeft, isTrue,
          reason: "Expected leftMap to modify Left value");
      expect(
          mapped.getLeftOrNull()?.message, equals("Modified: Original Error"),
          reason: "Expected modified Left message");
    });

    test('when should execute left function for failure', () {
      final exception = DefaultException(message: "Critical Failure");
      final output = failure<int>(exception);

      final result = output.when(
        left: (error) => "Error: ${error.message}",
        right: (value) => "Success: $value",
      );

      expect(result, equals("Error: Critical Failure"),
          reason: "Expected when to return failure branch result");
    });
  });
}
