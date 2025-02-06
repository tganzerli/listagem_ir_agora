# Lista ir agora

This test aims to evaluate the candidate's skills in Flutter, Dart, state management, API consumption, and unit testing. The challenge involves developing the motel listing screen (specifically the "Ir Agora" tab) from the Guia de Motéis GO app, using mock APIs to retrieve data.

The listing should display motel name, price, and image, allowing for visual variations without requiring strict adherence to the original design. Additionally, unit tests must be implemented to cover the main components of the application.

## 📌 Technology

The technology chosen for the development of this project was `Flutter`. Find out more at: [flutter.dev](https://flutter.dev/)

### Required Versions
- **Dart**: [![Dart][dart_img]][dart_ln] [Official Dart Documentation](https://dart.dev)

- **Flutter**: [![Flutter][flutter_img]][flutter_ln] [Official Flutter Documentation](https://docs.flutter.dev/get-started/install)

### Main Packages Used

- [Auto Injector](https://pub.dev/packages/auto_injector): Dependency injection in the app

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

### Command Pattern
The **Command Pattern** is used in this project to **encapsulate asynchronous actions** while ensuring proper **state management, execution control, and error handling**.

This implementation follows Flutter’s **[Command Pattern](https://docs.flutter.dev/app-architecture/design-patterns/command)** approach and uses the **`Command<BaseException, T>`** class to manage execution safely.

---

#### Why Use the Command Pattern?
- **Encapsulates asynchronous operations** (`Future<T>`) while keeping execution state.
- **Prevents concurrent execution issues** (ensures only one execution at a time).
- **Automatically manages success (`Right<T>`) and failure (`Left<BaseException>`) results.**
- **Provides utility getters** (`rightResult`, `leftResult`, `isExecuting`, `isSuccess`, `isException`).


#### Implementing Commands
This project provides **three types of commands**:
1. **`Command0<T>`** – No parameters.
2. **`Command1<T, P>`** – One parameter.
3. **`Command2<T, P1, P2>`** – Two parameters.

Each extends `Command<BaseException, T>` and ensures **execution control**.

**Command0<T> (No Parameters)**
For **simple asynchronous actions** without parameters:
```dart
final command = Command0<int>(() async {
  return Output.right(42);
});

await command.execute();
print(command.rightResult); // 42
```

**Command1<T, P> (Single Parameter)**
For **actions requiring one parameter**:
```dart
final command = Command1<String, int>((value) async {
  return Output.right("Number: $value");
});

await command.execute(5);
print(command.rightResult); // "Number: 5"
```

**Command2<T, P1, P2> (Two Parameters)**
For **actions requiring two parameters**:
```dart
final command = Command2<bool, int, int>((a, b) async {
  return Output.right(a + b > 10);
});

await command.execute(5, 10);
print(command.rightResult); // true
```

---

**Command Execution Control**
All commands **prevent concurrent execution** and provide useful utilities:

```dart
if (command.isExecuting) {
  print("Already executing...");
}

await command.waitForCompletion(); // Waits for execution to finish
command.clean(); // Clears previous results
```

### Dependency Inversion Principle (DIP)

The Dependency Inversion Principle (DIP) is a cornerstone of the SOLID principles in object-oriented design. It dictates that high-level modules should not depend on low-level modules; rather, both should depend on abstractions. In essence, dependencies should point to abstract interfaces or classes rather than to concrete implementations. This approach makes systems more modular, testable, and maintainable. For an in-depth discussion, check out [this article](https://medium.com/@flutterdynasty/mastering-dependency-inversion-principle-in-flutter-e1748fe9e006).

To effectively apply DIP in your projects, consider the following practices:

- **Define Clear Abstractions**:  
  Identify interfaces or abstract classes that specify the required behaviors of your high-level modules. Ensure these abstractions remain independent of any concrete implementations.

- **Inject Dependencies**:  
  Rather than instantiating objects directly within a class, supply them via constructors, methods, or properties. This strategy allows you to swap out concrete implementations with alternative versions that adhere to the same abstraction without altering the high-level module's code.

- **Embrace Inversion of Control (IoC)**:  
  In DIP, the control flow is inverted so that concrete implementations depend on abstractions. This inversion is often achieved with a dependency injection container that manages the instantiation and resolution of dependencies.

- **Test in Isolation**:  
  By relying on abstractions and injecting dependencies, you can easily substitute real implementations with mocks or stubs during testing. This isolation facilitates thorough unit testing of each component.

Implementing these practices results in a codebase that is flexible, modular, and easier to maintain.

Here's an example demonstrating DIP in practice:

```dart
class GetShowUseCaseImpl extends GetShowUseCase {
  final ShowRepository showRepository;

  GetShowUseCaseImpl({
    required this.showRepository,
  });
}
```

In this example, `GetShowUseCaseImpl` depends on the abstract `ShowRepository` rather than a concrete implementation, adhering to the DIP and promoting a design that is both decoupled and easy to test.

### Dependency Injection (Auto Injector)

**Coupling** occurs when one class directly depends on another—for example, when a class calls another to execute an operation or retrieve data. In such cases, the first class is tied to the implementation details of the second, creating a dependency that can make maintenance and testing more challenging.

To decouple classes from their dependencies, we use **Dependency Injection**. This technique involves supplying an object’s dependencies through its constructor, setters, or methods, rather than having the object create them itself. You can see an example of this approach in our discussion on the [Dependency Inversion Principle (DIP)](#dependency-inversion-principle-dip).

The [**Auto Injector**](https://pub.dev/packages/auto_injector) strategy facilitates dependency injection by managing the registration and creation of objects within a module. All objects are registered with the injector, which then constructs them on demand or as singletons (i.e., a single instance per module). The entire registration process is handled by the auto_injector system.

There are several methods available for binding (registering) object instances:

- **`injector.add`**: Creates an instance on demand (factory).
- **`injector.addSingleton`**: Creates an instance once when the module starts.
- **`injector.addLazySingleton`**: Creates an instance once, at the time of first request.
- **`injector.addInstance`**: Registers an already existing instance.

Here’s an example of how to configure the injector:

```dart
final injector = AutoInjector(on: (injector) {
  injector.addInjector(coreModule);
  injector.addInjector(showScheduleModule);
  injector.addInjector(weatherForecastModule);

  injector.addLazySingleton<HomeController>(HomeController.new);

  injector.commit();
});
```

In this setup, the dependencies for each instance are automatically resolved using the auto_injector mechanisms.

To retrieve an instance, use the `autoInjector.get` method:

```dart
// Retrieve an instance of Client
final client = autoInjector.get<Client>();

// Retrieve an instance with a default value if not found
final clientWithDefault = autoInjector.get<Client>(defaultValue: Client());

// Alternatively, use tryGet to return null if not available, then provide a fallback
Client clientOrFallback = autoInjector.tryGet<Client>() ?? Client();

// Retrieve an instance using a specific key
Client keyedClient = autoInjector.get(key: 'OtherClient');
```

By using these strategies, your code becomes more modular, easier to test, and simpler to maintain.

<!-- Links úteis: -->
[dart_img]: https://img.shields.io/static/v1?label=Dart&message=3.6.1&color=blue&logo=dart
[dart_ln]: https://dart.dev/ "https://dart.dev/"
[flutter_img]: https://img.shields.io/static/v1?label=Flutter&message=3.27.3&color=blue&logo=flutter
[flutter_ln]: https://docs.flutter.dev/get-started/install "https://docs.flutter.dev/get-started/install"
