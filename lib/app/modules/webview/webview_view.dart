import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:crypto_payment_app/app/modules/webview/webview_controller.dart';

class WebviewView extends GetView<WebviewController> {
  const WebviewView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete Payment')),
      body: Obx(() => Stack(
            children: [
              WebViewWidget(controller: controller.webViewController),
              if (controller.isLoading.value)
                const Center(child: CircularProgressIndicator()),
            ],
          )),
    );
  }
}
