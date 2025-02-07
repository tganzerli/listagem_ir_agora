import 'package:flutter_test/flutter_test.dart';
import 'package:lista_ir_agora/core/core.dart';
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
}
