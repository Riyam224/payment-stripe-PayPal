# Stripe & PayPal Payment Integration

A Flutter application demonstrating payment integration with both Stripe and PayPal payment gateways.

## Features

- **Stripe Payment Integration**: Secure credit card payments using Stripe
- **PayPal Payment Integration**: Alternative payment method via PayPal
- **BLoC State Management**: Clean architecture with flutter_bloc
- **Payment Intent Flow**: Secure server-side payment processing
- **Error Handling**: Comprehensive error handling for both payment methods
- **Success & Failure Feedback**: User-friendly feedback for payment outcomes

## Architecture

This project follows Clean Architecture principles with:

```
lib/
├── Features/
│   └── checkout/
│       ├── data/
│       │   ├── models/          # Payment models
│       │   └── repos/           # Repository implementations
│       ├── domain/
│       │   └── repos/           # Repository interfaces
│       └── presentation/
│           ├── manager/         # BLoC/Cubit state management
│           ├── views/           # UI screens
│           └── widgets/         # Reusable widgets
└── core/
    ├── api_keys/               # API configuration
    ├── utils/                  # Utilities and helpers
    └── widgets/                # Shared widgets
```

## Dependencies

```yaml
dependencies:
  flutter_stripe: ^12.1.0
  flutter_paypal_payment: ^1.0.8
  flutter_bloc: ^9.1.1
  dio: ^5.9.0
  dartz: ^0.10.1
  flutter_credit_card: ^4.1.0
```

## Setup Instructions

### 1. Clone the Repository

```bash
git clone <your-repo-url>
cd stripe_paypal_payment
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Configure API Keys

Create or update the `lib/core/api_keys/api_keys.dart` file:

```dart
class ApiKeys {
  // Stripe API Keys
  static String stripePublishableKey = "YOUR_STRIPE_PUBLISHABLE_KEY";
  static String secretKey = "YOUR_STRIPE_SECRET_KEY";

  // PayPal API Keys
  static String paypalClientId = "YOUR_PAYPAL_CLIENT_ID";
  static String paypalSecretKey = "YOUR_PAYPAL_SECRET_KEY";
}
```

**Important**: Never commit your actual API keys to version control. Consider using environment variables or a secure configuration management system for production.

### 4. Get Your API Keys

#### Stripe:
1. Go to [Stripe Dashboard](https://dashboard.stripe.com/)
2. Navigate to Developers > API Keys
3. Copy your Publishable key and Secret key
4. Use test keys (starting with `pk_test_` and `sk_test_`) for development

#### PayPal:
1. Go to [PayPal Developer Dashboard](https://developer.paypal.com/dashboard/)
2. Navigate to Apps & Credentials
3. Create a new app or use an existing one
4. Copy your Client ID and Secret
5. Use Sandbox credentials for development

### 5. Initialize Stripe

The app initializes Stripe on startup. Make sure to configure it in your main app:

```dart
await Stripe.instance.applySettings(
  publishableKey: ApiKeys.stripePublishableKey,
  merchantIdentifier: 'merchant.identifier',
);
```

## Payment Flow

### Stripe Payment Flow

1. User enters credit card details
2. App creates a payment intent on the backend
3. Card information is tokenized securely
4. Payment is confirmed with Stripe
5. User receives success/failure feedback

### PayPal Payment Flow

1. User selects PayPal payment option
2. App opens PayPal checkout webview
3. User logs in and approves payment
4. PayPal processes the transaction
5. App receives payment confirmation
6. User receives success/failure feedback

## Key Components

### Payment Cubit
- Manages payment state (loading, success, failure)
- Handles Stripe payment intent creation
- Processes payment confirmation

### Custom Button BLoC Consumer
- Integrates both Stripe and PayPal payments
- Handles payment callbacks
- Manages navigation based on payment outcome

### Payment Models
- `PaymentIntentInputModel`: Structure for creating payment intents
- `PaymentIntentModel`: Stripe payment intent response
- `InitPaymentSheetInputModel`: Stripe payment sheet configuration

## Usage Example

### Stripe Payment

```dart
BlocProvider.of<PaymentCubit>(context).makePayment(
  paymentIntentInputModel: PaymentIntentInputModel(
    amount: '100', // Amount in cents
    currency: 'USD',
    customerId: 'customer_id',
  ),
);
```

### PayPal Payment

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => PaypalCheckoutView(
      sandboxMode: true,
      clientId: ApiKeys.paypalClientId,
      secretKey: ApiKeys.paypalSecretKey,
      transactions: [
        {
          "amount": {
            "total": '100.00',
            "currency": "USD",
          },
          "description": "Payment description",
        }
      ],
      onSuccess: (params) {
        // Handle success
      },
      onError: (error) {
        // Handle error
      },
      onCancel: () {
        // Handle cancellation
      },
    ),
  ),
);
```

## Testing

### Stripe Test Cards

- **Success**: 4242 4242 4242 4242
- **Declined**: 4000 0000 0000 0002
- **Requires Authentication**: 4000 0027 6000 3184

Use any future expiration date and any 3-digit CVC.

### PayPal Sandbox

Use PayPal Sandbox accounts for testing. Create test accounts in the [PayPal Developer Dashboard](https://developer.paypal.com/dashboard/).

## Security Best Practices

1. **Never expose API keys** in your repository
2. **Use environment variables** for production
3. **Implement server-side validation** for payment intents
4. **Use HTTPS** for all API communications
5. **Validate payment amounts** on the backend
6. **Handle errors gracefully** and log securely

## Troubleshooting

### Common Issues

**Stripe initialization fails:**
- Verify your publishable key is correct
- Ensure Stripe.instance.applySettings() is called before making payments

**PayPal payment doesn't open:**
- Check your Client ID and Secret Key
- Ensure sandboxMode is set to true for testing
- Verify internet connectivity

**Payment intent creation fails:**
- Validate your secret key
- Check amount format (should be in cents for Stripe)
- Ensure currency code is valid

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is created for educational purposes as part of Flutter Mentorship Week 9.

## Resources

- [Stripe Flutter SDK Documentation](https://pub.dev/packages/flutter_stripe)
- [PayPal Flutter SDK Documentation](https://pub.dev/packages/flutter_paypal_payment)
- [Flutter BLoC Documentation](https://pub.dev/packages/flutter_bloc)
- [Clean Architecture in Flutter](https://resocoder.com/flutter-clean-architecture-tdd/)

## Support

For issues and questions, please create an issue in the repository.
