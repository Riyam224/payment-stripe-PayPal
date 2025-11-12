import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stripe_paypal_payment/Features/checkout/data/models/payment_intent_input_model.dart';
import 'package:stripe_paypal_payment/Features/checkout/presentation/manager/cubit/payment_cubit.dart';
import 'package:stripe_paypal_payment/Features/checkout/presentation/views/thank_you_view.dart';
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
            PaymentIntentInputModel paymentIntentInputModel =
                PaymentIntentInputModel(
                  amount: '100',
                  currency: 'USD',
                  // todo
                  customerId: 'cus_MxRZK5fjzSg6Ej',
                );
            context.read<PaymentCubit>().makePayment(
              paymentIntentInputModel: paymentIntentInputModel,
            );
          },
          isLoading: state is PaymentLoading,
          text: 'Continue',
        );
      },
    );
  }
}
