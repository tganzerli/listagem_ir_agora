import 'dart:convert';

import 'package:lista_ir_agora/core/core.dart';

class CategoryItemsDto extends DTO {
  final String name;
  final UrlImagemVo icon;

  CategoryItemsDto({required this.name, required this.icon});

  @override
  Output<CategoryItemsDto> validate() {
    if (name.isEmpty) {
      return failure(
          ValidationException(message: 'Categoria de itens sem nome'));
    }
    if (icon.validate().isLeft) {
      return icon.validate().map((r) => this);
    }

    return success(this);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'icon': icon.toMap(),
    };
  }

  factory CategoryItemsDto.fromMap(Map<String, dynamic> map) {
    return CategoryItemsDto(
      name: map['name'] ?? '',
      icon: UrlImagemVo.fromMap(map['icon']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryItemsDto.fromJson(String source) =>
      CategoryItemsDto.fromMap(json.decode(source));
}
