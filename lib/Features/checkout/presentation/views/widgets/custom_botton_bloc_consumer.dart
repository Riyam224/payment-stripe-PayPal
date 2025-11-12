import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:stripe_paypal_payment/Features/checkout/data/models/payment_intent_input_model.dart';
import 'package:stripe_paypal_payment/Features/checkout/presentation/manager/cubit/payment_cubit.dart';
import 'package:stripe_paypal_payment/Features/checkout/presentation/views/thank_you_view.dart';
import 'package:stripe_paypal_payment/core/api_keys/api_keys.dart';
import 'package:stripe_paypal_payment/core/widgets/custom_button.dart';

class CustomButtonBlocConsumer extends StatelessWidget {
  const CustomButtonBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentCubit, PaymentState>(
      listener: (context, state) {
        if (state is PaymentSuccess) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return const ThankYouView();
              },
            ),
          );
        }
        if (state is PaymentFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errMessage)));
        }
      },
      builder: (context, state) {
        return CustomButton(
          onTap: () {
            _executePayPalPayment(context);
          },
          isLoading: state is PaymentLoading,
          text: 'Continue',
        );
      },
    );
  }

  void _executePayPalPayment(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => PaypalCheckoutView(
          sandboxMode: true,
          clientId: ApiKeys.paypalClientId,
          secretKey: ApiKeys.paypalSecretKey,
          transactions: _getTransactions(),
          note: "Contact us for any questions on your order.",
          onSuccess: (Map params) async {
            debugPrint("PayPal Payment Success: $params");
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ThankYouView(),
              ),
            );
          },
          onError: (error) {
            debugPrint("PayPal Payment Error: $error");
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Payment failed: ${error.toString()}'),
                backgroundColor: Colors.red,
              ),
            );
          },
          onCancel: () {
            debugPrint('PayPal Payment Cancelled');
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Payment cancelled'),
                backgroundColor: Colors.orange,
              ),
            );
          },
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getTransactions() {
    return [
      {
        "amount": {
          "total": '70',
          "currency": "USD",
          "details": {
            "subtotal": '70',
            "shipping": '0',
            "shipping_discount": 0,
          },
        },
        "description": "Payment for your order - Apple and Pineapple",
        "item_list": {
          "items": [
            {
              "name": "Apple",
              "quantity": 4,
              "price": '5',
              "currency": "USD",
            },
            {
              "name": "Pineapple",
              "quantity": 5,
              "price": '10',
              "currency": "USD",
            },
          ],
        },
      },
    ];
  }
}
