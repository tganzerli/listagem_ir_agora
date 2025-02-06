import 'package:flutter_test/flutter_test.dart';
import 'package:lista_ir_agora/domain/dto/category_items_dto.dart';

import 'package:mocktail/mocktail.dart';
import 'package:lista_ir_agora/core/core.dart';

class MockUrlImagemVo extends Mock implements UrlImagemVo {}

void main() {
  late MockUrlImagemVo mockIcon;

  setUp(() {
    mockIcon = MockUrlImagemVo();
  });

  group('CategoryItemsDto Validation', () {
    test('should return success when name is not empty and icon is valid', () {
      when(() => mockIcon.validate()).thenReturn(success(mockIcon));
      final dto = CategoryItemsDto(name: 'Valid Name', icon: mockIcon);

      final result = dto.validate();

      expect(result.isRight, true);
    });

    test('should return failure when name is empty', () {
      when(() => mockIcon.validate()).thenReturn(success(mockIcon));
      final dto = CategoryItemsDto(name: '', icon: mockIcon);

      final result = dto.validate();

      expect(result.isLeft, true);
      expect(result.getLeftOrNull(), isA<ValidationException>());
      expect(result.getLeftOrNull()?.message, 'Categoria de itens sem nome');
    });

    test('should return failure when icon validation fails', () {
      when(() => mockIcon.validate())
          .thenReturn(failure(ValidationException(message: 'Invalid icon')));
      final dto = CategoryItemsDto(name: 'Valid Name', icon: mockIcon);

      final result = dto.validate();

      expect(result.isLeft, true);
      expect(result.getLeftOrNull(), isA<ValidationException>());
      expect(result.getLeftOrNull()?.message, 'Invalid icon');
    });
  });
}
