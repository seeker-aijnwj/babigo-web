import '../providers/payment_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'payment_webview_screen.dart';

/// ============================================================================
/// PAYMENT PAGE
/// ============================================================================
///
/// Interface principale de paiement.
///
/// ============================================================================

class PaymentScreen extends StatefulWidget {

  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() =>
      _PaymentScreenState();
}

class _PaymentScreenState
    extends State<PaymentScreen> {

  final TextEditingController amountController =
      TextEditingController();

  final TextEditingController phoneController =
      TextEditingController();

  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController emailController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {

    final provider =
        Provider.of<PaymentProvider>(context);

    return Scaffold(

      appBar: AppBar(
        title: const Text("Paiement"),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            /// NOM
            TextField(
              controller: nameController,
            ),

            const SizedBox(height: 16),

            /// MONTANT
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Montant",
              ),
            ),

            const SizedBox(height: 30),

            /// BOUTON PAYER
            SizedBox(

              width: double.infinity,

              height: 55,

              child: ElevatedButton(

                onPressed: provider.isLoading
                    ? null
                    : () async {

                        await provider.pay(
                          amount: double.parse(
                            amountController.text,
                          ),
                          customerName:
                              nameController.text,
                          customerPhone:
                              phoneController.text,
                          customerEmail:
                              emailController.text,
                        );

                        if (provider.paymentUrl != null) {

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  PaymentWebViewScreen(
                                url: provider.paymentUrl!,
                              ),
                            ),
                          );
                        }
                      },

                child: provider.isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                        "PAYER MAINTENANT",
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}