import 'package:lista_ir_agora/core/core.dart';

/// An abstract base class for domain entities.
///
/// Entities are objects that possess a unique identity over time and encapsulate
/// domain-specific logic. This class enforces that all entities have an identifier
/// of type [T] and must implement validation logic to ensure that they adhere to
/// the business rules.
///
/// The [validate] method should be overridden in subclasses to provide the appropriate
/// validation for the entity. It returns an [Output] wrapping either the valid entity
/// or error details if the validation fails.
///
/// Equality is determined solely by the [id] and the runtime type of the entity.
abstract class Entity<T> {
  /// The unique identifier for the entity.
  final T id;

  /// Creates an instance of [Entity] with the provided unique [id].
  ///
  /// The [id] parameter is required and must uniquely identify the entity.
  Entity({required this.id});

  /// Validates the entity's state against its business rules.
  ///
  /// Returns an [Output] containing the entity itself if validation succeeds,
  /// or error information if validation fails.
  ///
  /// This method must be implemented by all subclasses to perform their specific
  /// domain validations.
  Output<Entity<T>> validate();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Entity && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
