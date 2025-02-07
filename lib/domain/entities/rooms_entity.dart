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
}
