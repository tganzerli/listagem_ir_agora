import 'dart:convert';

import 'package:lista_ir_agora/core/core.dart';

import '../dto/category_items_dto.dart';
import '../dto/room_periods_dto.dart';

class RoomsEntity extends Entity<String> {
  final String name;
  final List<UrlImagemVo> imagens;
  final List<String> itens;
  final List<CategoryItemsDto> categoryItems;
  final List<RoomPeriodsDto> periods;
  RoomsEntity({
    required this.name,
    required this.imagens,
    required this.itens,
    required this.categoryItems,
    required this.periods,
  }) : super(id: name);

  @override
  Output<RoomsEntity> validate() {
    if (name.isEmpty) {
      return failure(ValidationException(message: 'Suíte sem nome'));
    }
    if (imagens.isEmpty) {
      return failure(ValidationException(message: 'Suíte sem imagem'));
    }
    for (var urlImagen in imagens) {
      if (urlImagen.validate().isLeft) {
        return urlImagen.validate().map((r) => this);
      }
    }
    for (var item in categoryItems) {
      if (item.validate().isLeft) {
        return item.validate().map((r) => this);
      }
    }
    if (periods.isEmpty) {
      return failure(ValidationException(message: 'Suíte sem periodo'));
    }
    for (var period in periods) {
      if (period.validate().isLeft) {
        return period.validate().map((r) => this);
      }
    }

    return success(this);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imagens': imagens.map((x) => x.toMap()).toList(),
      'itens': itens,
      'categoryItems': categoryItems.map((x) => x.toMap()).toList(),
      'periods': periods.map((x) => x.toMap()).toList(),
    };
  }

  factory RoomsEntity.fromMap(Map<String, dynamic> map) {
    return RoomsEntity(
      name: map['name'] ?? '',
      imagens: List<UrlImagemVo>.from(
          map['imagens']?.map((x) => UrlImagemVo.fromMap(x))),
      itens: List<String>.from(map['itens']),
      categoryItems: List<CategoryItemsDto>.from(
          map['categoryItems']?.map((x) => CategoryItemsDto.fromMap(x))),
      periods: List<RoomPeriodsDto>.from(
          map['periods']?.map((x) => RoomPeriodsDto.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory RoomsEntity.fromJson(String source) =>
      RoomsEntity.fromMap(json.decode(source));
}
