// lib/app/modules/payment/payment_controller.dart

import 'package:crypto_payment_app/app/services/cryptomus_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crypto_payment_app/app/routes/app_routes.dart';
import 'package:crypto_payment_app/app/services/payment_provider.dart';
import 'package:crypto_payment_app/app/services/moonpay_provider.dart';
import 'package:crypto_payment_app/app/services/deusx_provider.dart';
// Import other providers as you create them
// import 'package:crypto_payment_app/app/services/cryptomus_provider.dart';

class PaymentController extends GetxController {
  // --- UI STATE MANAGEMENT ---
  final walletAddressController = TextEditingController();
  final customAmountController = TextEditingController();
  final Rxn<double> selectedAmount = Rxn<double>();
  final RxBool isPaying = false.obs; // For loading indicator on the pay button

  // --- PROVIDER MANAGEMENT ---
  late final List<IPaymentProvider> availableProviders;
  late final Rx<IPaymentProvider> selectedProvider;

  // --- STATIC DATA ---
  final List<double> quickAmounts = [500, 1000, 2000, 3000, 5000];

  @override
  void onInit() {
    super.onInit();
    // Initialize all available payment providers
    availableProviders = [
      MoonPayProvider(),
      // DeusXProvider(),
      CryptomusProvider(),
      // Add new providers here once they are implemented
      // CryptomusProvider(),
      // FinRaxProvider(),
    ];
    // Set the first provider as the default selection
    selectedProvider = Rx<IPaymentProvider>(availableProviders.first);

    // Handle deep link parameters if they exist
    _handleDeepLinkParams();
  }

  void _handleDeepLinkParams() {
    final params = Get.parameters;
    if (params['recipient'] != null) {
      walletAddressController.text = params['recipient']!;
    }
    if (params['amount'] != null) {
      final amount = double.tryParse(params['amount']!);
      if (amount != null) {
        if (quickAmounts.contains(amount)) {
          selectedAmount.value = amount;
        } else {
          customAmountController.text = amount.toString();
        }
      }
    }
  }

  // --- BUSINESS LOGIC METHODS ---

  /// Sets the currently selected payment provider.
  void selectProvider(IPaymentProvider provider) {
    selectedProvider.value = provider;
  }

  /// Sets the payment amount from a quick-select chip.
  void selectQuickAmount(double amount) {
    // Toggle selection
    selectedAmount.value = (selectedAmount.value == amount) ? null : amount;
    if (selectedAmount.value != null) {
      customAmountController.clear();
    }
  }

  /// Handles changes to the custom amount text field.
  void onCustomAmountChanged(String value) {
    if (value.isNotEmpty) {
      selectedAmount.value = null; // Deselect any quick amount
    }
  }

  /// Navigates to the QR scanner screen and handles the returned result.
  void openQrScanner() async {
    final result = await Get.toNamed(AppRoutes.qrScanner);
    if (result != null && result is String) {
      // The result might be a complex URI (e.g., from a payment request),
      // so we parse it to find the address.
      final uri = Uri.tryParse(result);
      String address = result;
      if (uri != null && uri.scheme == 'ethereum') {
        address = uri.path; // Extract address from "ethereum:0x..."
      }
      // Basic validation for an address format
      if (address.startsWith('0x')) {
        walletAddressController.text = address;
      } else {
        Get.snackbar('Invalid QR Code', 'The scanned code does not contain a valid wallet address.');
      }
    }
  }

  /// Validates user input and initiates the payment flow with the selected provider.
  void proceedToPay() async {
    isPaying.value = true;

    final walletAddress = 
    final amount = selectedAmount.value ?? double.tryParse(customAmountController.text);

    // --- Input Validation ---
    if (walletAddress.isEmpty || !walletAddress.startsWith('0x') || walletAddress.length != 42) {
      Get.snackbar('Invalid Wallet Address', 'Please enter a valid 42-character wallet address starting with "0x".');
      isPaying.value = false;
      return;
    }

    if (amount == null || amount <= 0) {
      Get.snackbar('Invalid Amount', 'Please select or enter a valid payment amount.');
      isPaying.value = false;
      return;
    }

    try {
      // --- URL Generation via Selected Provider ---
      final result = await selectedProvider.value.createPaymentUrl(
        fiatAmount: amount,
        fiatCurrency: 'USD',
        cryptoCurrency: 'USDC',
        chain: 'Polygon',
        walletAddress: walletAddress,
      );

      // --- Navigation to WebView ---
      Get.toNamed(
        AppRoutes.webview,
        arguments: {
          'paymentUrl': result.url,
          'providerName': selectedProvider.value.name,
        },
      );
    } catch (e) {
      Get.snackbar('Error', 'Could not generate payment URL. Please try another provider or check your connection.');
      print("Error creating payment URL with ${selectedProvider.value.name}: $e");
    } finally {
      // Ensure the loading state is always reset
      isPaying.value = false;
    }
  }

  @override
  void onClose() {
    // Dispose text controllers to prevent memory leaks
    walletAddressController.dispose();
    customAmountController.dispose();
    super.onClose();
  }
}
