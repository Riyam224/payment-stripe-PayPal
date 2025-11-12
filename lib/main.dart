import 'package:flutter/material.dart';
import 'package:stripe_paypal_payment/Features/checkout/presentation/views/my_cart_view.dart';
import 'package:stripe_paypal_payment/Features/checkout/presentation/views/payment_details.dart';

void main() {
  runApp(const CheckoutApp());
}

class CheckoutApp extends StatelessWidget {
  const CheckoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PaymentDetailsView(),
    );
  }
}
