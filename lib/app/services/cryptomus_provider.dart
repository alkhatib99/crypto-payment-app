// lib/app/services/moonpay_provider.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:crypto_payment_app/app/services/payment_provider.dart';

class CryptomusProvider implements IPaymentProvider {
  @override
  String get name => 'Cryptomus';
  @override
  String get logoAsset => 'assets/logos/cryptomus.png'; // We'll add this asset

  final String _apiKey = dotenv.env['Cryptomus_API_KEY']!;

  @override
  Future<PaymentUrlResult> createPaymentUrl({
    required double fiatAmount,
    required String fiatCurrency,
    required String cryptoCurrency,
    required String chain,
    required String walletAddress,
  }) async {
    // MoonPay uses specific codes like 'usdc_polygon'
    final moonpayCryptoCode = '${cryptoCurrency.toLowerCase()}_$chain'.toLowerCase();

    final url = 'https://buy.moonpay.com/'
        '?apiKey=$_apiKey'
        '&currencyCode=$moonpayCryptoCode'
        '&baseCurrencyCode=${fiatCurrency.toLowerCase( )}'
        '&baseCurrencyAmount=${fiatAmount.toString()}'
        '&walletAddress=$walletAddress';

    return PaymentUrlResult(url: url);
  }
}
