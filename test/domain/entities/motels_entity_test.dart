import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:lista_ir_agora/core/core.dart';
import 'package:lista_ir_agora/domain/dto/category_items_dto.dart';
import 'package:lista_ir_agora/domain/dto/room_periods_dto.dart';
import 'package:lista_ir_agora/domain/entities/motels_entity.dart';
import 'package:lista_ir_agora/domain/entities/rooms_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockUrlImagemVo extends Mock implements UrlImagemVo {}

class MockRoomsEntity extends Mock implements RoomsEntity {}

void main() {
  late MockUrlImagemVo mockLogo;
  late MockRoomsEntity mockRoom;

  setUp(() {
    mockLogo = MockUrlImagemVo();
    mockRoom = MockRoomsEntity();

    when(() => mockLogo.validate()).thenReturn(right(mockLogo));
    when(() => mockRoom.validate()).thenReturn(right(mockRoom));
  });

  group('MotelsEntity Validation', () {
    test('should return success when all fields are valid', () {
      final motel = MotelsEntity(
        name: "Luxury Inn",
        logo: mockLogo,
        neighborhood: "Downtown",
        motelRooms: [mockRoom],
      );

      final result = motel.validate();

      expect(result.isRight, true);
      expect(result.getOrNull(), motel);
    });

    test('should return failure when name is empty', () {
      final motel = MotelsEntity(
        name: "",
        logo: mockLogo,
        neighborhood: "Downtown",
        motelRooms: [mockRoom],
      );

      final result = motel.validate();

      expect(result.isLeft, true);
      expect(result.getLeftOrNull(), isA<ValidationException>());
      expect(result.getLeftOrNull()?.message, 'Motel sem nome');
    });

    test('should return failure when logo is invalid', () {
      when(() => mockLogo.validate())
          .thenReturn(left(ValidationException(message: 'Invalid logo')));

      final motel = MotelsEntity(
        name: "Luxury Inn",
        logo: mockLogo,
        neighborhood: "Downtown",
        motelRooms: [mockRoom],
      );

      final result = motel.validate();

      expect(result.isLeft, true);
      expect(result.getLeftOrNull(), isA<ValidationException>());
      expect(result.getLeftOrNull()?.message, 'Invalid logo');
    });

    test('should return failure when motelRooms is empty', () {
      final motel = MotelsEntity(
        name: "Luxury Inn",
        logo: mockLogo,
        neighborhood: "Downtown",
        motelRooms: [],
      );

      final result = motel.validate();

      expect(result.isLeft, true);
      expect(result.getLeftOrNull(), isA<ValidationException>());
      expect(result.getLeftOrNull()?.message,
          'Motel não possui quartos no seu catalogo');
    });

    test('should return failure when a room validation fails', () {
      when(() => mockRoom.validate())
          .thenReturn(left(ValidationException(message: 'Invalid room')));

      final motel = MotelsEntity(
        name: "Luxury Inn",
        logo: mockLogo,
        neighborhood: "Downtown",
        motelRooms: [mockRoom],
      );

      final result = motel.validate();

      expect(result.isLeft, true);
      expect(result.getLeftOrNull(), isA<ValidationException>());
      expect(result.getLeftOrNull()?.message, 'Invalid room');
    });
  });

  group('MotelsEntity Serialization', () {
    final validMotel = MotelsEntity(
      name: "Luxury Inn",
      logo: UrlImagemVo('https://example.com/logo.png'),
      neighborhood: "Downtown",
      motelRooms: [
        RoomsEntity(
          name: 'Deluxe Suite',
          imagens: [UrlImagemVo('https://example.com/image.png')],
          itens: ['TV', 'WiFi'],
          categoryItems: [
            CategoryItemsDto(
                name: 'Category 1',
                icon: UrlImagemVo('https://example.com/icon.png'))
          ],
          periods: [
            RoomPeriodsDto(
              formattedTime: '3 horas',
              amount: AmountVo(100),
              fullAmount: AmountVo(200),
              percentageDiscount: PercentageVo(0.5),
            )
          ],
        )
      ],
    );

    final validMap = {
      'name': "Luxury Inn",
      'logo': 'https://example.com/logo.png',
      'neighborhood': "Downtown",
      'motelRooms': [
        {
          'name': 'Deluxe Suite',
          'imagens': ['https://example.com/image.png'],
          'itens': ['TV', 'WiFi'],
          'categoryItems': [
            {'name': 'Category 1', 'icon': 'https://example.com/icon.png'}
          ],
          'periods': [
            {
              'formattedTime': '3 horas',
              'amount': 100.0,
              'fullAmount': 200.0,
              'percentageDiscount': 0.5,
            }
          ],
        }
      ],
    };

    test('should convert toMap correctly', () {
      expect(validMotel.toMap(), equals(validMap));
    });

    test('should convert fromMap correctly', () {
      final motel = MotelsEntity.fromMap(validMap);
      expect(motel.name, "Luxury Inn");
      expect(motel.logo.value, 'https://example.com/logo.png');
      expect(motel.neighborhood, "Downtown");
      expect(motel.motelRooms.first.name, 'Deluxe Suite');
    });

    test('should convert toJson correctly', () {
      final jsonResult = validMotel.toJson();
      expect(json.decode(jsonResult), equals(validMap));
    });

    test('should convert fromJson correctly', () {
      final motel = MotelsEntity.fromJson(json.encode(validMap));
      expect(motel.name, "Luxury Inn");
      expect(motel.logo.value, 'https://example.com/logo.png');
      expect(motel.neighborhood, "Downtown");
      expect(motel.motelRooms.first.name, 'Deluxe Suite');
    });
  });
}
