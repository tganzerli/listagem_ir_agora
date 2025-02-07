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
}
