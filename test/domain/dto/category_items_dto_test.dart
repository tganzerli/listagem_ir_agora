import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:lista_ir_agora/domain/dto/category_items_dto.dart';
import 'package:lista_ir_agora/core/core.dart';

void main() {
  group('CategoryItemsDto Validation', () {
    test('should return success when name is not empty and icon is valid', () {
      final validIcon = UrlImagemVo('https://example.com/icon.png');
      final dto = CategoryItemsDto(name: 'Valid Name', icon: validIcon);

      final result = dto.validate();

      expect(result.isRight, true);
    });

    test('should return failure when name is empty', () {
      final validIcon = UrlImagemVo('https://example.com/icon.png');
      final dto = CategoryItemsDto(name: '', icon: validIcon);

      final result = dto.validate();

      expect(result.isLeft, true);
      expect(result.getLeftOrNull(), isA<ValidationException>());
      expect(result.getLeftOrNull()?.message, 'Categoria de itens sem nome');
    });

    test('should return failure when icon validation fails', () {
      final invalidIcon = UrlImagemVo('invalid_url');
      final dto = CategoryItemsDto(name: 'Valid Name', icon: invalidIcon);

      final result = dto.validate();

      expect(result.isLeft, true);
      expect(result.getLeftOrNull(), isA<ValidationException>());
      expect(result.getLeftOrNull()?.message, 'Url is not a valid image');
    });
  });

  group('CategoryItemsDto Serialization', () {
    final validIcon = UrlImagemVo('https://example.com/icon.png');
    final validMap = {
      'name': 'Valid Name',
      'icon': 'https://example.com/icon.png',
    };

    test('should convert toMap correctly', () {
      final dto = CategoryItemsDto(name: 'Valid Name', icon: validIcon);
      expect(dto.toMap(), equals(validMap));
    });

    test('should convert fromMap correctly', () {
      final dto = CategoryItemsDto.fromMap(validMap);
      expect(dto.name, 'Valid Name');
      expect(dto.icon.value, 'https://example.com/icon.png');
    });

    test('should convert toJson correctly', () {
      final dto = CategoryItemsDto(name: 'Valid Name', icon: validIcon);
      final jsonResult = dto.toJson();
      expect(json.decode(jsonResult), equals(validMap));
    });

    test('should convert fromJson correctly', () {
      final dto = CategoryItemsDto.fromJson(json.encode(validMap));
      expect(dto.name, 'Valid Name');
      expect(dto.icon.value, 'https://example.com/icon.png');
    });
  });
}
