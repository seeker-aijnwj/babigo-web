import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// ============================================================================
/// PAYMENT WEBVIEW
/// ============================================================================
///
/// Affiche l’interface de paiement CinetPay.
///
/// ============================================================================

class PaymentWebViewScreen extends StatefulWidget {

  final String url;

  const PaymentWebViewScreen({
    super.key,
    required this.url,
  });

  @override
  State<PaymentWebViewScreen> createState() =>
      _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState
    extends State<PaymentWebViewScreen> {

  late final WebViewController controller;

  @override
  void initState() {

    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(
        JavaScriptMode.unrestricted,
      )
      ..loadRequest(
        Uri.parse(widget.url),
      );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Paiement sécurisé",
        ),
      ),

      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}