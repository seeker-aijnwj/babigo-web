/// ============================================================================
/// CINETPAY PAYMENT REQUEST
/// ============================================================================

class CinetPayPaymentRequest {

  final String transactionId;

  final double amount;

  final String customerName;

  final String customerEmail;

  final String customerPhone;

  final String description;

  CinetPayPaymentRequest({
    required this.transactionId,
    required this.amount,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.description,
  });

  Map<String, dynamic> toJson() {

    return {
      "apikey": "VOTRE_API_KEY",
      "site_id": 000000,
      "transaction_id": transactionId,
      "amount": amount,
      "currency": "XOF",
      "description": description,
      "customer_name": customerName,
      "customer_email": customerEmail,
      "customer_phone_number": customerPhone,
      "channels": "ALL",
      "lang": "fr",
    };
  }
}