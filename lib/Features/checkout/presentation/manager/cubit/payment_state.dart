part of 'payment_cubit.dart';

@immutable
sealed class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentSuccess extends PaymentState {}

class PaymentFailure extends PaymentState {
  final String errMessage;
  PaymentFailure(this.errMessage);
}
