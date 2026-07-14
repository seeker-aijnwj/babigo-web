import 'package:cloud_firestore/cloud_firestore.dart';

/// ============================================================================
/// PAYMENT REPOSITORY
/// ============================================================================

class PaymentRepository {

  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  /// COLLECTION
  CollectionReference get transactionsRef =>
      firestore.collection('transactions');

  /// CREATE TRANSACTION
  Future<void> createTransaction({
    required Map<String, dynamic> data,
  }) async {

    await transactionsRef.add(data);
  }

  /// UPDATE STATUS
  Future<void> updateStatus({
    required String id,
    required String status,
  }) async {

    await transactionsRef.doc(id).update({
      'status': status,
    });
  }

  /// STREAM USER TRANSACTIONS
  Stream<QuerySnapshot> streamUserTransactions(
    String userId,
  ) {

    return transactionsRef
        .where('userId', isEqualTo: userId)
        .snapshots();
  }
}