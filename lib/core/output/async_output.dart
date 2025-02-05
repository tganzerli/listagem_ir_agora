import 'dart:async';
import 'package:lista_ir_agora/core/core.dart';

/// `AsyncOutput<T>` is a **wrapper for asynchronous operations** that return
/// an `Output<T>` (i.e., an `Either<BaseException, T>` inside a `Future`).
///
/// It provides a **functional approach** for handling asynchronous computations
/// that may succeed (`Right`) or fail (`Left<BaseException>`).
///
/// Using `AsyncOutput<T>` avoids direct `try-catch` handling in async functions
/// and ensures explicit error management.
///
/// ### **Example Usage**
/// ```dart
/// Future<AsyncOutput<String>> fetchData() async {
///   try {
///     await Future.delayed(Duration(seconds: 1));
///     return AsyncOutput.success("Data fetched successfully!");
///   } catch (e) {
///     return AsyncOutput.failure(BaseException("Failed to fetch data"));
///   }
/// }
///
/// void main() async {
///   AsyncOutput<String> result = await fetchData();
///
///   result
///       .map((data) => "Processed: $data")
///       .bind((data) => AsyncOutput.success("$data 🎉"))
///       .fold(
///         (error) => print("Error: ${error.message}"),
///         (value) => print("Success: $value"),
///       );
/// }
/// ```
class AsyncOutput<T> {
  /// A `Future` that resolves to an `Output<T>`, encapsulating an asynchronous computation.
  final Future<Output<T>> _future;

  /// Creates an `AsyncOutput` from a `Future<Output<T>>`.
  AsyncOutput(this._future);

  /// Creates a **successful `AsyncOutput<T>`** from a given value.
  ///
  /// The value is wrapped inside a `Right<BaseException, T>` and returned as a future.
  ///
  /// ### **Example**
  /// ```dart
  /// final result = AsyncOutput.success("Hello");
  /// ```
  factory AsyncOutput.success(T value) =>
      AsyncOutput(Future.value(success(value)));

  /// Creates a **failed `AsyncOutput<T>`** from an exception.
  ///
  /// The `BaseException` is wrapped inside a `Left<BaseException, T>` and returned as a future.
  ///
  /// ### **Example**
  /// ```dart
  /// final result = AsyncOutput.failure(BaseException("An error occurred"));
  /// ```
  factory AsyncOutput.failure(BaseException error) =>
      AsyncOutput(Future.value(failure(error)));

  /// Transforms `Left` or `Right` into a **new synchronous value** using asynchronous functions.
  ///
  /// - If `this` is `Left`, `leftFn` is executed.
  /// - If `this` is `Right`, `rightFn` is executed.
  ///
  /// ### **Example**
  /// ```dart
  /// final result = await asyncOutput.fold(
  ///   (error) => "Failed: ${error.message}",
  ///   (value) => "Success: $value",
  /// );
  /// ```
  Future<R> fold<R>(
    FutureOr<R> Function(BaseException error) leftFn,
    FutureOr<R> Function(T value) rightFn,
  ) async {
    final result = await _future;
    return result.fold(leftFn, rightFn);
  }

  /// **Transforms the `Right` value asynchronously using `fn`.**
  ///
  /// - If `this` is `Left`, the failure is propagated.
  /// - Otherwise, `fn` is applied to the `Right` value asynchronously.
  ///
  /// ### **Example**
  /// ```dart
  /// final transformed = asyncOutput.map((value) async => "$value transformed");
  /// ```
  AsyncOutput<R> map<R>(FutureOr<R> Function(T value) fn) {
    return AsyncOutput(
      _future.then(
        (either) => either.fold(
          (error) => failure(error),
          (value) async => success(await fn(value)),
        ),
      ),
    );
  }

  /// **Chains a new async operation (`bind` style).**
  ///
  /// - If `this` is `Left`, the failure propagates.
  /// - Otherwise, `fn` is applied to `Right`, returning a new `AsyncOutput<R>`.
  ///
  /// ### **Example**
  /// ```dart
  /// AsyncOutput<String> fetchAndProcessData() {
  ///   return fetchData().bind((data) => AsyncOutput.success("Processed: $data"));
  /// }
  /// ```
  AsyncOutput<R> bind<R>(AsyncOutput<R> Function(T value) fn) {
    return AsyncOutput(
      _future.then(
        (either) => either.fold(
          (error) => Future.value(failure(error)),
          (value) => fn(value)._future,
        ),
      ),
    );
  }

  /// Converts a **synchronous `Output<T>`** into an **asynchronous `AsyncOutput<T>`**.
  ///
  /// ### **Example**
  /// ```dart
  /// final asyncOutput = AsyncOutput.fromSync(success(42));
  /// ```
  static AsyncOutput<T> fromSync<T>(Output<T> output) =>
      AsyncOutput(Future.value(output));

  /// **Executes the computation and returns an `Output<T>` asynchronously.**
  ///
  /// Use this method when you need to await the final result.
  ///
  /// ### **Example**
  /// ```dart
  /// Output<String> result = await asyncOutput.execute();
  /// ```
  Future<Output<T>> execute() => _future;
}
