// lib/app/services/deusx_provider.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:crypto_payment_app/app/services/payment_provider.dart';

class DeusXProvider implements IPaymentProvider {
  @override
  String get name => 'DeusX';
  @override
  String get logoAsset => 'assets/logos/deusx.png'; // We'll add this asset

  final String _apiKey = dotenv.env['DEUSX_API_KEY']!; // Assumes DeusX also uses an API key

  @override
  Future<PaymentUrlResult> createPaymentUrl({
    required double fiatAmount,
    required String fiatCurrency,
    required String cryptoCurrency,
    required String chain,
    required String walletAddress,
  }) async {
    // DeusX might use a different URL structure and parameter names
    final url = 'https://pay.deusxpay.com/v1/hosted'
        '?apiKey=$_apiKey'
        '&to=${cryptoCurrency.toUpperCase( )}'
        '&network=$chain'
        '&amount=${fiatAmount.toString()}'
        '&currency=${fiatCurrency.toUpperCase()}'
        '&recipient=$walletAddress';

    return PaymentUrlResult(url: url);
  }
}
