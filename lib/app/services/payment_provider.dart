// lib/app/services/payment_provider.dart

// A data class to hold the result of building a payment URL
class PaymentUrlResult {
  final String url;
  // You could add more provider-specific data here if needed
  PaymentUrlResult({required this.url});
}

// The abstract interface for all payment providers
abstract class IPaymentProvider {
  String get name; // e.g., "MoonPay"
  String get logoAsset; // e.g., 'assets/logos/moonpay.png'

  // The core method that generates the payment URL
  Future<PaymentUrlResult> createPaymentUrl({
    required double fiatAmount,
    required String fiatCurrency,
    required String cryptoCurrency,
    required String chain,
    required String walletAddress,
  });
}
