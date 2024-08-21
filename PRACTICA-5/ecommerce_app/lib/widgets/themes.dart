import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;
  bool get isDarkMode {
    if (themeMode == ThemeMode.system) {
      final brightness = PlatformDispatcher.instance.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class ChangeThemeButton extends StatelessWidget {
  const ChangeThemeButton({super.key});
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return FlutterSwitch(
      width: 70,
      height: 45,
      toggleSize: 45.0,
      value: themeProvider.isDarkMode,
      borderRadius: 30.0,
      padding: 2.0,
      activeToggleColor: const Color(0xFF6E40C9),
      inactiveToggleColor: const Color(0xFF2F363D),
      activeSwitchBorder: Border.all(
        color: const Color(0xFF3C1E70),
        width: 6.0,
      ),
      inactiveSwitchBorder: Border.all(
        color: const Color(0xFFD1D5DA),
        width: 6.0,
      ),
      activeColor: const Color(0xFF271052),
      inactiveColor: Colors.white,
      activeIcon: const Icon(
        Icons.nightlight_round,
        color: Color(0xFFF8E3A1),
      ),
      inactiveIcon: const Icon(
        Icons.wb_sunny,
        color: Color(0xFFFFDF5D),
      ),
      onToggle: (val) {
        final provider = Provider.of<ThemeProvider>(context, listen: false);
        provider.toggleTheme(val);
      },
    );
  }
}

class Mytheme {
  static ThemeData lightTheme(BuildContext context) => ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: GoogleFonts.poppins().fontFamily,
        cardColor: Colors.white,
        canvasColor: creamColor,
        buttonTheme: ButtonThemeData(
          buttonColor: darkBluishColor,
          textTheme: ButtonTextTheme.primary,
        ),
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      );
  static ThemeData darkTheme(BuildContext context) => ThemeData(
        brightness: Brightness.dark,
        fontFamily: GoogleFonts.poppins().fontFamily,
        cardColor: const Color(0xff090B0F),
        canvasColor: darkColor,
        buttonTheme: ButtonThemeData(
          buttonColor: lightBluishColor,
          textTheme: ButtonTextTheme.primary,
        ),
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.white),
        ),
      );
  static Color creamColor = const Color(0xfff4f5fc);
  static Color darkBluishColor = const Color(0xff1a191c);
  static Color darkColor = const Color(0xff0F1014);
  static Color lightBluishColor = const Color(0xFF6E40C9);
}