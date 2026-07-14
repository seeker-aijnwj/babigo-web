import '../../core/services/cinetpay_service.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

/// ============================================================================
/// PAYMENT PROVIDER
/// ============================================================================
///
/// Gère :
///
/// - loading
/// - succès
/// - erreurs
/// - transaction
/// - état paiement
///
/// ============================================================================

class PaymentProvider extends ChangeNotifier {

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _error;

  String? get error => _error;

  String? _paymentUrl;

  String? get paymentUrl => _paymentUrl;


  /// PAYER
  Future<void> pay({
    required double amount,
    required String customerName,
    required String customerPhone,
    required String customerEmail,
  }) async {

    try {

      _isLoading = true;

      notifyListeners();

      final transactionId =
          const Uuid().v4();

      final payload = {
        "apikey": "VOTRE_API_KEY",
        "site_id": 000000,
        "transaction_id": transactionId,
        "amount": amount,
        "currency": "XOF",
        "description": "Paiement trajet BabiGO",
        "customer_name": customerName,
        "customer_email": customerEmail,
        "customer_phone_number": customerPhone,
        "channels": "ALL",
        "lang": "fr",
      };

      final response = await CinetPayService()
          .initializePayment(
        payload: payload,
      );

      _paymentUrl = response.data['data']['payment_url'];

    } catch (e) {

      _error = e.toString();

    } finally {

      _isLoading = false;

      notifyListeners();
    }
  }
}