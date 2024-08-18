import 'package:card_swiper/swiper/controller/swiper_controller.dart';
import 'package:card_swiper/swiper/widgets/card_swiper.dart';
import 'package:card_swiper/ui/custom_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static final CardController _swiperController = CardController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: CardSwiper(
            controller: _swiperController,
            numberOfCardsDisplayed: 2,
            padding: EdgeInsets.zero,
            onSwipe: (_, __, direction) {
              return true;
            },
            cardsCount: 5,
            cardBuilder:
                (context, index, percentThresholdX, percentThresholdY) {
              return CustomCard(index: index);
            },
          ),
        ),
      ),
    );
  }
}