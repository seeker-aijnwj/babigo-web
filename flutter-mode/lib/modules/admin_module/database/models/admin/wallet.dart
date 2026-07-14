import 'package:cloud_firestore/cloud_firestore.dart';

class AppWallet {

  /// ===========================================================================
  /// IDENTIFIANT WALLET
  /// ===========================================================================

  String id;

  /// ===========================================================================
  /// DATES
  /// ===========================================================================

  DateTime createdAt;
  DateTime updatedAt;

  /// ===========================================================================
  /// DEVISE
  /// ===========================================================================

  WalletCurrency currency;

  /// ===========================================================================
  /// WALLET BLOQUÉ ?
  /// ===========================================================================

  int locked;

  /// ===========================================================================
  /// PROPRIÉTAIRE
  /// ===========================================================================

  String? userId;

  /// ===========================================================================
  /// SOLDE
  /// ===========================================================================

  double balance;

  /// ===========================================================================
  /// SOLDE GELÉ
  /// ===========================================================================

  double? frozenBalance;

  AppWallet({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.currency,
    required this.locked,
    required this.balance,
    this.frozenBalance,
    this.userId
  });

  /// =============================================================
  /// EMPTY
  /// =============================================================
  factory AppWallet.empty() {

    return AppWallet(

        id: '',

        currency: WalletCurrency.xof,

        createdAt: DateTime.now(),

        updatedAt: DateTime.now(),

        locked: 0,

        userId: '',

        balance: 0,

        frozenBalance: 0,

    );
  }


  /// =============================================================
  /// FROM JSON
  /// =============================================================
  factory AppWallet.fromJson(
      Map<String, dynamic> json,
      ) {

    return AppWallet(

      id: json['id'] ?? '',

      currency: json['currency'] ?? 'XOF',

      createdAt: (json['createdAt'] as Timestamp?)
          ?.toDate() ??
          DateTime.now(),

      updatedAt: (json['updatedAt'] as Timestamp?)
          ?.toDate() ??
          DateTime.now(),

      locked: json['locked'] ?? 0,

      userId: json['userId'] ?? '',

      balance: json['available'] ?? 0,

      frozenBalance: json['frozenBalance'] ?? 0,

    );
  }

  /// =============================================================
  /// GET NOTIFICATION FROM FIRESTORE
  /// =============================================================
  factory AppWallet.getWalletData(DocumentSnapshot doc) {

    final data = doc.data() as Map<String, dynamic>;

    return AppWallet(

      id: doc.id,

      currency: data['currency'] ?? 'XOF',

      createdAt: (data['createdAt'] as Timestamp?)
          ?.toDate() ??
          DateTime.now(),

      updatedAt: (data['updatedAt'] as Timestamp?)
          ?.toDate() ??
          DateTime.now(),

      locked: data['locked'] ?? 0,

      userId: data['userId'] ?? '',

      balance: data['available'] ?? 0,

      frozenBalance: data['frozenBalance'] ?? 0,

    );
  }




  /// =============================================================
  /// TO JSON
  /// =============================================================

  Map<String, dynamic> toJson() {

    return {

      'id': id,

      'currency': currency,

      'createdAt': Timestamp.fromDate(createdAt),

      'updatedAt': Timestamp.fromDate(updatedAt),

      'locked': locked,

      'userId': userId,

      'balance': balance,

      'frozenBalance': frozenBalance,

    };
  }

  /// =============================================================
  /// COPY WITH
  /// =============================================================

  AppWallet copyWith({

    int? available,

    WalletCurrency? currency,

    DateTime? createdAt,

    DateTime? updatedAt,

    int? locked,

    String? userId,

    double? balance,

    double? frozenBalance,

  }) {

    return AppWallet(

      id: id,

      currency: currency ?? this.currency,

      createdAt: createdAt ?? this.createdAt,

      updatedAt: updatedAt ?? this.updatedAt,

      locked: locked ?? this.locked,

      userId: userId ?? this.userId,

      balance: balance ?? this.balance,

      frozenBalance: frozenBalance ?? this.frozenBalance,

    );
  }


  /// ===========================================================================
  /// SOLDE DISPONIBLE
  /// ===========================================================================

  double get availableBalance {
    return balance - frozenBalance!;
  }

  /// ===========================================================================
  /// WALLET ACTIF ?
  // bool get isActive {
  //     return available && !locked;
  //   }
  /// ===========================================================================


  factory AppWallet.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return AppWallet(
      id: doc.id,

      currency: WalletCurrencyExtension.fromString(
        data['currency'],
      ),

      createdAt:
      (data['createdAt'] as Timestamp?)?.toDate() ??
          DateTime.now(),

      updatedAt:
      (data['updatedAt'] as Timestamp?)?.toDate() ??
          DateTime.now(),

      locked: data['locked'] ?? false,

      userId: data['userId'] ?? '',

      balance: (data['available'] ?? 0).toDouble(),

      frozenBalance: (data['frozenBalance'] ?? 0).toDouble(),

    );
  }


}



/// =============================================================================
/// ENUM : DEVISES SUPPORTÉES
/// =============================================================================

enum WalletCurrency {
  xof,
  usd,
  eur,
}

/// =============================================================================
/// EXTENSION
/// =============================================================================

extension WalletCurrencyExtension on WalletCurrency {

  String get label {

    switch (this) {
      case WalletCurrency.xof:
        return "F. CFA";

      case WalletCurrency.usd:
        return "Dollar USD";

      case WalletCurrency.eur:
        return "Euro";
    }

  }

  String get code {

    switch (this) {
      case WalletCurrency.xof:
        return "XOF";

      case WalletCurrency.usd:
        return "USD";

      case WalletCurrency.eur:
        return "EUR";
    }

  }

  static WalletCurrency fromString(String? value) {

    switch (value) {
      case 'USD':
        return WalletCurrency.usd;

      case 'EUR':
        return WalletCurrency.eur;

      default:
        return WalletCurrency.xof;
    }
  }

}
