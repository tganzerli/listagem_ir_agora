import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';
import 'package:lista_ir_agora/domain/entities/rooms_entity.dart';
import 'package:lista_ir_agora/core/core.dart';
import 'package:lista_ir_agora/domain/dto/category_items_dto.dart';
import 'package:lista_ir_agora/domain/dto/room_periods_dto.dart';

class MockUrlImagemVo extends Mock implements UrlImagemVo {}

class MockCategoryItemsDto extends Mock implements CategoryItemsDto {}

class MockRoomPeriodsDto extends Mock implements RoomPeriodsDto {}

void main() {
  late MockUrlImagemVo mockImage;
  late MockCategoryItemsDto mockCategoryItem;
  late MockRoomPeriodsDto mockPeriod;

  setUp(() {
    mockImage = MockUrlImagemVo();
    mockCategoryItem = MockCategoryItemsDto();
    mockPeriod = MockRoomPeriodsDto();
  });

  void mockValidations({
    bool isImageValid = true,
    bool isCategoryItemValid = true,
    bool isPeriodValid = true,
  }) {
    when(() => mockImage.validate()).thenReturn(isImageValid
        ? success(mockImage)
        : failure(ValidationException(message: "Invalid image")));

    when(() => mockCategoryItem.validate()).thenReturn(isCategoryItemValid
        ? success(mockCategoryItem)
        : failure(ValidationException(message: "Invalid category item")));

    when(() => mockPeriod.validate()).thenReturn(isPeriodValid
        ? success(mockPeriod)
        : failure(ValidationException(message: "Invalid period")));
  }

  RoomsEntity createRoomsEntity({
    String name = "Deluxe Suite",
    List<MockUrlImagemVo>? images,
    List<String>? items,
    List<MockCategoryItemsDto>? categoryItems,
    List<MockRoomPeriodsDto>? periods,
  }) {
    return RoomsEntity(
      name: name,
      imagens: images ?? [mockImage],
      itens: items ?? ["TV", "WiFi", "Mini-bar"],
      categoryItems: categoryItems ?? [mockCategoryItem],
      periods: periods ?? [mockPeriod],
    );
  }

  group('RoomsEntity Validation', () {
    test('should return success when all fields are valid', () {
      mockValidations();
      final entity = createRoomsEntity();
      final result = entity.validate();

      expect(result.isRight, true);
    });

    test('should return failure when name is empty', () {
      mockValidations();
      final entity = createRoomsEntity(name: '');
      final result = entity.validate();

      expect(result.isLeft, true);
      expect(result.getLeftOrNull(), isA<ValidationException>());
      expect(result.getLeftOrNull()?.message, 'Suíte sem nome');
    });

    test('should return failure when images list is empty', () {
      mockValidations();
      final entity = createRoomsEntity(images: []);
      final result = entity.validate();

      expect(result.isLeft, true);
      expect(result.getLeftOrNull(), isA<ValidationException>());
      expect(result.getLeftOrNull()?.message, 'Suíte sem imagem');
    });

    test('should return failure when an image validation fails', () {
      mockValidations(isImageValid: false);
      final entity = createRoomsEntity();
      final result = entity.validate();

      expect(result.isLeft, true);
      expect(result.getLeftOrNull(), isA<ValidationException>());
      expect(result.getLeftOrNull()?.message, "Invalid image");
    });

    test('should return failure when a category item validation fails', () {
      mockValidations(isCategoryItemValid: false);
      final entity = createRoomsEntity();
      final result = entity.validate();

      expect(result.isLeft, true);
      expect(result.getLeftOrNull(), isA<ValidationException>());
      expect(result.getLeftOrNull()?.message, "Invalid category item");
    });

    test('should return failure when periods list is empty', () {
      mockValidations();
      final entity = createRoomsEntity(periods: []);
      final result = entity.validate();

      expect(result.isLeft, true);
      expect(result.getLeftOrNull(), isA<ValidationException>());
      expect(result.getLeftOrNull()?.message, 'Suíte sem periodo');
    });

    test('should return failure when a period validation fails', () {
      mockValidations(isPeriodValid: false);
      final entity = createRoomsEntity();
      final result = entity.validate();

      expect(result.isLeft, true);
      expect(result.getLeftOrNull(), isA<ValidationException>());
      expect(result.getLeftOrNull()?.message, "Invalid period");
    });
  });

  group('Mock Classes Validation', () {
    test('MockUrlImagemVo should return success on valid validation', () {
      mockValidations();
      final result = mockImage.validate();

      expect(result.isRight, true);
    });

    test('MockUrlImagemVo should return failure on invalid validation', () {
      mockValidations(isImageValid: false);
      final result = mockImage.validate();

      expect(result.isLeft, true);
      expect(result.getLeftOrNull(), isA<ValidationException>());
      expect(result.getLeftOrNull()?.message, "Invalid image");
    });

    test('MockCategoryItemsDto should return success on valid validation', () {
      mockValidations();
      final result = mockCategoryItem.validate();

      expect(result.isRight, true);
    });

    test('MockCategoryItemsDto should return failure on invalid validation',
        () {
      mockValidations(isCategoryItemValid: false);
      final result = mockCategoryItem.validate();

      expect(result.isLeft, true);
      expect(result.getLeftOrNull(), isA<ValidationException>());
      expect(result.getLeftOrNull()?.message, "Invalid category item");
    });

    test('MockRoomPeriodsDto should return success on valid validation', () {
      mockValidations();
      final result = mockPeriod.validate();

      expect(result.isRight, true);
    });

    test('MockRoomPeriodsDto should return failure on invalid validation', () {
      mockValidations(isPeriodValid: false);
      final result = mockPeriod.validate();

      expect(result.isLeft, true);
      expect(result.getLeftOrNull(), isA<ValidationException>());
      expect(result.getLeftOrNull()?.message, "Invalid period");
    });
  });
}
