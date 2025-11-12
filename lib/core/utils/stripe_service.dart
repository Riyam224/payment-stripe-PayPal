import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stripe_paypal_payment/Features/checkout/data/models/ephemeral_key_model/ephemeral_key_model.dart';
import 'package:stripe_paypal_payment/Features/checkout/data/models/init_payment_sheet_input_model.dart';
import 'package:stripe_paypal_payment/Features/checkout/data/models/payment_intent_input_model.dart';
import 'package:stripe_paypal_payment/Features/checkout/data/models/payment_intent_model/payment_intent_model.dart';
import 'package:stripe_paypal_payment/core/api_keys/api_keys.dart';
import 'package:stripe_paypal_payment/core/utils/api_service.dart';

class StripeService {
  final ApiService apiService = ApiService();

  Future<PaymentIntentModel> createPaymentIntent(
    PaymentIntentInputModel paymentIntentInputModel,
  ) async {
    var response = await apiService.post(
      body: paymentIntentInputModel.toJson(),
      url: 'https://api.stripe.com/v1/payment_intents',
      token: ApiKeys.secretKey,
      contentType: Headers.formUrlEncodedContentType,
    );

    final paymentIntentModel = PaymentIntentModel.fromJson(response.data);
    return paymentIntentModel;
  }

  Future initPaymentSheet({
    required Initpaymentsheetinputmodel initpaymentsheetinputmodel,
  }) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: initpaymentsheetinputmodel.clientSecret,
        merchantDisplayName: 'yoora',
        customerEphemeralKeySecret:
            initpaymentsheetinputmodel.ephemeralKeySecret,
        customerId: initpaymentsheetinputmodel.customerId,
      ),
    );
  }

  Future displayPaymentSheet() async {
    await Stripe.instance.presentPaymentSheet();
  }

  //  todo: make payment
  Future makePayment({
    required PaymentIntentInputModel paymentIntentInputModel,
  }) async {
    var paymentIntentModel = await createPaymentIntent(paymentIntentInputModel);
    var customer = await createCustomer(name: 'Customer');
    var ephemeralKey = await createEphemeralKey(customerId: customer['id']);

    var initPaymentSheetInputModel = Initpaymentsheetinputmodel(
      clientSecret: paymentIntentModel.clientSecret!,
      ephemeralKeySecret: ephemeralKey.secret!,
      customerId: customer['id'],
    );

    await initPaymentSheet(
      initpaymentsheetinputmodel: initPaymentSheetInputModel,
    );
    await displayPaymentSheet();
  }

  Future<Map<String, dynamic>> createCustomer({
    required String name,
    String? email,
  }) async {
    var response = await apiService.post(
      body: {'name': name, if (email != null) 'email': email},
      contentType: Headers.formUrlEncodedContentType,
      url: 'https://api.stripe.com/v1/customers',
      token: ApiKeys.secretKey,
    );

    return response.data;
  }

  Future<EphemeralKeyModel> createEphemeralKey({
    required String customerId,
  }) async {
    var response = await apiService.post(
      body: {'customer': customerId},
      contentType: Headers.formUrlEncodedContentType,
      url: 'https://api.stripe.com/v1/ephemeral_keys',
      token: ApiKeys.secretKey,
      headers: {
        'Authorization': 'Bearer ${ApiKeys.secretKey}',
        'Stripe-Version': '2023-08-16',
      },
    );

    var ephemeralKey = EphemeralKeyModel.fromJson(response.data);
    return ephemeralKey;
  }
}
