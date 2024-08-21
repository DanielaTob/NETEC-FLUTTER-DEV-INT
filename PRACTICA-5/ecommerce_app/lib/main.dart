import 'package:ecommerce_app/core/store.dart';
import 'package:ecommerce_app/pages/cart_page.dart';
import 'package:ecommerce_app/pages/home_page.dart';
import 'package:ecommerce_app/utils/routes.dart';
import 'package:ecommerce_app/widgets/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

void main() {
  runApp(
    VxState(
      store: MyStore(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode,
          theme: Mytheme.lightTheme(context),
          darkTheme: Mytheme.darkTheme(context),
          initialRoute: "/",
          routes: {
            "/": (context) => const HomePage(),
            MyRoutes.homeRoute: (context) => const HomePage(),
            MyRoutes.cartRoute: (context) => const CartPage(),
          },
        );
      },
    );
  }
}