import 'package:ecommerce_app/core/payment_configurations.dart';
import 'package:ecommerce_app/core/store.dart';
import 'package:ecommerce_app/models/cart.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:velocity_x/velocity_x.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: context.canvasColor,
      body: Column(
        children: [
          Text(
            'Cart',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: context.theme.colorScheme.secondary,
            ),
          ),
          _CartListState().p16().expand(),
          const Divider(),
          _CartTotal(),
        ],
      ),
    );
  }
}

class _CartTotal extends StatelessWidget {
  final _paymentItems = <PaymentItem>[];
  @override
  Widget build(BuildContext context) {
    final CartModel? cart = (VxState.store as MyStore).cart;
    return SizedBox(
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          VxBuilder(
              builder: (context, dynamic store, _) {
                _paymentItems.add(
                  PaymentItem(
                    amount: cart!.totalPrice.toString(),
                    label: 'Total',
                    status: PaymentItemStatus.final_price,
                  ),
                );
                return '\$${cart.totalPrice}'
                    .text
                    .xl5
                    .color(context.accentColor)
                    .make();
              },
              mutations: const {RemoveMutation}),
          30.widthBox,
          Row(
            children: [
              ApplePayButton(
                paymentConfiguration:
                    PaymentConfiguration.fromJsonString(defaultApplePay),
                paymentItems: _paymentItems,
                width: 200,
                height: 50,
                style: ApplePayButtonStyle.black,
                type: ApplePayButtonType.buy,
                margin: const EdgeInsets.only(top: 15.0),
                onPaymentResult: (data) {
                  debugPrint('$data');
                },
                loadingIndicator: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              GooglePayButton(
                paymentConfiguration:
                    PaymentConfiguration.fromJsonString(defaultGooglePay),
                paymentItems: _paymentItems,
                width: 200,
                height: 50,
                type: GooglePayButtonType.pay,
                margin: const EdgeInsets.only(top: 15.0),
                onPaymentResult: (data) {
                  debugPrint('$data');
                },
                loadingIndicator: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _CartListState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    VxState.watch(context, on: [RemoveMutation]);
    final CartModel cart = (VxState.store as MyStore).cart!;
    return cart.items.isEmpty
        ? 'Nothing to show'.text.xl3.makeCentered()
        : ListView.builder(
            itemCount: cart.items.length,
            itemBuilder: (context, index) => ListTile(
              leading: const Icon(Icons.done),
              trailing: IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () => RemoveMutation(cart.items[index])),
              title: cart.items[index].name!.text.make(),
            ),
          );
  }
}