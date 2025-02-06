export 'value_objects_types/vo_types.dart';

import 'package:lista_ir_agora/core/core.dart';

/// Abstract class representing a generic Value Object.
/// A Value Object is an immutable object that represents a concept and ensures its validity.
/// This class enforces validation through the `validate` method.
///
/// The type parameter `<T>` defines the underlying data type of the value.
abstract class ValueObject<T> {
  /// The stored value of the Value Object.
  final T value;

  /// Constructor that initializes the Value Object with a given value.
  ValueObject(this.value);

  /// Validates the value stored in the Value Object.
  /// This method should be implemented in subclasses to enforce specific validation rules.
  ///
  /// Returns an `Output<ValueObject<T>>` representing the validation result.
  Output<ValueObject<T>> validate();

  /// Returns a string representation of the Value Object.
  @override
  String toString() => '$runtimeType: $value';

  /// Compares this Value Object with another for equality.
  /// Two Value Objects are considered equal if they have the same runtime type and value.
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ValueObject<T> && other.value == value;

  /// Returns the hash code of the Value Object, which is based on the value.
  @override
  int get hashCode => value.hashCode;
}
