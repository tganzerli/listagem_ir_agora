import 'package:flutter/foundation.dart';

/// Represents the base state for a ViewModel.
/// Extend this class to define specific states for your ViewModel.
abstract class ViewState {}

/// A generic base class for managing UI state in a Flutter application.
///
/// This class extends `ChangeNotifier`, making it compatible with Flutter's
/// provider-based state management.
///
/// It uses `ValueNotifier<T>` to efficiently notify listeners of state changes.
///
/// Example Usage:
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
abstract class ViewModel<T extends ViewState> extends ChangeNotifier {
  /// Internal state notifier for managing and notifying state changes.
  final ValueNotifier<T> _stateNotifier;

  /// Tracks whether this ViewModel has been disposed.
  bool _isDisposed = false;

  /// Initializes the ViewModel with an initial state.
  ///
  /// The [initialState] parameter is required to define the starting state.
  ViewModel(T initialState) : _stateNotifier = ValueNotifier<T>(initialState);

  /// Safely retrieves the current state.
  ///
  /// Returns `null` if the ViewModel has already been disposed.
  T? get safeState => _isDisposed ? null : _stateNotifier.value;

  /// Retrieves the current state.
  ///
  /// Throws an error if accessed after disposal.
  T get state => _stateNotifier.value;

  /// Emits a new state asynchronously.
  ///
  /// This method ensures state transitions happen asynchronously, preventing
  /// UI blocking or unintended synchronous state updates.
  ///
  /// - If the ViewModel is disposed, the update is ignored.
  /// - If the new state is the same as the current state, no update is performed.
  /// - Uses `Future.delayed(Duration.zero)` to defer the state change.
  ///
  /// Example:
  /// ```dart
  /// await emitAsync(MyState("New State"));
  /// ```
  @protected
  Future<void> emitAsync(T newState) async {
    if (_isDisposed || _stateNotifier.value == newState) return;

    await Future.delayed(Duration.zero);

    if (!_isDisposed) {
      _stateNotifier.value = newState;
      notifyListeners();

      if (kDebugMode) {
        debugPrint(
            "ViewModel State Change: ${_stateNotifier.value} => $newState");
      }
    }
  }

  /// Emits a new state synchronously.
  ///
  /// - Ensures that state changes do not happen after disposal.
  /// - Uses `Future.microtask` to allow state changes without blocking the UI.
  ///
  /// Example:
  /// ```dart
  /// emit(MyState("Updated State"));
  /// ```
  @protected
  void emit(T newState) {
    if (_isDisposed || _stateNotifier.value == newState) return;

    _stateNotifier.value = newState;
    notifyListeners();

    if (kDebugMode) {
      debugPrint(
          "ViewModel State Change: ${_stateNotifier.value} => $newState");
    }
  }

  /// Ensures safe disposal by delaying the disposal process.
  ///
  /// This method is useful when there are asynchronous operations running
  /// that might still reference the ViewModel.
  ///
  /// Example:
  /// ```dart
  /// viewModel.disposeSafe();
  /// ```
  Future<void> disposeSafe() async {
    await Future.delayed(Duration.zero);
    dispose();
  }

  /// Cleans up resources when the ViewModel is no longer needed.
  ///
  /// - Disposes the internal `_stateNotifier` to free memory.
  /// - Ensures disposal happens only once to prevent exceptions.
  ///
  /// Example:
  /// ```dart
  /// viewModel.dispose();
  /// ```
  @override
  void dispose() {
    if (!_isDisposed) {
      _stateNotifier.dispose();
      _isDisposed = true;
      super.dispose();
    }
  }
}
