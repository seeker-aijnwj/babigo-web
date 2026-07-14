import 'package:cloud_firestore/cloud_firestore.dart';

/// ============================================================================
/// WALLET SERVICE
/// ============================================================================

class WalletService {

  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  /// CREDITER WALLET
  Future<void> creditWallet({
    required String walletId,
    required double amount,
  }) async {

    await firestore
        .collection('wallets')
        .doc(walletId)
        .update({

      'balance': FieldValue.increment(amount),
    });
  }

  /// DÉBITER WALLET
  Future<void> debitWallet({
    required String walletId,
    required double amount,
  }) async {

    await firestore
        .collection('wallets')
        .doc(walletId)
        .update({

      'balance': FieldValue.increment(-amount),
    });
  }
}