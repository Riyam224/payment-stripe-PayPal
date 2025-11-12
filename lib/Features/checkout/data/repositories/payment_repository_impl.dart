import 'package:dartz/dartz.dart';
import 'package:stripe_paypal_payment/Features/checkout/data/models/payment_intent_input_model.dart';
import 'package:stripe_paypal_payment/Features/checkout/domain/repositories/payment_repository.dart';
import 'package:stripe_paypal_payment/core/error/exceptions.dart';

import 'package:stripe_paypal_payment/core/utils/stripe_service.dart';

class PaymentRepositoryImpl extends PaymentRepository {
  final StripeService stripeService = StripeService();
  @override
  Future<Either<Failure, void>> makePayment({
    required PaymentIntentInputModel paymentIntentInputModel,
  }) async {
    try {
      stripeService.makePayment(
        paymentIntentInputModel: paymentIntentInputModel,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(errMessage: e.toString()));
    }
  }
}
