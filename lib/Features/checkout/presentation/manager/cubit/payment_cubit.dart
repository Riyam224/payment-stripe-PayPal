// ignore_for_file: annotate_overrides

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stripe_paypal_payment/Features/checkout/data/models/payment_intent_input_model.dart';
import 'package:stripe_paypal_payment/Features/checkout/domain/repositories/payment_repository.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit(this.paymentRepository) : super(PaymentInitial());

  final PaymentRepository paymentRepository;

  Future<void> makePayment({
    required PaymentIntentInputModel paymentIntentInputModel,
  }) async {
    emit(PaymentLoading());
    try {
      var data = await paymentRepository.makePayment(
        paymentIntentInputModel: paymentIntentInputModel,
      );
      data.fold(
        (l) => emit(PaymentFailure(l.errMessage)),
        (r) => emit(PaymentSuccess()),
      );
    } catch (e) {
      emit(PaymentFailure(e.toString()));
    }
  }

  void onChange(Change<PaymentState> change) {
    log(change.toString());
    super.onChange(change);
  }
}
