import 'dart:math' as math;
import 'dart:ui';
import 'package:card_swiper/swiper/properties/properties.dart';
import 'package:card_swiper/swiper/utils/enums.dart';
import 'package:flutter/widgets.dart';

class CardAnimation {
  CardAnimation({
    required this.animationController,
    required this.initialScale,
    required this.initialOffset,
    this.isHorizontalSwipingEnabled = true,
    this.allowedSwipeDirection = const AllowedSwipeDirection.all(),
    this.onSwipeDirectionChanged,
  }) : scale = initialScale;
  final double initialScale;
  final Offset initialOffset;
  final AnimationController animationController;
  final bool isHorizontalSwipingEnabled;
  final AllowedSwipeDirection allowedSwipeDirection;
  final ValueChanged<CardSwipeDirection>? onSwipeDirectionChanged;
  double left = 0;
  double top = 0;
  double total = 0;
  double angle = 0;
  double scale;
  Offset difference = Offset.zero;
  late Animation<double> _leftAnimation;
  late Animation<double> _topAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _differenceAnimation;
  double get _maxAngleInRadian => 30 * (math.pi / 180);
  void sync() {
    left = _leftAnimation.value;
    top = _topAnimation.value;
    scale = _scaleAnimation.value;
    difference = _differenceAnimation.value;
  }

  void reset() {
    animationController.reset();
    left = 0;
    top = 0;
    total = 0;
    angle = 0;
    scale = initialScale;
    difference = Offset.zero;
  }

  void update(double dx, double dy, bool inverseAngle) {
    if (allowedSwipeDirection.right && left >= 0) {
      onSwipeDirectionChanged?.call(CardSwipeDirection.right);
      _addTrailLeft(dx);
    }
    if (allowedSwipeDirection.left && left <= 0) {
      onSwipeDirectionChanged?.call(CardSwipeDirection.left);
      _addTrailLeft(dx);
    }
    total = left + top;
    updateAngle(inverseAngle);
    updateScale();
    updateDifference();
  }

  void _addTrailLeft(double dx) {
    left += dx;
  }

  void updateAngle(bool inverse) {
    angle = clampDouble(
      _maxAngleInRadian * left / 1000,
      -_maxAngleInRadian,
      _maxAngleInRadian,
    );
    if (inverse) angle *= -1;
  }

  void updateScale() {
    scale = clampDouble(initialScale + (total.abs() / 5000), initialScale, 1.0);
  }

  void updateDifference() {
    final discrepancy = (total / 10).abs();
    var diffX = 0.0;
    var diffY = 0.0;
    if (initialOffset.dx > 0) {
      diffX = discrepancy;
    } else if (initialOffset.dx < 0) {
      diffX = -discrepancy;
    }
    if (initialOffset.dy < 0) {
      diffY = -discrepancy;
    } else if (initialOffset.dy > 0) {
      diffY = discrepancy;
    }
    difference = Offset(diffX, diffY);
  }

  void animate(BuildContext context, CardSwipeDirection direction) {
    return switch (direction) {
      CardSwipeDirection.left => animateHorizontally(context, false),
      CardSwipeDirection.right => animateHorizontally(context, true),
      CardSwipeDirection.none => null,
    };
  }

  void animateHorizontally(BuildContext context, bool isToRight) {
    final screenWidth = MediaQuery.of(context).size.width;
    _leftAnimation = Tween<double>(
      begin: left,
      end: isToRight ? screenWidth : -screenWidth,
    ).animate(animationController);
    _topAnimation = Tween<double>(
      begin: top,
      end: top + top,
    ).animate(animationController);
    _scaleAnimation = Tween<double>(
      begin: scale,
      end: 1.0,
    ).animate(animationController);
    _differenceAnimation = Tween<Offset>(
      begin: difference,
      end: initialOffset,
    ).animate(animationController);
    animationController.forward();
  }
}