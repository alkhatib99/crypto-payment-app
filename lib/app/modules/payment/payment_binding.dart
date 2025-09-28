import 'package:get/get.dart';
import 'package:crypto_payment_app/app/modules/payment/payment_controller.dart';

class PaymentBinding extends Bindings {
  @override
  void dependencies() {
    // Lazily inject PaymentController. It will be created when first needed.
    Get.lazyPut<PaymentController>(() => PaymentController());
  }
}
