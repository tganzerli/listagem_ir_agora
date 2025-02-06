import 'package:lista_ir_agora/core/core.dart';

/// A Value Object representing a validated image URL.
/// This class ensures that the provided URL points to an image file
/// with extensions such as `.png`, `.jpg`, `.jpeg`, or `.gif`.
class UrlImagemVo extends ValueObject<String> {
  /// Constructs a `UrlImagemVo` with a given URL string.
  UrlImagemVo(super.value);

  /// Converts the Value Object to a plain string representation (the URL itself).
  String toMap() => value;

  /// Factory constructor to create a `UrlImagemVo` from a raw string.
  factory UrlImagemVo.fromMap(String url) => UrlImagemVo(url);

  /// Validates whether the stored URL is a valid image URL.
  ///
  /// The validation checks if the URL starts with `http` or `https` and ends with
  /// a supported image extension (`.png`, `.jpg`, `.jpeg`, `.gif`). Query parameters are allowed.
  ///
  /// Returns:
  /// - `success(this)` if the URL is valid.
  /// - `failure(ValidationException)` if the URL does not point to a valid image.
  @override
  Output<UrlImagemVo> validate() {
    final regex = RegExp(
      r'^https?:\/\/.*\.(?:png|jpg|jpeg|gif)(?:\?.*)?$',
      caseSensitive: false,
    );

    if (!regex.hasMatch(value)) {
      return failure(ValidationException(message: 'Url is not a valid image'));
    }

    return success(this);
  }
}
