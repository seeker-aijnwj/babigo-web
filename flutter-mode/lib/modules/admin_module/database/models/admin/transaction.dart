/*
{
  "id": "TX_001",
  "userId": "USER_001",
  "tripId": "TRIP_001",
  "amount": 5000,
  "currency": "XOF",
  "status": "success",
  "paymentMethod": "Orange Money",
  "operatorName": "Orange",
  "transactionId": "CP_123456",
  "phoneNumber": "+2250700000000",
  "createdAt": "timestamp"
} */

import 'package:cloud_firestore/cloud_firestore.dart';

class AppTransaction {

  /// Identifiant de la transaction
  String id;

  /// Identifiant de la course
  String tripId;

  /// Identifiant du propriétaire du compte
  String userId;

  /// Montant de la transaction
  int amount;

  /// Date de la transaction
  DateTime createdAt;

  /// Clé d'idempotence
  String idempotencyKey;

  /// Fournisseur
  String provider;

  /// Référence du fournisseur
  String providerRef;

  /// Motif de la transaction :
  /// TOPUP_CINETPAY | WALLET_SEED | ANNOUNCE_FEE,
  String reason;

  /// Etat de la transaction :
  /// SUCCEEDED, SIMULATED,
  String status;

  /// Type de la transaction :
  /// DEBIT (Dépot), CREDIT (Retrait)
  String type;

  AppTransaction({
    required this.id,
    required this.tripId,
    required this.userId,
    required this.amount,
    required this.createdAt,
    required this.idempotencyKey,
    required this.provider,
    required this.providerRef,
    required this.reason,
    required this.status,
    required this.type,
  });

  /// =============================================================
  /// EMPTY
  /// =============================================================
  factory AppTransaction.empty() {

    return AppTransaction(

        id: '',

        tripId: '',

        userId: '',

        amount: 0,

        createdAt: DateTime.now(),

        idempotencyKey: '',

        provider: '',

        providerRef: '',

        reason: '',

        status: '',

        type: ''

    );
  }


  /// =============================================================
  /// FROM JSON
  /// =============================================================
  factory AppTransaction.fromJson(
      Map<String, dynamic> json,
      ) {

    return AppTransaction(

      id: json['id'] ?? '',

      tripId: json['tripId'] ?? '',

      userId: json['userId'] ?? '',

      amount: json['amount'] ?? 0,

      type: json['type'] ?? 'CREDIT',

      createdAt:
        (json['createdAt'] as Timestamp?)
            ?.toDate() ??
            DateTime.now(),

      idempotencyKey: json['idempotencyKey'] ?? '',

      provider: json['provider'] ?? 'cinetpay',

      providerRef: json['providerRef'] ?? '',

      reason: json['reason'] ?? 'TOPUP_CINETPAY',

      status: json['status'] ?? 'SIMULATED',

    );
  }

  /// =============================================================
  /// GET NOTIFICATION FROM FIRESTORE
  /// =============================================================
  factory AppTransaction.getTransactionData(DocumentSnapshot doc) {

    final data = doc.data() as Map<String, dynamic>;

    return AppTransaction(

      id: doc.id,

      tripId: data['tripId'] ?? '',

      userId: data['userId'] ?? '',

      amount: data['amount'] ?? 0,

      type: data['type'] ?? 'CREDIT',

      createdAt: (data['createdAt'] as Timestamp?)
          ?.toDate() ??
          DateTime.now(),

      idempotencyKey: data['idempotencyKey'] ?? '',

      provider: data['provider'] ?? 'cinetpay',

      providerRef: data['providerRef'] ?? '',

      reason: data['reason'] ?? 'TOPUP_CINETPAY',

      status: data['status'] ?? 'SIMULATED',

    );
  }




  /// =============================================================
  /// TO JSON
  /// =============================================================

  Map<String, dynamic> toJson() {

    return {

      'id': id,

      'tripId': tripId,

      'userId': userId,

      'amount': amount,

      'type': type,

      'createdAt': Timestamp.fromDate(createdAt),

      'idempotencyKey': idempotencyKey ,

      'provider': provider,

      'providerRef': providerRef,

      'reason': reason,

      'status': status,

    };
  }

  /// =============================================================
  /// COPY WITH
  /// =============================================================

  AppTransaction copyWith({

    String? tripId,

    String? userId,

    DateTime? createdAt,

    DateTime? updatedAt,

    int? amount,

    String? idempotencyKey,

    String? provider,

    String? providerRef,

    String? reason,

    String? status,

    String? type,

  }) {

    return AppTransaction(

      id: id,

      tripId: tripId ?? this.tripId,

      userId: userId ?? this.userId,

      createdAt: createdAt ?? this.createdAt,

      amount: amount ?? this.amount,

      idempotencyKey: idempotencyKey ?? this.idempotencyKey,

      provider: provider ?? this.provider,

      providerRef: providerRef ?? this.providerRef,

      reason: reason ?? this.reason,

      status: status ?? this.status,

      type: type ?? this.type,

    );
  }


}
