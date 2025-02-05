/// The `Either` class represents a **functional way** to handle computations
/// that may either succeed (`Right`) or fail (`Left`).
///
/// This is useful in cases where exceptions should be **avoided** and errors
/// should be handled explicitly as values.
///
/// Inspired by functional programming languages like **Haskell** and **Scala**,
/// `Either<TLeft, TRight>` allows functions to return a **single, predictable type**.
///
/// Example Usage:
/// ```dart
/// Either<String, int> parseInt(String input) {
///   final parsed = int.tryParse(input);
///   return parsed == null ? left("Invalid number") : right(parsed);
/// }
///
/// void main() {
///   final result = parseInt("42");
///   result.fold(
///     (error) => print("Error: $error"),
///     (value) => print("Success: $value"),
///   );
/// }
/// ```
sealed class Either<TLeft, TRight> {
  /// Returns `true` if this is a `Left` (failure case).
  bool get isLeft;

  /// Returns `true` if this is a `Right` (success case).
  bool get isRight;

  /// Returns the value of `Right` if it exists, otherwise returns `null`.
  TRight? getOrNull() => fold((_) => null, (r) => r);

  /// Returns the value of `Left` if it exists, otherwise returns `null`.
  TLeft? getLeftOrNull() => fold((l) => l, (_) => null);

  /// Applies the given function depending on whether this is `Left` or `Right`.
  ///
  /// - If `this` is `Left`, it applies `leftFn(TLeft)`.
  /// - If `this` is `Right`, it applies `rightFn(TRight)`.
  T fold<T>(T Function(TLeft l) leftFn, T Function(TRight r) rightFn);

  /// Returns the `Right` value if present, otherwise computes the fallback function `orElse`.
  ///
  /// Example:
  /// ```dart
  /// final either = left<String, int>("Error");
  /// final result = either.getOrElse((error) => -1); // Returns -1
  /// ```
  TRight getOrElse(TRight Function(TLeft left) orElse) => fold(orElse, id);

  /// Chains computations, allowing transformation of the `Right` value.
  ///
  /// If `this` is `Left`, it propagates the failure without calling `fn`.
  /// Otherwise, applies `fn` to the `Right` value.
  Either<TLeft, T> bind<T>(Either<TLeft, T> Function(TRight r) fn) =>
      fold(left, fn);

  /// Similar to `bind`, but for **asynchronous** transformations.
  ///
  /// If `this` is `Left`, the failure is immediately returned.
  /// Otherwise, applies `fn` asynchronously to the `Right` value.
  Future<Either<TLeft, T>> asyncBind<T>(
          Future<Either<TLeft, T>> Function(TRight r) fn) =>
      fold((l) async => left(l), fn);

  /// Similar to `bind`, but applies the transformation on `Left`.
  Either<T, TRight> leftBind<T>(Either<T, TRight> Function(TLeft l) fn) =>
      fold(fn, right);

  /// Maps the `Right` value using `fn`, if present.
  ///
  /// - If `this` is `Left`, the failure propagates.
  /// - Otherwise, applies `fn(TRight)`.
  ///
  /// Example:
  /// ```dart
  /// final either = right<String, int>(10);
  /// final result = either.map((x) => x * 2); // Right(20)
  /// ```
  Either<TLeft, T> map<T>(T Function(TRight r) fn) =>
      fold(left, (r) => right(fn(r)));

  /// Maps the `Left` value using `fn`, if present.
  Either<T, TRight> leftMap<T>(T Function(TLeft l) fn) =>
      fold((l) => left(fn(l)), right);

  /// A more **readable alternative to `fold`**, providing named parameters for clarity.
  ///
  /// Example:
  /// ```dart
  /// final either = right<String, int>(42);
  /// final result = either.when(
  ///   left: (error) => "Error: $error",
  ///   right: (value) => "Success: $value",
  /// );
  /// print(result); // "Success: 42"
  /// ```
  T when<T>({
    required T Function(TLeft) left,
    required T Function(TRight) right,
  }) =>
      fold(left, right);
}

/// Represents the **failure case** of an `Either` value.
///
/// Holds a value of type `TLeft`, which usually represents an **error message or exception**.
final class _Left<TLeft, TRight> extends Either<TLeft, TRight> {
  final TLeft _value;

  @override
  final bool isLeft = true;
  @override
  final bool isRight = false;

  /// Creates a new `Left` instance with a given value.
  _Left(this._value);

  @override
  T fold<T>(T Function(TLeft l) leftFn, T Function(TRight r) rightFn) =>
      leftFn(_value);
}

/// Represents the **success case** of an `Either` value.
///
/// Holds a value of type `TRight`, which contains the **valid result**.
final class _Right<TLeft, TRight> extends Either<TLeft, TRight> {
  final TRight _value;

  @override
  final bool isLeft = false;
  @override
  final bool isRight = true;

  /// Creates a new `Right` instance with a given value.
  _Right(this._value);

  @override
  T fold<T>(T Function(TLeft l) leftFn, T Function(TRight r) rightFn) =>
      rightFn(_value);
}

/// Creates an `Either` value representing a **successful result**.
///
/// Example:
/// ```dart
/// final result = right<String, int>(42);
/// ```
Either<TLeft, TRight> right<TLeft, TRight>(TRight r) =>
    _Right<TLeft, TRight>(r);

/// Creates an `Either` value representing a **failure**.
///
/// Example:
/// ```dart
/// final result = left<String, int>("Error");
/// ```
Either<TLeft, TRight> left<TLeft, TRight>(TLeft l) => _Left<TLeft, TRight>(l);

/// Identity function that simply returns its argument.
///
/// This is useful for `fold` default values.
T id<T>(T value) => value;
