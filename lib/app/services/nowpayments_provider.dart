// lib/app/services/nowpayments_provider.dart
import 'dart:convert';
import 'package:crypto_payment_app/app/services/payment_provider.dart';
import 'package:http/http.dart' as http;

class NOWPaymentsProvider implements IPaymentProvider {
  @override
  String get name => 'NOWPayments (No-KYC )';
  @override
  String get logoAsset => 'assets/logos/nowpayments.png';

  // The URL of our Dart Frog backend. Use ngrok for testing.
  // In production, this would be your deployed server's URL.
  final String _backendUrl = 'https://<your-ngrok-url>.ngrok-free.app/create_invoice';

  @override
  Future<PaymentUrlResult> createPaymentUrl({
    required double fiatAmount,
    required String fiatCurrency,
    // These are less relevant for NOWPayments' invoice model but kept for interface consistency
    required String cryptoCurrency,
    required String chain,
    required String walletAddress,
  } ) async {
    try {
      final response = await http.post(
        Uri.parse(_backendUrl ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'amount': fiatAmount,
          'currency': fiatCurrency,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final paymentUrl = responseData['paymentUrl'];
        if (paymentUrl != null) {
          return PaymentUrlResult(url: paymentUrl);
        } else {
          throw Exception('Payment URL was null in the server response.');
        }
      } else {
        throw Exception('Failed to create invoice. Server responded with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error calling backend to create NOWPayments invoice: $e');
      throw Exception('Could not connect to payment server. Please try again later.');
    }
  }
}
   