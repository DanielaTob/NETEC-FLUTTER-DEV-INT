import 'dart:async';
import 'package:card_swiper/swiper/utils/enums.dart';
import 'package:flutter/widgets.dart';

typedef CardSwiperOnSwipe = FutureOr<bool> Function(
  int previousIndex,
  int? currentIndex,
  CardSwipeDirection direction,
);
typedef CardSwiperOnSwipeUpdate = void Function(
  int? currentIndex,
  CardSwipeDirection direction,
);
typedef NullableCardBuilder = Widget? Function(
  BuildContext context,
  int index,
  int horizontalOffsetPercentage,
  int verticalOffsetPercentage,
);
typedef CardSwiperDirectionChange = void Function(
  CardSwipeDirection horizontalDirection,
);
typedef CardSwiperOnEnd = FutureOr<void> Function();