import 'package:cloud_firestore/cloud_firestore.dart';

/// ============================================================================
/// PAYMENT TRANSACTION MODEL
/// ============================================================================
///
/// Représente une transaction financière.
///
/// ============================================================================

class PaymentTransaction {

  final String id;

  final String userId;

  final String tripId;
  
  final double amount;

  final String currency;

  final String paymentMethod;

  final String status;

  final String operatorName;

  final String phoneNumber;

  final String transactionId;

  final DateTime createdAt;

  final DateTime? paidAt;

  PaymentTransaction({
    required this.id,
    required this.userId,
    required this.tripId,
    required this.amount,
    required this.currency,
    required this.paymentMethod,
    required this.status,
    required this.operatorName,
    required this.phoneNumber,
    required this.transactionId,
    required this.createdAt,
    this.paidAt,
  });

  /// FROM FIRESTORE
  factory PaymentTransaction.fromFirestore(
    DocumentSnapshot doc,
  ) {

    final data = doc.data() as Map<String, dynamic>;

    return PaymentTransaction(
      id: doc.id,
      userId: data['userId'] ?? '',
      tripId: data['tripId'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      currency: data['currency'] ?? 'XOF',
      paymentMethod: data['paymentMethod'] ?? '',
      status: data['status'] ?? 'pending',
      operatorName: data['operatorName'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      transactionId: data['transactionId'] ?? '',
      createdAt:
          (data['createdAt'] as Timestamp).toDate(),
      paidAt: data['paidAt'] != null
          ? (data['paidAt'] as Timestamp).toDate()
          : null,
    );
  }

  /// TO JSON
  Map<String, dynamic> toJson() {

    return {
      'userId': userId,
      'tripId': tripId,
      'amount': amount,
      'currency': currency,
      'paymentMethod': paymentMethod,
      'status': status,
      'operatorName': operatorName,
      'phoneNumber': phoneNumber,
      'transactionId': transactionId,
      'createdAt': createdAt,
      'paidAt': paidAt,
    };
  }
}