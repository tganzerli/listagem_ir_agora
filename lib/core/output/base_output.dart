import 'package:lista_ir_agora/core/core.dart';

/// `Output<T>` is a specialized type alias for handling **success or failure**
/// results in a functional way.
///
/// It is based on `Either<BaseException, T>`, where:
/// - **`Left<BaseException>`** represents an error.
/// - **`Right<T>`** represents a successful result.
///
/// This abstraction eliminates the need for **try-catch blocks** and enforces
/// **explicit error handling**, making functions more predictable and safer.
///
/// Example:
/// ```dart
/// Output<int> divide(int a, int b) {
///   if (b == 0) {
///     return failure(BaseException("Division by zero"));
///   }
///   return success(a ~/ b);
/// }
///
/// void main() {
///   final result = divide(10, 2);
///   result.fold(
///     (error) => print("Error: ${error.message}"),
///     (value) => print("Result: $value"),
///   );
/// }
/// ```
typedef Output<T> = Either<BaseException, T>;

/// Creates a **successful `Output<T>`**.
///
/// This function wraps a given value inside a `Right<BaseException, T>`,
/// indicating that the operation **was successful**.
///
/// Example:
/// ```dart
/// final result = success<int>(42);
/// print(result); // Right(42)
/// ```
Output<T> success<T>(T value) => right<BaseException, T>(value);

/// Creates a **failed `Output<T>`**.
///
/// This function wraps an error (`BaseException`) inside a `Left<BaseException, T>`,
/// indicating that the operation **failed**.
///
/// Example:
/// ```dart
/// final result = failure<int>(BaseException("An error occurred"));
/// print(result); // Left(BaseException: An error occurred)
/// ```
Output<T> failure<T>(BaseException exception) =>
    left<BaseException, T>(exception);
