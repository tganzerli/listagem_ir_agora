/// The `Unit` class represents a placeholder type that signifies the absence
/// of meaningful return data.
///
/// In Dart, `void` is typically used for functions that do not return a value.
/// However, `void` cannot be assigned to a variable or passed around as a value.
/// `Unit` solves this by providing a concrete, **singleton instance** that can
/// be used wherever a return type is required but does not need to hold data.
///
/// Inspired by functional programming languages like Scala and Kotlin, `Unit`
/// ensures **consistency** and **avoids null values** in operations.
///
/// Example Usage:
/// ```dart
/// Unit logMessage(String message) {
///   print(message);
///   return unit;
/// }
/// ```
abstract class Unit {}

/// The `_Unit` class is a private implementation of `Unit`, ensuring that
/// only a **single instance** exists.
///
/// This follows the **singleton pattern**, preventing unnecessary instantiations
/// of `Unit` and ensuring that all references point to the same instance.
class _Unit implements Unit {
  /// Private constructor to prevent external instantiation.
  const _Unit();
}

/// A **constant singleton instance** of `_Unit`, used globally.
///
/// Instead of returning `null` or `void`, use `unit` for operations
/// that do not require a meaningful return value.
///
/// Example Usage:
/// ```dart
/// Output<Unit> saveData(String data) {
///   if (data.isEmpty) {
///     return failure(BaseException("Cannot save empty data"));
///   }
///   return success(unit);
/// }
/// ```
const unit = _Unit();
