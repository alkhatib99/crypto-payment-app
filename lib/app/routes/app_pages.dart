import 'package:crypto_payment_app/app/modules/payment/payment_binding.dart';
import 'package:crypto_payment_app/app/modules/qr_scanner/qr_scanner_view.dart';
import 'package:get/get.dart';
import 'package:crypto_payment_app/app/modules/payment/payment_view.dart';
import 'package:crypto_payment_app/app/modules/webview/webview_view.dart';
import 'package:crypto_payment_app/app/modules/webview/webview_binding.dart';
import 'package:crypto_payment_app/app/routes/app_routes.dart';

class AppPages {
  static const INITIAL = AppRoutes.initial;
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.payment,
      page: () => const PaymentView(),
      binding: PaymentBinding(),
    ),
    GetPage(
      name: AppRoutes.qrScanner,
      page: () => const QrScannerView(),
      // No controller/binding needed for this simple view
    ),
    GetPage(
      name: AppRoutes.webview,
      page: () => const WebviewView(),
      binding: WebviewBinding(),
    ),
  ];
}
