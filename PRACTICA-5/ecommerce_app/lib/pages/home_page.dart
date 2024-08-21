import 'dart:convert';
import 'package:ecommerce_app/core/store.dart';
import 'package:ecommerce_app/models/cart.dart';
import 'package:ecommerce_app/models/catelog.dart';
import 'package:ecommerce_app/utils/routes.dart';
import 'package:ecommerce_app/widgets/home_widgets/catelog_list.dart';
import 'package:ecommerce_app/widgets/home_widgets/catelog_header.dart';
import 'package:ecommerce_app/widgets/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    loadData();
    super.initState();
  }

  loadData() async {
    await Future.delayed(
      const Duration(seconds: 1),
    );
    final catelogJson = await rootBundle.loadString('assets/catalog.json');
    final decodedData = jsonDecode(catelogJson);
    var productsData = decodedData['products'];
    CatelogModel.items = List.from(productsData)
        .map<Item>((item) => Item.fromMap(item))
        .toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final cart = (VxState.store as MyStore).cart;
    return Scaffold(
      backgroundColor: context.canvasColor,
      floatingActionButton: VxBuilder(
        mutations: const {AddMutation, RemoveMutation},
        builder: (context, dynamic store, _) => FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, MyRoutes.cartRoute),
          child: const Icon(
            CupertinoIcons.cart,
            color: Colors.white,
          ),
        ).badge(
            color: Colors.white,
            size: 22,
            count: cart!.items.length,
            textStyle: TextStyle(
              color: Mytheme.darkBluishColor,
              fontWeight: FontWeight.bold,
            )),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CatelogHeader(),
              if (CatelogModel.items != null && CatelogModel.items!.isNotEmpty)
                const CatelogList().py16().expand()
              else
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}