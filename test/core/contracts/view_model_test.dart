import 'package:flutter_test/flutter_test.dart';
import 'package:lista_ir_agora/core/core.dart';

/// Mock state for testing
class TestState extends ViewState {
  final String message;

  TestState(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TestState && other.message == message);

  @override
  int get hashCode => message.hashCode;

  @override
  String toString() => "TestState(message: $message)"; // Debugging
}

/// A concrete ViewModel for testing
class TestViewModel extends ViewModel<TestState> {
  TestViewModel() : super(TestState("Initial State"));

  void updateState(String message) {
    emit(TestState(message));
  }

  Future<void> updateStateAsync(String message) async {
    await emitAsync(TestState(message));
  }
}

void main() {
  late TestViewModel viewModel;

  setUp(() {
    viewModel = TestViewModel();
  });

  tearDown(() {
    viewModel.dispose();
  });

  group('Initialization Tests', () {
    test('ViewModel should initialize with correct initial state', () {
      expect(viewModel.state.message, equals("Initial State"));
    });
  });

  group('State Management Tests', () {
    test('emit() should update state', () async {
      viewModel.updateState("New State");
      await Future.delayed(Duration.zero);
      expect(viewModel.state.message, equals("New State"));
    });

    test('emitAsync() should update state asynchronously', () async {
      await viewModel.updateStateAsync("Async State");
      expect(viewModel.state.message, equals("Async State"));
    });

    test('emit() should not notify listeners if state is the same', () {
      int notificationCount = 0;

      void listener() {
        notificationCount++;
      }

      viewModel.addListener(listener);
      viewModel.updateState("New State");
      viewModel.updateState("New State"); // Same state, should not notify

      expect(notificationCount, equals(1));

      viewModel.removeListener(listener);
    });
  });

  group('Listener Tests', () {
    test('Listeners should be notified on state change', () {
      bool wasNotified = false;

      void listener() {
        wasNotified = true;
      }

      viewModel.addListener(listener);
      viewModel.updateState("Updated State");

      expect(wasNotified, isTrue);

      viewModel.removeListener(listener);
    });

    test('Listeners should NOT be notified if state does not change', () {
      bool wasNotified = false;

      void listener() {
        wasNotified = true;
      }

      viewModel.addListener(listener);
      viewModel.updateState("Initial State"); // Same as current state

      expect(wasNotified, isFalse);

      viewModel.removeListener(listener);
    });
  });

  group('Disposal Tests', () {
    test('emit() should not update state after disposal', () {
      viewModel.dispose();
      viewModel.updateState("New State");

      expect(viewModel.safeState, isNull);
    });

    test('emitAsync() should not update state after disposal', () async {
      viewModel.dispose();
      await viewModel.updateStateAsync("New Async State");

      expect(viewModel.safeState, isNull);
    });

    test('disposeSafe() should prevent updates after disposal', () async {
      await viewModel.disposeSafe();
      TestState? lastState = viewModel.state;

      viewModel.updateState("State After Dispose");

      await Future.delayed(Duration.zero);

      expect(viewModel.state, equals(lastState));
    });

    test('Multiple calls to dispose() should not throw errors', () {
      viewModel.dispose();
      expect(() => viewModel.dispose(), returnsNormally);
    });
  });
}
