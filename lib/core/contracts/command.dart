import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:lista_ir_agora/core/core.dart';

/// Base class for asynchronous command execution.
///
/// This class provides a structured way to execute asynchronous operations
/// while managing execution state, handling exceptions, and notifying listeners.
/// It ensures that actions cannot be executed concurrently and encapsulates
/// results using `Output<T>`, avoiding unnecessary `try-catch` blocks.
///
/// The result is stored as an `Output<T>`, where:
/// - `Right<T>` represents a successful result.
/// - `Left<BaseException>` represents an error.
///
/// Example usage:
/// ```dart
/// final command = Command0<int>(() async {
///   return Output.right(42);
/// });
///
/// await command.execute();
/// print(command.rightResult); // 42
/// ```
abstract class Command<BaseException, T> extends ValueNotifier<Output<T>?> {
  /// Initializes the command with a nullable result state.
  Command() : super(null);

  /// Indicates whether the command is currently executing.
  bool _isExecuting = false;

  /// A [Completer] that allows waiting for the current execution to finish.
  final Completer<void> _completer = Completer<void>();

  /// Returns whether the command is currently executing.
  bool get isExecuting => _isExecuting;

  /// Gets the execution result as an `Output<T>`.
  Output<T>? get result => value;

  /// Retrieves the successful result (`Right<T>`) if available.
  T? get rightResult => result?.getOrNull();

  /// Retrieves the failure result (`Left<BaseException>`) if available.
  BaseException? get leftResult => result?.getLeftOrNull() as BaseException?;

  /// Checks whether the execution resulted in an exception.
  bool get isException => result?.isLeft ?? false;

  /// Checks whether the execution was successful.
  bool get isSuccess => result?.isRight ?? false;

  /// Clears the command's result, resetting its state.
  void clean() => value = null;

  /// Executes the given asynchronous action in a controlled manner.
  ///
  /// This method prevents multiple executions at the same time, ensuring that
  /// the command state is properly managed.
  ///
  /// - Calls the provided asynchronous function.
  /// - Catches unexpected errors and logs them.
  /// - Notifies listeners about state changes.
  Future<void> _execute(AsyncOutput<T> Function() action) async {
    if (_isExecuting) return;

    _isExecuting = true;
    value = null;

    try {
      value = await action();
    } catch (e, stackTrace) {
      debugPrint("Unexpected error during command execution: $e\n$stackTrace");
    } finally {
      _isExecuting = false;
      _completer.complete();
    }
  }

  /// Waits for the current execution to complete before proceeding.
  Future<void> waitForCompletion() async {
    if (_isExecuting) {
      await _completer.future;
    }
  }
}

/// A command that executes an asynchronous function with no parameters.
///
/// This class is used when an operation does not require input parameters.
/// It ensures that execution is managed properly and encapsulates results
/// using `Output<T>`.
///
/// Example usage:
/// ```dart
/// final command = Command0<int>(() async {
///   return Output.right(42);
/// });
///
/// await command.execute();
/// print(command.rightResult); // 42
/// ```
class Command0<T> extends Command<BaseException, T> {
  /// The asynchronous function to execute.
  final AsyncOutput<T> Function() _action;

  /// Initializes the command with an action.
  Command0(this._action);

  /// Executes the command.
  Future<void> execute() => _execute(_action);
}

/// A command that executes an asynchronous function with one parameter.
///
/// This class is useful when an operation depends on a single input parameter.
/// It ensures correct execution management while storing the latest parameter.
///
/// Example usage:
/// ```dart
/// final command = Command1<String, int>((value) async {
///   return Output.right("Number: $value");
/// });
///
/// await command.execute(5);
/// print(command.rightResult); // "Number: 5"
/// ```
class Command1<T, TParam1> extends Command<BaseException, T> {
  /// The asynchronous function that takes one parameter.
  final AsyncOutput<T> Function(TParam1) _action;

  /// Stores the most recent parameter used in execution.
  late TParam1 _param1;

  /// Initializes the command with an action.
  Command1(this._action);

  /// Executes the command with the given parameter.
  Future<void> execute(TParam1 param1) async {
    _param1 = param1;
    await _execute(() => _action(param1));
  }

  /// Returns the most recent parameter used in execution.
  TParam1 get param => _param1;
}

/// A command that executes an asynchronous function with two parameters.
///
/// This class is useful when an operation requires two input parameters.
/// It ensures correct execution management while storing the latest parameters.
///
/// Example usage:
/// ```dart
/// final command = Command2<bool, int, int>((a, b) async {
///   return Output.right(a + b > 10);
/// });
///
/// await command.execute(5, 10);
/// print(command.rightResult); // true
/// ```
class Command2<T, TParam1, TParam2> extends Command<BaseException, T> {
  /// The asynchronous function that takes two parameters.
  final AsyncOutput<T> Function(TParam1, TParam2) _action;

  /// Stores the most recent first parameter used in execution.
  late TParam1 _param1;

  /// Stores the most recent second parameter used in execution.
  late TParam2 _param2;

  /// Initializes the command with an action.
  Command2(this._action);

  /// Executes the command with the given parameters.
  Future<void> execute(TParam1 param1, TParam2 param2) async {
    _param1 = param1;
    _param2 = param2;
    await _execute(() => _action(param1, param2));
  }

  /// Returns the most recent first parameter used in execution.
  TParam1 get param1 => _param1;

  /// Returns the most recent second parameter used in execution.
  TParam2 get param2 => _param2;
}
