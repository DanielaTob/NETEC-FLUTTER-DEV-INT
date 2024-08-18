import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.index,
  });
  final int index;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return LayoutBuilder(builder: (context, constraints) {
      return Align(
        alignment: Alignment.center,
        child: Container(
          width:
              constraints.maxWidth >= 900 ? size.width * .5 : size.width * 0.9,
          height: size.height * 0.9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: getColorBasedOnNumber(index),
          ),
          child: Center(
            child: Text(
              index.toString(),
              style: const TextStyle(
                fontSize: 50,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    });
  }
}

Color getColorBasedOnNumber(int number) {
  List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
  ];
  int index = number % colors.length;
  return colors[index];
}