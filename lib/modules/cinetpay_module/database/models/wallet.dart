/// ============================================================================
/// WALLET MODEL
/// ============================================================================

class Wallet {

  final String id;

  final String userId;

  final double balance;

  final double frozenBalance;

  final DateTime createdAt;

  Wallet({
    required this.id,
    required this.userId,
    required this.balance,
    required this.frozenBalance,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {

    return {
      'userId': userId,
      'balance': balance,
      'frozenBalance': frozenBalance,
      'createdAt': createdAt,
    };
  }
}