import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewController extends GetxController {
  final RxBool isLoading = true.obs;
  late final WebViewController webViewController;

  @override
  void onInit() {
    super.onInit();
    // Retrieve arguments passed from the previous page
    final args = Get.arguments as Map<String, dynamic>;
    final walletAddress = args['walletAddress'];
    final fiatAmount = args['fiatAmount'];

    final moonPayUrl = _buildMoonPayUrl(walletAddress, fiatAmount);

    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) => isLoading.value = false,
        ),
      )
      ..loadRequest(Uri.parse(moonPayUrl));
  }

  String _buildMoonPayUrl(String walletAddress, double fiatAmount) {
    final apiKey = dotenv.env['MOONPAY_PUBLIC_KEY']!;
    return 'https://buy.moonpay.com/'
        '?apiKey=$apiKey'
        '&currencyCode=usdc_polygon'
        '&baseCurrencyCode=usd'
        '&baseCurrencyAmount=${fiatAmount.toString( )}'
        '&walletAddress=$walletAddress';
  }
}
