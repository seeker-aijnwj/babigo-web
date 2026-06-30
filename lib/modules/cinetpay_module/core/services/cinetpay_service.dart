import 'package:dio/dio.dart';

/// ============================================================================
/// CINETPAY SERVICE
/// ============================================================================
///
/// Service principal de communication avec CinetPay.
///
/// ============================================================================

class CinetPayService {

  final Dio dio = Dio();

  /// INITIALISER UN PAIEMENT
  Future<Response> initializePayment({
    required Map<String, dynamic> payload,
  }) async {

    try {

      final response = await dio.post(
        "https://api-checkout.cinetpay.com/v2/payment",
        data: payload,
      );

      return response;

    } catch (e) {

      rethrow;
    }
  }

  /// VÉRIFIER LE STATUT
  Future<Response> checkPaymentStatus({
    required String transactionId,
  }) async {

    try {

      final response = await dio.post(
        "https://api-checkout.cinetpay.com/v2/payment/check",
        data: {
          "apikey": "VOTRE_API_KEY",
          "site_id": 000000,
          "transaction_id": transactionId,
        },
      );

      return response;

    } catch (e) {

      rethrow;
    }
  }
}