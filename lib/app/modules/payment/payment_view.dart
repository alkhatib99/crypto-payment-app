// lib/app/modules/payment/payment_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crypto_payment_app/app/modules/payment/payment_controller.dart';

class PaymentView extends GetView<PaymentController> {
  const PaymentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Secure Crypto Payment'),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Section 1: Provider Selection ---
            _buildSectionHeader(context, 'Choose Payment Gateway'),
            Obx(() => Wrap(
                  spacing: 12.0,
                  runSpacing: 12.0,
                  children: controller.availableProviders.map((provider) {
              final isSelected = controller.selectedProvider.value?.name == provider.name;
                    return GestureDetector(
                      onTap: () => controller.selectProvider(provider),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.deepPurple.withOpacity(0.1) : Colors.white,
                          border: Border.all(
                            color: isSelected ? Colors.deepPurple : Colors.grey[300]!,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: isSelected
                              ? [BoxShadow(color: Colors.deepPurple.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))]
                              : [],
                        ),
                        child: Image.asset(
                          provider.logoAsset,
                           height: 30,
                            fit: BoxFit.contain,
                            ),
                      ),
                    );
                  }).toList(),
                )),
            const SizedBox(height: 32),

            // --- Section 2: Amount Selection ---
            _buildSectionHeader(context, 'Select Amount (USD)'),
            GetBuilder<PaymentController>(
              builder: (_) => Wrap(
                spacing: 12.0,
                runSpacing: 12.0,
                children: controller.quickAmounts.map((amount) {
                  final isSelected = controller.selectedAmount.value == amount;
                  return ChoiceChip(
                    label: Text('\$${amount.toInt()}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black87)),
                    selected: isSelected,
                    onSelected: (_) => controller.selectQuickAmount(amount),
                    selectedColor: Colors.deepPurple,
                    backgroundColor: Colors.grey[200],
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: controller.customAmountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Or Enter Custom Amount',
                prefixIcon: Icon(Icons.edit),
              ),
              onChanged: controller.onCustomAmountChanged,
            ),
            const SizedBox(height: 32),

            // --- Section 3: Recipient Wallet ---
            // _buildSectionHeader(context, 'Recipient Wallet'),
            // TextField(
            //   controller: controller.walletAddressController,
            //   decoration: InputDecoration(
            //     labelText: 'Web3 Wallet Address',
            //     prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
            //     suffixIcon: IconButton(
            //       icon: const Icon(Icons.qr_code_scanner),
            //       onPressed: controller.openQrScanner,
            //       tooltip: 'Scan QR Code',
            //     ),
            //   ),
            // ),
            const SizedBox(height: 40),

            // --- Section 4: Pay Button ---
            Obx(() => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.isPaying.value ? null : controller.proceedToPay,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    child: controller.isPaying.value
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                          )
                        : const Text('Proceed to Pay', style: TextStyle(color: Colors.white)),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  /// Helper widget for creating consistent section headers.
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}
