part of 'card_swiper.dart';

class _CardSwiperState<T extends Widget> extends State<CardSwiper>
    with SingleTickerProviderStateMixin {
  late CardAnimation _cardAnimation;
  late AnimationController _animationController;

  SwipeType _swipeType = SwipeType.none;
  CardSwipeDirection _detectedDirection = CardSwipeDirection.none;
  CardSwipeDirection _detectedHorizontalDirection = CardSwipeDirection.none;

  final _cacheIndex = CacheState<int?>(null);
  final Queue<CardSwipeDirection> _directionHistory = Queue();

  int? get _currentIndex => _cacheIndex.state;
  int? get _nextIndex => getValidIndexOffset(1);
  bool get _canSwipe => _currentIndex != null && !widget.isDisabled;

  @override
  void initState() {
    super.initState();
    _cacheIndex.state = widget.initialIndex;
    widget.controller?.events.listen(_controllerListener);
    _animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    )
      ..addListener(_animationListener)
      ..addStatusListener(_animationStatusListener);
    _cardAnimation = CardAnimation(
      animationController: _animationController,
      initialScale: widget.scale,
      allowedSwipeDirection: widget.allowedSwipeDirection,
      initialOffset: widget.backCardOffset,
      onSwipeDirectionChanged: onSwipeDirectionChanged,
    );
  }

  void onSwipeDirectionChanged(CardSwipeDirection direction) {
    _detectedHorizontalDirection = direction;
    widget.onSwipeDirectionChange?.call(_detectedHorizontalDirection);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Stack(
            clipBehavior: Clip.none,
            fit: StackFit.expand,
            children: List.generate(numberOfCardsOnScreen(), (index) {
              if (index == 0) return _frontItem(constraints);
              return _backItem(constraints, index);
            }).reversed.toList(),
          );
        },
      ),
    );
  }

  Widget _frontItem(BoxConstraints constraints) {
    return Positioned(
      left: _cardAnimation.left,
      top: _cardAnimation.top,
      child: GestureDetector(
        child: Transform.rotate(
          angle: _cardAnimation.angle,
          child: ConstrainedBox(
            constraints: constraints,
            child: Stack(
              children: [
                widget.cardBuilder(
                      context,
                      _currentIndex!,
                      (100 * _cardAnimation.left / widget.threshold).ceil(),
                      (100 * _cardAnimation.top / widget.threshold).ceil(),
                    ) ??
                    const SizedBox.shrink(),
              ],
            ),
          ),
        ),
        onPanUpdate: (tapInfo) {
          if (!widget.isDisabled) {
            setState(
              () => _cardAnimation.update(
                tapInfo.delta.dx,
                tapInfo.delta.dy,
                false,
              ),
            );
          }
        },
        onPanEnd: (tapInfo) {
          if (_canSwipe) {
            _onEndAnimation();
          }
        },
      ),
    );
  }

  Widget _backItem(BoxConstraints constraints, int index) {
    return Positioned(
      top: (widget.backCardOffset.dy * index) - _cardAnimation.difference.dy,
      left: (widget.backCardOffset.dx * index) - _cardAnimation.difference.dx,
      child: Transform.scale(
        scale: _cardAnimation.scale - ((1 - widget.scale) * (index - 1)),
        child: ConstrainedBox(
          constraints: constraints,
          child: widget.cardBuilder(context, getValidIndexOffset(index)!, 0, 0),
        ),
      ),
    );
  }

  void _controllerListener(ControllerEvent event) {
    return switch (event) {
      ControllerSwipeEvent(:final direction) => _swipe(direction),
      ControllerMoveEvent(:final index) => _moveTo(index),
    };
  }

  void _animationListener() {
    if (_animationController.status == AnimationStatus.forward) {
      setState(_cardAnimation.sync);
    }
  }

  Future<void> _animationStatusListener(AnimationStatus status) async {
    if (status == AnimationStatus.completed) {
      switch (_swipeType) {
        case SwipeType.swipe:
          await _handleCompleteSwipe();
        default:
          break;
      }
      _reset();
    }
  }

  Future<void> _handleCompleteSwipe() async {
    final isLastCard = _currentIndex! == widget.cardsCount - 1;
    final shouldCancelSwipe = await widget.onSwipe
            ?.call(_currentIndex!, _nextIndex, _detectedDirection) ==
        false;
    if (shouldCancelSwipe) {
      _swipeType = SwipeType.none;
      return;
    }
    _cacheIndex.state = _nextIndex;
    _directionHistory.add(_detectedDirection);
    if (isLastCard) {
      widget.onEnd?.call();
    }
  }

  void _reset() {
    onSwipeDirectionChanged(CardSwipeDirection.none);
    _detectedDirection = CardSwipeDirection.none;
    setState(() {
      _animationController.reset();
      _cardAnimation.reset();
      _swipeType = SwipeType.none;
    });
  }

  void _onEndAnimation() {
    final direction = _getEndAnimationDirection();
    final isValidDirection = _isValidDirection(direction);
    if (isValidDirection) {
      _swipe(direction);
    } else {
      _reset();
    }
  }

  CardSwipeDirection _getEndAnimationDirection() {
    if (_cardAnimation.left.abs() > widget.threshold) {
      return _cardAnimation.left.isNegative
          ? CardSwipeDirection.left
          : CardSwipeDirection.right;
    }
    return CardSwipeDirection.none;
  }

  bool _isValidDirection(CardSwipeDirection direction) {
    return switch (direction) {
      CardSwipeDirection.left => widget.allowedSwipeDirection.left,
      CardSwipeDirection.right => widget.allowedSwipeDirection.right,
      _ => false
    };
  }

  void _swipe(CardSwipeDirection direction) {
    if (_currentIndex == null) return;
    _swipeType = SwipeType.swipe;
    _detectedDirection = direction;
    _cardAnimation.animate(context, direction);
  }

  void _moveTo(int index) {
    if (index == _currentIndex) return;
    if (index < 0 || index >= widget.cardsCount) return;
    _cacheIndex.state = index;
  }

  int numberOfCardsOnScreen() {
    if (widget.isLoop) {
      return widget.numberOfCardsDisplayed;
    }
    if (_currentIndex == null) {
      return 0;
    }
    return math.min(
      widget.numberOfCardsDisplayed,
      widget.cardsCount - _currentIndex!,
    );
  }

  int? getValidIndexOffset(int offset) {
    if (_currentIndex == null) {
      return null;
    }
    final index = _currentIndex! + offset;
    if (!widget.isLoop && !index.isBetween(0, widget.cardsCount - 1)) {
      return null;
    }
    return index % widget.cardsCount;
  }
}