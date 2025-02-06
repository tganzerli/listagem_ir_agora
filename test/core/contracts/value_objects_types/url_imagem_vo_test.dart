import 'package:flutter_test/flutter_test.dart';
import 'package:lista_ir_agora/core/core.dart';

void main() {
  group('UrlImagemVo Validation', () {
    test('should return success for a valid image URL', () {
      final url = UrlImagemVo('https://example.com/image.png');
      final result = url.validate();

      expect(result.isRight, isTrue);
      expect(result.getOrNull(), equals(url));
    });

    test('should return success for a valid image URL with query parameters',
        () {
      final url = UrlImagemVo('https://example.com/photo.jpeg?size=large');
      final result = url.validate();

      expect(result.isRight, isTrue);
      expect(result.getOrNull(), equals(url));
    });

    test('should return failure for an invalid image URL (wrong extension)',
        () {
      final url = UrlImagemVo('https://example.com/document.pdf');
      final result = url.validate();

      expect(result.isLeft, isTrue);
      expect(result.getLeftOrNull(), isA<ValidationException>());
      expect(
          result.getLeftOrNull()?.message, equals('Url is not a valid image'));
    });

    test('should return failure for an URL without protocol', () {
      final url = UrlImagemVo('www.example.com/image.jpg');
      final result = url.validate();

      expect(result.isLeft, isTrue);
      expect(result.getLeftOrNull(), isA<ValidationException>());
      expect(
          result.getLeftOrNull()?.message, equals('Url is not a valid image'));
    });

    test('should return failure for an URL without an image extension', () {
      final url = UrlImagemVo('https://example.com/photo');
      final result = url.validate();

      expect(result.isLeft, isTrue);
      expect(result.getLeftOrNull(), isA<ValidationException>());
      expect(
          result.getLeftOrNull()?.message, equals('Url is not a valid image'));
    });

    test('should return failure for an empty URL', () {
      final url = UrlImagemVo('');
      final result = url.validate();

      expect(result.isLeft, isTrue);
      expect(result.getLeftOrNull(), isA<ValidationException>());
      expect(
          result.getLeftOrNull()?.message, equals('Url is not a valid image'));
    });

    test('should return failure for an invalid formatted URL', () {
      final url = UrlImagemVo('htp:/example.com/image.png');
      final result = url.validate();

      expect(result.isLeft, isTrue);
      expect(result.getLeftOrNull(), isA<ValidationException>());
      expect(
          result.getLeftOrNull()?.message, equals('Url is not a valid image'));
    });
  });

  group('UrlImagemVo Serialization', () {
    test('should convert UrlImagemVo to a string', () {
      final url = UrlImagemVo('https://example.com/image.png');
      expect(url.toMap(), equals('https://example.com/image.png'));
    });

    test('should create UrlImagemVo from a string', () {
      final url = UrlImagemVo.fromMap('https://example.com/image.png');
      expect(url.value, equals('https://example.com/image.png'));
    });
  });

  group('Equality and HashCode', () {
    test(
        'should consider two UrlImagemVo instances with the same value as equal',
        () {
      final url1 = UrlImagemVo('https://example.com/image.png');
      final url2 = UrlImagemVo('https://example.com/image.png');

      expect(url1, equals(url2));
      expect(url1.hashCode, equals(url2.hashCode));
    });

    test(
        'should consider two UrlImagemVo instances with different values as not equal',
        () {
      final url1 = UrlImagemVo('https://example.com/image1.png');
      final url2 = UrlImagemVo('https://example.com/image2.png');

      expect(url1, isNot(equals(url2)));
      expect(url1.hashCode, isNot(equals(url2.hashCode)));
    });
  });
}
