
import 'package:get/get.dart';
import 'package:crypto_payment_app/app/modules/webview/webview_controller.dart';

class WebviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WebviewController>(() => WebviewController());
  }
}
