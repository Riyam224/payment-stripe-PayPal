import 'package:dartz/dartz.dart';
import 'package:stripe_paypal_payment/Features/checkout/data/models/payment_intent_input_model.dart';
import 'package:stripe_paypal_payment/core/error/exceptions.dart';

abstract class PaymentRepository {
  Future<Either<Failure, void>> makePayment({
    required PaymentIntentInputModel paymentIntentInputModel,
  });
}
