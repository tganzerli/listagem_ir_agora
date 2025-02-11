import 'package:flutter/foundation.dart';

/// Represents the base state for a ViewModel.
/// Extend this class to define specific states for your ViewModel.
abstract class ViewState {}

/// A generic base class for managing UI state in a Flutter application.
///
/// This class extends `ValueListenable<T>`, making it compatible with
/// Flutter's reactive UI system. It efficiently manages state updates
/// using `ValueNotifier<T>`, ensuring that only necessary changes trigger UI rebuilds.
///
/// ### Example Usage:
/// ```dart
/// class MyState extends ViewState {
///   final String message;
///   MyState(this.message);
/// }
///
/// class MyViewModel extends ViewModel<MyState> {
///   MyViewModel() : super(MyState("Initial State"));
///
///   void updateMessage(String newMessage) {
///     emit(MyState(newMessage));
///   }
/// }
/// ```
abstract class ViewModel<T extends ViewState> implements ValueListenable<T> {
  /// Internal notifier responsible for holding and updating the state.
  late final ValueNotifier<T> _stateNotifier;

  /// Tracks whether the ViewModel has been disposed.
  bool _isDisposed = false;

  /// Initializes the ViewModel with an initial state.
  ///
  /// - The [initialState] parameter sets the starting state.
  /// - Uses `ValueNotifier<T>` to manage state efficiently.
  ViewModel(T initialState) : _stateNotifier = ValueNotifier<T>(initialState);

  /// Returns the current state if the ViewModel is still active.
  ///
  /// - If the ViewModel is disposed, returns `null`.
  /// - This is useful for safely accessing state without errors.
  T? get safeState => _isDisposed ? null : _stateNotifier.value;

  /// Returns the current state.
  ///
  /// - Throws an error if accessed after disposal.
  /// - Use `safeState` instead if unsure whether the ViewModel is still active.
  T get state => _stateNotifier.value;

  /// Retrieves the current state value.
  ///
  /// This is required for implementing `ValueListenable<T>`,
  /// which allows external listeners (like UI widgets) to react to state changes.
  @override
  T get value => _stateNotifier.value;

  /// Adds a listener that is notified when the state changes.
  ///
  /// - The [listener] function is called whenever `emit()` or `emitAsync()` updates the state.
  /// - Useful for UI components that need to react to state changes.
  @override
  void addListener(VoidCallback listener) {
    _stateNotifier.addListener(listener);
  }

  /// Removes a previously added listener.
  ///
  /// - This should be called when the listener is no longer needed to avoid memory leaks.
  /// - Always pair every `addListener()` call with a `removeListener()` call.
  @override
  void removeListener(VoidCallback listener) {
    _stateNotifier.removeListener(listener);
  }

  /// Asynchronously updates the state.
  ///
  /// - If the ViewModel is disposed, the update is ignored.
  /// - If the new state is identical to the current state, no update occurs.
  /// - Uses `Future.delayed(Duration.zero)` to ensure asynchronous state transitions,
  ///   avoiding UI blocking or race conditions.
  ///
  /// ### Example:
  /// ```dart
  /// await emitAsync(MyState("New State"));
  /// ```
  @protected
  Future<void> emitAsync(T newState) async {
    if (_isDisposed || _stateNotifier.value == newState) return;

    await Future.delayed(Duration.zero);

    if (kDebugMode) {
      debugPrint(
          "ViewModel State Change: ${_stateNotifier.value} => $newState");
    }

    if (!_isDisposed) {
      _stateNotifier.value = newState;
    }
  }

  /// Synchronously updates the state.
  ///
  /// - Ensures the state is not changed after disposal.
  /// - Uses `Future.microtask` to allow non-blocking updates.
  /// - If the new state is identical to the current state, no update occurs.
  ///
  /// ### Example:
  /// ```dart
  /// emit(MyState("Updated State"));
  /// ```
  @protected
  void emit(T newState) {
    if (_isDisposed || _stateNotifier.value == newState) return;

    if (kDebugMode) {
      debugPrint(
          "ViewModel State Change: ${_stateNotifier.value} => $newState");
    }

    _stateNotifier.value = newState;
  }

  /// Safely disposes of the ViewModel by delaying the disposal process.
  ///
  /// - This method is useful when asynchronous operations may still reference the ViewModel.
  /// - Calls `dispose()` after a short delay to prevent premature disposal issues.
  ///
  /// ### Example:
  /// ```dart
  /// viewModel.disposeSafe();
  /// ```
  Future<void> disposeSafe() async {
    await Future.delayed(Duration.zero);
    dispose();
  }

  /// Disposes of the ViewModel and releases resources.
  ///
  /// - Ensures disposal happens only once to avoid errors.
  /// - Disposes of the internal `_stateNotifier` to free memory.
  /// - After disposal, any attempts to update state will be ignored.
  ///
  /// ### Example:
  /// ```dart
  /// viewModel.dispose();
  /// ```
  void dispose() {
    if (!_isDisposed) {
      _stateNotifier.dispose();
      _isDisposed = true;
    }
  }
}
