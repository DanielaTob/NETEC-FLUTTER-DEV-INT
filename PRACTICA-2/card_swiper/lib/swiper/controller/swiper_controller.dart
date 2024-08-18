import 'dart:async';
import 'package:card_swiper/swiper/controller/controller_events.dart';
import 'package:card_swiper/swiper/utils/enums.dart';

/// A controller can be used to swipe the card to a specific direction or to a specific index.
class CardController {
  final _eventController = StreamController<ControllerEvent>.broadcast();

  /// Stream of events that can be used to swipe the card.
  Stream<ControllerEvent> get events => _eventController.stream;

  /// Swipe the card to a specific direction.
  void swipe(CardSwipeDirection direction) {
    _eventController.add(ControllerSwipeEvent(direction));
  }

// Change the top card to a specific index.
  void moveTo(int index) {
    _eventController.add(ControllerMoveEvent(index));
  }

  Future<void> dispose() async {
    await _eventController.close();
  }
}