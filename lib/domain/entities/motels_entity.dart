import 'dart:convert';

import 'package:lista_ir_agora/core/core.dart';

import 'rooms_entity.dart';

class MotelsEntity extends Entity<String> {
  final String name;
  final UrlImagemVo logo;
  final String neighborhood;
  final List<RoomsEntity> motelRooms;
  MotelsEntity({
    required this.name,
    required this.logo,
    required this.neighborhood,
    required this.motelRooms,
  }) : super(id: name);

  @override
  Output<MotelsEntity> validate() {
    if (name.isEmpty) {
      return failure(ValidationException(message: 'Motel sem nome'));
    }
    if (logo.validate().isLeft) {
      return logo.validate().map((r) => this);
    }
    if (motelRooms.isEmpty) {
      return failure(ValidationException(
          message: 'Motel não possui quartos no seu catalogo'));
    }
    for (var room in motelRooms) {
      if (room.validate().isLeft) {
        return room.validate().map((r) => this);
      }
    }
    return success(this);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'logo': logo.toMap(),
      'neighborhood': neighborhood,
      'motelRooms': motelRooms.map((x) => x.toMap()).toList(),
    };
  }

  factory MotelsEntity.fromMap(Map<String, dynamic> map) {
    return MotelsEntity(
      name: map['name'] ?? '',
      logo: UrlImagemVo.fromMap(map['logo']),
      neighborhood: map['neighborhood'] ?? '',
      motelRooms: List<RoomsEntity>.from(
          map['motelRooms']?.map((x) => RoomsEntity.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory MotelsEntity.fromJson(String source) =>
      MotelsEntity.fromMap(json.decode(source));
}
