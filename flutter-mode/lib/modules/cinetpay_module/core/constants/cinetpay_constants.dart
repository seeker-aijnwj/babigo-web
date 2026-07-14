/// ============================================================================
/// CINETPAY CONSTANTS
/// ============================================================================
///
/// Toutes les constantes utilisées dans le module paiement.
///
/// IMPORTANT :
/// -----------
///
/// Ne jamais exposer les clés secrètes côté client en production.
///
/// ============================================================================

class CinetPayConstants {

  /// API KEY
  static const String apiKey = "VOTRE_API_KEY";

  /// SITE ID
  static const int siteId = 000000;

  /// BASE URL
  static const String baseUrl =
      "https://api-checkout.cinetpay.com/v2/payment";

  /// CURRENCY
  static const String currency = "XOF";

  /// COUNTRY
  static const String country = "CI";

  /// LANGUAGE
  static const String language = "fr";

  /// PAYMENT CHANNELS
  static const List<String> channels = [
    "MOBILE_MONEY",
    "CARD",
  ];
}