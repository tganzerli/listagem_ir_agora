import 'package:lista_ir_agora/core/core.dart';
import 'package:lista_ir_agora/domain/dto/category_items_dto.dart';
import 'package:lista_ir_agora/domain/dto/room_periods_dto.dart';
import 'package:lista_ir_agora/domain/entities/motels_entity.dart';
import 'package:lista_ir_agora/domain/entities/rooms_entity.dart';

class GoNowListAdapter {
  static Output<List<MotelsEntity>> fromMap(Map<String, dynamic> map) {
    try {
      final moteis = (map['data']?['moteis'] as List<dynamic>?)
          ?.whereType<Map<String, dynamic>>()
          .map(_motelMap)
          .toList();

      if (moteis == null || moteis.isEmpty) {
        throw FormatedException(message: 'Nenhum motel encontrado');
      }

      return success(moteis);
    } on BaseException catch (e) {
      return failure(e);
    } catch (e) {
      return failure(
          FormatedException(message: 'GoNowListAdapter - fromMap: $e'));
    }
  }

  static MotelsEntity _motelMap(Map<String, dynamic> map) {
    try {
      final result = MotelsEntity(
        name: map['fantasia'] ?? '',
        logo: UrlImagemVo(map['logo'] ?? ''),
        neighborhood: map['bairro'] ?? '',
        motelRooms: ((map['suites'] as List<dynamic>?) ?? [])
            .whereType<Map<String, dynamic>>()
            .map(_roomsMap)
            .toList(),
      );

      return result.validate().fold(
            (error) => throw error,
            (success) => success,
          );
    } on BaseException catch (_) {
      rethrow;
    } catch (e) {
      throw failure(
          FormatedException(message: 'GoNowListAdapter - _motelMap: $e'));
    }
  }

  static RoomsEntity _roomsMap(Map<String, dynamic> map) {
    try {
      final result = RoomsEntity(
        name: map['nome'] ?? '',
        imagens: ((map['fotos'] as List<dynamic>?) ?? [])
            .whereType<String>()
            .map((image) => UrlImagemVo(image))
            .toList(),
        itens: ((map['itens'] as List<dynamic>?) ?? [])
            .whereType<Map<String, dynamic>>()
            .map((item) => item['nome'] as String? ?? '')
            .toList(),
        categoryItems: ((map['categoriaItens'] as List<dynamic>?) ?? [])
            .whereType<Map<String, dynamic>>()
            .map(_categoryMap)
            .toList(),
        periods: ((map['periodos'] as List<dynamic>?) ?? [])
            .whereType<Map<String, dynamic>>()
            .map(_periodsMap)
            .toList(),
      );

      return result.validate().fold(
            (error) => throw error,
            (success) => success,
          );
    } on BaseException catch (_) {
      rethrow;
    } catch (e) {
      throw failure(
          FormatedException(message: 'GoNowListAdapter - _roomsMap: $e'));
    }
  }

  static CategoryItemsDto _categoryMap(Map<String, dynamic> map) {
    try {
      final result = CategoryItemsDto(
        name: map['nome'] ?? '',
        icon: UrlImagemVo(map['icone'] ?? ''),
      );

      return result.validate().fold(
            (error) => throw error,
            (success) => success,
          );
    } on BaseException catch (_) {
      rethrow;
    } catch (e) {
      throw FormatedException(message: 'GoNowListAdapter - _categoryMap: $e');
    }
  }

  static RoomPeriodsDto _periodsMap(Map<String, dynamic> map) {
    try {
      final amount =
          AmountVo(double.tryParse(map['valorTotal'].toString()) ?? 0.00);
      final fullAmount =
          AmountVo(double.tryParse(map['valor'].toString()) ?? 0.00);

      final result = RoomPeriodsDto(
          formattedTime: map['tempoFormatado'] ?? '',
          amount: amount,
          fullAmount: fullAmount,
          percentageDiscount:
              PercentageVo.calcularPorcentagem(amount, fullAmount));

      return result.validate().fold(
            (error) => throw error,
            (success) => success,
          );
    } on BaseException catch (_) {
      rethrow;
    } catch (e) {
      throw FormatedException(message: 'GoNowListAdapter - _periodsMap: $e');
    }
  }
}
