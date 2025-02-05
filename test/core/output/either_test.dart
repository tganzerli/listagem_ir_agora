import 'package:flutter_test/flutter_test.dart';
import 'package:lista_ir_agora/core/output/output.dart';

void main() {
  group('Either - Basic Properties', () {
    test('Left should hold a value and be recognized as Left', () {
      final either = left<String, int>("Error");

      expect(either.isLeft, isTrue, reason: "Expected Left instance");
      expect(either.isRight, isFalse, reason: "Expected isRight to be false");
      expect(either.getLeftOrNull(), equals("Error"),
          reason: "Expected stored Left value");
      expect(either.getOrNull(), isNull,
          reason: "Expected Right value to be null");
    });

    test('Right should hold a value and be recognized as Right', () {
      final either = right<String, int>(42);

      expect(either.isLeft, isFalse, reason: "Expected isLeft to be false");
      expect(either.isRight, isTrue, reason: "Expected Right instance");
      expect(either.getOrNull(), equals(42),
          reason: "Expected stored Right value");
      expect(either.getLeftOrNull(), isNull,
          reason: "Expected Left value to be null");
    });
  });

  group('Either - Core Functionalities', () {
    test('fold should correctly apply left and right functions', () {
      final leftEither = left<String, int>("Error");
      final rightEither = right<String, int>(42);

      expect(leftEither.fold((l) => "Failure: $l", (r) => "Success: $r"),
          equals("Failure: Error"),
          reason: "Expected Left branch function");
      expect(rightEither.fold((l) => "Failure: $l", (r) => "Success: $r"),
          equals("Success: 42"),
          reason: "Expected Right branch function");
    });

    test('getOrElse should return default value for Left', () {
      final either = left<String, int>("Error");

      final result = either.getOrElse((l) => -1);
      expect(result, equals(-1), reason: "Expected fallback value for Left");
    });

    test('getOrElse should return actual value for Right', () {
      final either = right<String, int>(100);

      final result = either.getOrElse((l) => -1);
      expect(result, equals(100),
          reason: "Expected Right value to be returned");
    });

    test('when should correctly handle Left and Right', () {
      final rightEither = right<String, int>(42);
      final leftEither = left<String, int>("Some error");

      expect(
        rightEither.when(
          left: (error) => "Failure: $error",
          right: (value) => "Success: $value",
        ),
        equals("Success: 42"),
        reason: "Expected Right branch execution",
      );

      expect(
        leftEither.when(
          left: (error) => "Failure: $error",
          right: (value) => "Success: $value",
        ),
        equals("Failure: Some error"),
        reason: "Expected Left branch execution",
      );
    });
  });

  group('Either - Transformations', () {
    test('bind should propagate Right transformation', () {
      final either = right<String, int>(10);
      final bound = either.bind((r) => right<String, double>(r * 2.5));

      expect(bound.isRight, isTrue, reason: "Expected Right after bind");
      expect(bound.getOrNull(), equals(25.0),
          reason: "Expected transformed value");
    });

    test('bind should not apply function on Left', () {
      final either = left<String, int>("Error");
      final bound = either.bind((r) => right<String, double>(r * 2.5));

      expect(bound.isLeft, isTrue, reason: "Expected Left to remain unchanged");
      expect(bound.getLeftOrNull(), equals("Error"),
          reason: "Expected original Left value");
    });

    test('map should transform Right value', () {
      final either = right<String, int>(5);
      final mapped = either.map((r) => r * 2);

      expect(mapped.isRight, isTrue, reason: "Expected Right after map");
      expect(mapped.getOrNull(), equals(10),
          reason: "Expected transformed value");
    });

    test('leftMap should transform Left value', () {
      final either = left<String, int>("Error");
      final mapped = either.leftMap((l) => "Mapped $l");

      expect(mapped.isLeft, isTrue, reason: "Expected Left after leftMap");
      expect(mapped.getLeftOrNull(), equals("Mapped Error"),
          reason: "Expected transformed Left value");
    });

    test('leftBind should transform Left value while preserving type', () {
      final either = left<String, int>("Error");
      final bound = either.leftBind((l) => left<int, int>(l.length));

      expect(bound.isLeft, isTrue, reason: "Expected Left after leftBind");
      expect(bound.getLeftOrNull(), equals(5),
          reason: "Expected transformed Left value");
    });

    test('leftBind should not modify Right value', () {
      final either = right<String, int>(10);
      final bound = either.leftBind((l) => left<int, int>(l.length));

      expect(bound.isRight, isTrue,
          reason: "Expected Right to remain unchanged");
      expect(bound.getOrNull(), equals(10),
          reason: "Expected original Right value");
    });
  });

  group('Either - Async Transformations', () {
    test('asyncBind should propagate Right asynchronously', () async {
      final either = right<String, int>(10);
      final bound =
          await either.asyncBind((r) async => right<String, double>(r * 2.5));

      expect(bound.isRight, isTrue, reason: "Expected Right after asyncBind");
      expect(bound.getOrNull(), equals(25.0),
          reason: "Expected transformed async value");
    });

    test('asyncBind should propagate Left without executing function',
        () async {
      final either = left<String, int>("Error");
      final bound =
          await either.asyncBind((r) async => right<String, double>(r * 2.5));

      expect(bound.isLeft, isTrue,
          reason: "Expected Left to remain unchanged in asyncBind");
      expect(bound.getLeftOrNull(), equals("Error"),
          reason: "Expected original Left value");
    });
  });
}
