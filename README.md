# Lista ir agora

This test aims to evaluate the candidate's skills in Flutter, Dart, state management, API consumption, and unit testing. The challenge involves developing the motel listing screen (specifically the "Ir Agora" tab) from the Guia de Motéis GO app, using mock APIs to retrieve data.

The listing should display motel name, price, and image, allowing for visual variations without requiring strict adherence to the original design. Additionally, unit tests must be implemented to cover the main components of the application.

## 📌 Technology

The technology chosen for the development of this project was `Flutter`. Find out more at: [flutter.dev](https://flutter.dev/)

### Required Versions
- **Dart**: [![Dart][dart_img]][dart_ln] [Official Dart Documentation](https://dart.dev)

- **Flutter**: [![Flutter][flutter_img]][flutter_ln] [Official Flutter Documentation](https://docs.flutter.dev/get-started/install)

## 💡 Usage
...

## 🧪 Running Tests

To ensure the functionality of the exception classes, run the unit tests using:

```sh
flutter test
```

### **Running tests with coverage**
To generate a coverage report:

```sh
flutter test --coverage
```

To view coverage results in an HTML report:
```sh
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html  # macOS
xdg-open coverage/html/index.html  # Linux
start coverage/html/index.html  # Windows
```

## 📖 **Documentation**
### Error and Results Handling

In operations that may return results or errors, we can use the typedef `Output<T>` to represent the output of these operations. This typedef allows us to encapsulate both success and failure in a single type using `Either`.

- Operation can return a success (T) or an error `(BaseException)`.
- This typedef is parameterized with a generic type T, which represents the type of data returned in case of success.

```dart

typedef Output<T> = Either<BaseException, T>;

```

#### 1. Either

`Either<TLeft, TRight>` is a functional programming construct used to represent a **value that can be one of two types**:
- **Left (`TLeft`)**: Represents a failure, usually an error or exceptional case.
- **Right (`TRight`)**: Represents a success, containing the expected result.

This eliminates the need for exceptions (`try-catch`) by making errors **explicit and type-safe**.

#### 2. `BaseException` - Standardized Error 
`BaseException` is a custom exception class used in `Output<T>` to handle errors in a structured way.
**Implementation**
```dart
class BaseException implements Exception {
  final String message;
  BaseException(this.message);

  @override
  String toString() => "BaseException: $message";
}
```
###### Creating Exception Classes
Creating exception classes to handle specific errors is possible by extending the **BaseException** class. Use the `DefaultException` structure as a basis:
```dart

class DefaultException extends BaseException {
	const DefaultException({
		required super.message,
		super.stackTracing,
	});
}
```
**Usage Example**
```dart
try {
  throw DefaultException("Something went wrong!");
} catch (e) {
  print(e); // Output: DefaultException: Something went wrong!
}
```

#### 3. `Output<T>` - Typed Result Handling
`Output<T>` is a specialized version of `Either` designed for **error handling**. It always returns:
- `Left<BaseException>` for errors.
- `Right<T>` for successful values.
##### Definition
```dart
typedef Output<T> = Either<BaseException, T>;
```

##### Helper Functions
To simplify result handling, we define:
```dart
Output<T> success<T>(T value) => right<BaseException, T>(value);
Output<T> failure<T>(BaseException exception) => left<BaseException, T>(exception);
```

##### Usage Examples
**Handling Parsing**
```dart
Output<int> parseNumber(String input) {
  try {
    return success(int.parse(input));
  } catch (e) {
    return failure(BaseException("Invalid input"));
  }
}
```

 **Handling API Calls**
```dart
Future<Output<String>> fetchData() async {
  try {
    await Future.delayed(Duration(seconds: 1));
    return success("Data fetched successfully!");
  } catch (e) {
    return failure(BaseException("Failed to fetch data"));
  }
}
```

#### 4. `AsyncOutput<T>` - Handling Async Operations
`AsyncOutput<T>` encapsulates an **asynchronous computation** that can result in either:
- **Success (`T`)**.
- **Failure (`BaseException`)**.

Instead of using `Future<T>` directly, **`AsyncOutput<T>` enables functional operations** like `map`, `bind`, and `fold`, making asynchronous programming **safer and more composable**.

#### 5. `Unit` - Placeholder Return Type
The `Unit` class represents a **singleton value** that signifies the absence of meaningful return data. It is inspired by **functional programming paradigms** (Scala, Kotlin).

Instead of using `void`, we return `Unit` when we need a function to return something but **do not want to use `null`**.
**Usage Scenarios**

**Replacing `void`**
Instead of:
```dart
void logMessage(String message) {
  print(message);
}
```
Use:
```dart
Unit logMessage(String message) {
  print(message);
  return unit;
}
```

**Using `Unit` in `Either`**
```dart
Output<Unit> saveData(String data) {
  if (data.isEmpty) {
    return failure(BaseException("Cannot save empty data"));
  }
  return success(unit);
}
```
### State Pattern
This project follows the **State Pattern**, leveraging **Flutter's native state management tools** to control and notify state changes efficiently. The architecture is based on an abstract class called `ViewModel`, which manages UI state using `ValueNotifier<T>`. This ensures a **reactive and lightweight** state management approach while maintaining compatibility with Flutter’s built-in **[ValueListenableBuilder]**, **[ListenableBuilder]**, and **[AnimatedBuilder]** widgets.

---

#### How to Use?

Each **screen or component** should have a dedicated `ViewModel` that extends `ViewModel<T>`. Additionally, you can create specific **state classes** to represent different UI states.

**Defining States**  
Define states by extending `ViewState`. Example:
```dart
final class HomeSuccess extends ViewState {
  final String message;
  HomeSuccess(this.message);
}
```
This approach ensures that each state is **explicitly defined**, making it easier to manage and debug.

---

**Creating a ViewModel**
A ViewModel extends `ViewModel<T>` and **manages state transitions**.
```dart
class HomeViewModel extends ViewModel<ViewState> {
  HomeViewModel() : super(HomeInitial());

  Future<void> fetchData() async {
    emit(HomeLoading());
    await Future.delayed(Duration(seconds: 2)); // Simulating an API call
    emit(HomeSuccess("Data Loaded Successfully"));
  }
}
```
- The `fetchData()` function:
  - Emits a **loading state** (`HomeLoading()`).
  - Performs an **asynchronous operation** (simulated delay for API calls).
  - Emits a **success state** (`HomeSuccess()`).

---

**Listening to State Updates**
The `ViewModel` can be consumed using **Flutter’s built-in listeners**:

```dart
ValueListenableBuilder<ViewState>(
  valueListenable: homeViewModel,
  builder: (context, state, _) {
    if (state is HomeLoading) {
      return CircularProgressIndicator();
    } else if (state is HomeSuccess) {
      return Text(state.message);
    } else {
      return Text("Initial State");
    }
  },
);
```
- **Why use `ValueListenableBuilder`?**
  - It listens **only** to relevant state changes.
  - More efficient than `setState()`.
  - Works well with **dependency injection**.


<!-- Links úteis: -->
[dart_img]: https://img.shields.io/static/v1?label=Dart&message=3.6.1&color=blue&logo=dart
[dart_ln]: https://dart.dev/ "https://dart.dev/"
[flutter_img]: https://img.shields.io/static/v1?label=Flutter&message=3.27.3&color=blue&logo=flutter
[flutter_ln]: https://docs.flutter.dev/get-started/install "https://docs.flutter.dev/get-started/install"
