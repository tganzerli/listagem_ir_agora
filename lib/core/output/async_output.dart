import 'dart:async';
import 'package:lista_ir_agora/core/core.dart';

/// `Output<T>` is defined in your core library as:
/// `typedef Output<T> = Either<BaseException, T>`;
///
/// This file defines `AsyncOutput<T>` as an alias for `Future<Output<T>>`
/// and provides helper functions and extension methods for a rich API.
///
/// It provides a **functional approach** for handling asynchronous computations
/// that may succeed (`Right`) or fail (`Left<BaseException>`).
///
/// Using `AsyncOutput<T>` avoids direct `try-catch` handling in async functions
/// and ensures explicit error management.
///
/// ### **Example Usage**
/// ```dart
/// AsyncOutput<String> fetchData() async {
///   try {
///     await Future.delayed(Duration(seconds: 1));
///     return success("Data fetched successfully!");
///   } catch (e) {
///     return failure(BaseException("Failed to fetch data"));
///   }
/// }
///
/// void main() async {
///   AsyncOutput<String> result = await fetchData();
///
///   result
///       .map((data) => "Processed: $data")
///       .bind((data) => AsyncOutput.success("$data"))
///       .fold(
///         (error) => print("Error: ${error.message}"),
///         (value) => print("Success: $value"),
///       );
/// }
/// ```
typedef AsyncOutput<T> = Future<Output<T>>;

/// Creates a successful AsyncOutput by wrapping the value into a Right.
AsyncOutput<T> asyncOutputSuccess<T>(T value) => Future.value(success(value));

/// Creates a failed AsyncOutput by wrapping the exception into a Left.
AsyncOutput<T> asyncOutputFailure<T>(BaseException error) =>
    Future.value(failure<T>(error));

/// Converts a synchronous `Output<T>` into an `AsyncOutput<T>`.
AsyncOutput<T> fromSync<T>(Output<T> output) => Future.value(output);

extension AsyncOutputExtension<T> on AsyncOutput<T> {
  /// Transforms the success value using the function [f].
  AsyncOutput<R> map<R>(FutureOr<R> Function(T value) f) {
    return then((output) => output.fold(
          (error) => failure<R>(error),
          (value) async => success(await f(value)),
        ));
  }

  /// Chains an asynchronous operation that returns an `Output<R>`.
  AsyncOutput<R> flatMap<R>(FutureOr<Output<R>> Function(T value) f) {
    return then((output) => output.fold(
          (error) => failure<R>(error),
          (value) => f(value),
        ));
  }

  /// Alias for [flatMap].
  AsyncOutput<R> bind<R>(FutureOr<Output<R>> Function(T value) f) => flatMap(f);

  /// Transforms the error value using the function [f].
  AsyncOutput<T> mapError(
      FutureOr<BaseException> Function(BaseException error) f) {
    return then((output) => output.fold(
          (error) async => failure<T>(await f(error)),
          (value) => success(value),
        ));
  }

  /// Unwraps the AsyncOutput by applying [ifError] or [ifSuccess].
  Future<R> fold<R>(FutureOr<R> Function(BaseException error) ifError,
      FutureOr<R> Function(T value) ifSuccess) {
    return then((output) => output.fold(ifError, ifSuccess));
  }

  /// Returns the success value or null if it is a failure.
  Future<T?> getOrNull() {
    return then((output) => output.fold((_) => null, (value) => value));
  }

  /// Returns the error (BaseException) or null if it is a success.
  Future<BaseException?> getErrorOrNull() {
    return then((output) => output.fold((error) => error, (_) => null));
  }

  /// Executes [action] if the AsyncOutput represents a failure.
  AsyncOutput<T> onFailure(void Function(BaseException error) action) {
    return then((output) {
      return output.fold(
        (error) {
          action(error);
          return failure<T>(error);
        },
        (value) => success(value),
      );
    });
  }

  /// Executes [action] if the AsyncOutput represents a success.
  AsyncOutput<T> onSuccess(void Function(T value) action) {
    return then((output) {
      return output.fold(
        (error) => failure<T>(error),
        (value) {
          action(value);
          return success(value);
        },
      );
    });
  }
}
