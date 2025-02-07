import 'package:flutter_test/flutter_test.dart';
import 'package:lista_ir_agora/core/core.dart';

void main() {
  group('AsyncOutput<T> - Success Cases', () {
    test('asyncOutputSuccess creates a successful AsyncOutput', () async {
      final asyncOutput = asyncOutputSuccess(42);
      final result = await asyncOutput;

      expect(result.isRight, isTrue,
          reason: 'Expected asyncOutputSuccess to return a Right value');
      expect(result.getOrNull(), equals(42),
          reason: 'Expected Right value to be 42');
    });

    test('map transforms Right value asynchronously', () async {
      final asyncOutput = asyncOutputSuccess(5);
      final mapped = asyncOutput.map((value) async => value * 2);
      final result = await mapped;

      expect(result.isRight, isTrue,
          reason: 'Expected mapped result to be Right');
      expect(result.getOrNull(), equals(10),
          reason: 'Expected transformed value to be 10');
    });

    test('bind chains async operations correctly', () async {
      final asyncOutput = asyncOutputSuccess(5);
      final chained =
          asyncOutput.bind((value) => asyncOutputSuccess(value * 3));
      final result = await chained;

      expect(result.isRight, isTrue,
          reason: 'Expected bind to return a Right value');
      expect(result.getOrNull(), equals(15),
          reason: 'Expected chained value to be 15');
    });

    test('fold applies the right function correctly', () async {
      final asyncOutput = asyncOutputSuccess("Hello");
      final result = await asyncOutput.fold(
        (error) => "Error: ${error.message}",
        (value) => "Success: $value",
      );

      expect(result, equals("Success: Hello"),
          reason: 'Expected fold to execute the Right function');
    });

    test('fromSync converts Output<T> to AsyncOutput<T>', () async {
      final syncOutput = success<int>(20);
      final asyncOutput = fromSync(syncOutput);
      final result = await asyncOutput;

      expect(result.isRight, isTrue,
          reason: 'Expected fromSync to return a successful AsyncOutput');
      expect(result.getOrNull(), equals(20),
          reason: 'Expected Right value to be 20');
    });
  });

  group('AsyncOutput<T> - Failure Cases', () {
    test('asyncOutputFailure creates a failed AsyncOutput', () async {
      final exception = DefaultException(message: "Async failure");
      final asyncOutput = asyncOutputFailure<int>(exception);
      final result = await asyncOutput;

      expect(result.isLeft, isTrue,
          reason: 'Expected asyncOutputFailure to return a Left value');
      expect(result.getLeftOrNull()?.message, equals("Async failure"),
          reason: 'Expected Left message to match the exception message');
    });

    test('map does not transform Left value', () async {
      int callCount = 0;
      final exception = DefaultException(message: "Mapping failed");
      final asyncOutput = asyncOutputFailure<int>(exception);

      // The mapping function should not be executed when the output is a failure.
      final mapped = asyncOutput.map((value) {
        callCount++;
        return value * 2;
      });
      final result = await mapped;

      expect(result.isLeft, isTrue,
          reason: 'Expected map to not modify a Left value');
      expect(callCount, equals(0),
          reason: 'Mapping function should not be called for a Left value');
      expect(result.getLeftOrNull()?.message, equals("Mapping failed"),
          reason: 'Expected Left message to remain unchanged');
    });

    test('bind propagates failure without executing the function', () async {
      int callCount = 0;
      final exception = DefaultException(message: "Bind failure");
      final asyncOutput = asyncOutputFailure<int>(exception);

      final chained = asyncOutput.bind((value) {
        callCount++;
        return asyncOutputSuccess(value * 3);
      });
      final result = await chained;

      expect(result.isLeft, isTrue,
          reason: 'Expected bind to propagate the failure');
      expect(callCount, equals(0),
          reason: 'Bind function should not be executed on failure');
      expect(result.getLeftOrNull()?.message, equals("Bind failure"),
          reason: 'Expected Left message to be unchanged');
    });

    test('fold applies the left function correctly', () async {
      final exception = DefaultException(message: "Something went wrong");
      final asyncOutput = asyncOutputFailure<String>(exception);
      final result = await asyncOutput.fold(
        (error) => "Error: ${error.message}",
        (value) => "Success: $value",
      );

      expect(result, equals("Error: Something went wrong"),
          reason: 'Expected fold to execute the Left function');
    });
  });

  group('AsyncOutput<T> - Mixed Cases', () {
    test('map works with delayed asynchronous operations', () async {
      final asyncOutput = asyncOutputSuccess(4);
      final mapped = asyncOutput.map((value) async {
        await Future.delayed(Duration(milliseconds: 100));
        return value * 5;
      });
      final result = await mapped;

      expect(result.isRight, isTrue,
          reason: 'Expected mapped result to be Right after delay');
      expect(result.getOrNull(), equals(20),
          reason: 'Expected transformed value to be 20');
    });

    test('bind correctly chains asynchronous transformations', () async {
      final asyncOutput = asyncOutputSuccess(3);
      final chained = asyncOutput
          .bind((value) => asyncOutputSuccess(value + 2))
          .bind((value) => asyncOutputSuccess(value * 4));
      final result = await chained;

      expect(result.isRight, isTrue,
          reason: 'Expected chained result to be Right');
      expect(result.getOrNull(), equals(20),
          reason: 'Expected chained computation result to be 20');
    });

    test('bind short-circuits on the first failure', () async {
      final asyncOutput = asyncOutputSuccess(2);
      final chained = asyncOutput
          .bind((value) => asyncOutputSuccess(value * 3))
          .bind((value) => asyncOutputFailure<int>(
              DefaultException(message: "Failed after second step")))
          .bind((value) => asyncOutputSuccess(value * 5)); // Should not execute

      final result = await chained;

      expect(result.isLeft, isTrue,
          reason: 'Expected bind to stop at the first failure');
      expect(
          result.getLeftOrNull()?.message, equals("Failed after second step"),
          reason: 'Expected first failure message to propagate');
    });
  });

  group('AsyncOutput<T> - mapError', () {
    test('mapError transforms an error correctly', () async {
      final exception = DefaultException(message: "Original Error");
      final transformedException = DefaultException(message: "Mapped Error");

      final asyncOutput = asyncOutputFailure<int>(exception);

      final mappedOutput = asyncOutput.mapError((error) async {
        expect(error.message, equals("Original Error"),
            reason: "Original error should be passed to mapError");
        return transformedException;
      });

      final result = await mappedOutput;

      expect(result.isLeft, isTrue, reason: "Expected a failure result");
      expect(result.getLeftOrNull()?.message, equals("Mapped Error"),
          reason: "Expected transformed error message");
    });

    test('mapError does not affect a success case', () async {
      final asyncOutput = asyncOutputSuccess<int>(42);

      final mappedOutput = asyncOutput.mapError((error) async {
        return DefaultException(message: "Should not be called");
      });

      final result = await mappedOutput;

      expect(result.isRight, isTrue, reason: "Expected success to remain");
      expect(result.getOrNull(), equals(42),
          reason: "Expected original success value to be retained");
    });
  });

  group('AsyncOutput<T> - getOrNull', () {
    test('getOrNull returns value when successful', () async {
      final asyncOutput = asyncOutputSuccess<int>(10);
      final result = await asyncOutput.getOrNull();

      expect(result, equals(10),
          reason: "Expected getOrNull to return the success value");
    });

    test('getOrNull returns null on failure', () async {
      final exception = DefaultException(message: "Failure occurred");
      final asyncOutput = asyncOutputFailure<int>(exception);
      final result = await asyncOutput.getOrNull();

      expect(result, isNull,
          reason: "Expected getOrNull to return null on failure");
    });
  });

  group('AsyncOutput<T> - getErrorOrNull', () {
    test('getErrorOrNull returns null when successful', () async {
      final asyncOutput = asyncOutputSuccess<int>(20);
      final result = await asyncOutput.getErrorOrNull();

      expect(result, isNull,
          reason: "Expected getErrorOrNull to return null on success");
    });

    test('getErrorOrNull returns error when failed', () async {
      final exception = DefaultException(message: "Test error");
      final asyncOutput = asyncOutputFailure<int>(exception);
      final result = await asyncOutput.getErrorOrNull();

      expect(result, equals(exception),
          reason: "Expected getErrorOrNull to return the actual error");
    });
  });

  group('AsyncOutput<T> - onFailure', () {
    test('onFailure executes action on failure', () async {
      final exception = DefaultException(message: "Failure case");
      final asyncOutput = asyncOutputFailure<int>(exception);

      bool actionExecuted = false;

      final handledOutput = asyncOutput.onFailure((error) {
        actionExecuted = true;
        expect(error.message, equals("Failure case"),
            reason: "Expected correct error to be passed to action");
      });

      await handledOutput;

      expect(actionExecuted, isTrue,
          reason: "Expected action to be executed on failure");
    });

    test('onFailure does not execute action on success', () async {
      final asyncOutput = asyncOutputSuccess<int>(50);

      bool actionExecuted = false;

      final handledOutput = asyncOutput.onFailure((error) {
        actionExecuted = true;
      });

      await handledOutput;

      expect(actionExecuted, isFalse,
          reason: "Expected action to not be executed on success");
    });

    test('onFailure returns the original failure', () async {
      final exception = DefaultException(message: "Original Failure");
      final asyncOutput = asyncOutputFailure<int>(exception);
      final handledOutput = asyncOutput.onFailure((_) {});

      final result = await handledOutput;

      expect(result.isLeft, isTrue, reason: "Expected failure to be retained");
      expect(result.getLeftOrNull(), equals(exception),
          reason: "Expected failure message to remain unchanged");
    });
  });

  group('AsyncOutput<T> - onSuccess', () {
    test('onSuccess executes action on success', () async {
      final asyncOutput = asyncOutputSuccess<int>(30);

      bool actionExecuted = false;

      final handledOutput = asyncOutput.onSuccess((value) {
        actionExecuted = true;
        expect(value, equals(30),
            reason: "Expected correct value to be passed to action");
      });

      await handledOutput;

      expect(actionExecuted, isTrue,
          reason: "Expected action to be executed on success");
    });

    test('onSuccess does not execute action on failure', () async {
      final exception = DefaultException(message: "Failure case");
      final asyncOutput = asyncOutputFailure<int>(exception);

      bool actionExecuted = false;

      final handledOutput = asyncOutput.onSuccess((value) {
        actionExecuted = true;
      });

      await handledOutput;

      expect(actionExecuted, isFalse,
          reason: "Expected action to not be executed on failure");
    });

    test('onSuccess returns the original success value', () async {
      final asyncOutput = asyncOutputSuccess<int>(88);
      final handledOutput = asyncOutput.onSuccess((_) {});

      final result = await handledOutput;

      expect(result.isRight, isTrue, reason: "Expected success to be retained");
      expect(result.getOrNull(), equals(88),
          reason: "Expected success value to remain unchanged");
    });
  });
}
