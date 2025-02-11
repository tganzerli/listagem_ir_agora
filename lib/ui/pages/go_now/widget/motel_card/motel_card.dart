import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lista_ir_agora/core/config/injector.dart';
import 'package:lista_ir_agora/domain/entities/motels_entity.dart';
import 'package:lista_ir_agora/layout/layout.dart';

import 'room_card.dart';
import 'viewmodels/motel_card_viewmodels.dart';

class MotelCard extends StatefulWidget {
  final MotelsEntity motel;
  const MotelCard({super.key, required this.motel});

  @override
  State<MotelCard> createState() => _MotelCardState();
}

class _MotelCardState extends State<MotelCard> {
  MotelCardViewmodels viewmodel = injector.get<MotelCardViewmodels>();

  final ScrollController _scrollController = ScrollController();
  Timer? _snapTimer;
  double _cardWidth = 0;
  double _previousOffset = 0;

  void _onScroll() {
    double currentOffset = _scrollController.offset;
    bool isScrollingRight = currentOffset > _previousOffset;

    _previousOffset = currentOffset;

    _snapTimer?.cancel();
    _snapTimer = Timer(
        Duration(milliseconds: 80), () => _snapToNearestItem(isScrollingRight));
  }

  void _snapToNearestItem(bool isScrollingRight) {
    if (!_scrollController.hasClients || _cardWidth == 0) return;

    double currentOffset = _scrollController.offset;
    int index = (currentOffset / _cardWidth).round();

    viewmodel.setCardHeight.execute(widget.motel.motelRooms[index]);

    if (isScrollingRight) {
      index = (currentOffset / _cardWidth).ceil();
    } else {
      index = (currentOffset / _cardWidth).floor();
    }

    double targetOffset = index * _cardWidth;

    _scrollController.animateTo(
      targetOffset,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void initState() {
    super.initState();
    viewmodel.setCardHeight.execute(widget.motel.motelRooms.first);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    super.dispose();
    viewmodel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = AppSpacing.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: spacing.spacingSM,
      children: [
        SizedBox(height: spacing.spacingXS),
        _header(context),
        LayoutBuilder(
          builder: (context, constraints) {
            _cardWidth = constraints.maxWidth -
                (spacing.spacingLG * 2) +
                spacing.spacingXS;
            return ListenableBuilder(
              listenable: viewmodel.setCardHeight,
              builder: (context, _) {
                return SizedBox(
                  height: viewmodel.setCardHeight.rightResult ?? 434,
                  child: ListView.separated(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.motel.motelRooms.length,
                    padding:
                        EdgeInsets.symmetric(horizontal: spacing.spacingLG),
                    separatorBuilder: (context, index) =>
                        SizedBox(width: spacing.spacingXS),
                    itemBuilder: (context, index) => RoomCard(
                      room: widget.motel.motelRooms[index],
                      width: constraints.maxWidth - (spacing.spacingLG * 2),
                    ),
                  ),
                );
              },
            );
          },
        ),
        SizedBox(
          height: spacing.spacingXXL,
        )
      ],
    );
  }

  Widget _header(BuildContext context) {
    final colors = AppColors.of(context);
    final spacing = AppSpacing.of(context);
    final text = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: spacing.spacingXL),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: spacing.spacingXS,
        children: [
          ClipOval(
            child: Image.network(
              widget.motel.logo.value,
              width: 32,
              height: 32,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.motel.name,
                  style: text.titleLarge,
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.fade,
                ),
                Text(
                  widget.motel.neighborhood,
                  style: text.titleMedium,
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.fade,
                ),
                SizedBox(height: spacing.spacingXXS),
                Row(
                  spacing: spacing.spacingXS,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(spacing.spacingXXS),
                          border: Border.all(color: colors.highlightYellow)),
                      child: Row(
                        spacing: spacing.spacingXXS,
                        children: [
                          Icon(
                            Icons.star_rate_rounded,
                            color: colors.highlightYellow,
                            size: 12,
                          ),
                          Text(
                            '4.5',
                            style: text.headlineSmall!,
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '940 avaliações',
                          style: text.headlineSmall!,
                        ),
                        Icon(
                          Icons.expand_more,
                          size: 14,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(
            Icons.favorite_outlined,
            size: 28,
          ),
        ],
      ),
    );
  }
}
