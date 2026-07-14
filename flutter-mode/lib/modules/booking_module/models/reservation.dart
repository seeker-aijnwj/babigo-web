import 'package:cloud_firestore/cloud_firestore.dart';

/// ---- MODELE ----
class Reservation {
  final String
  id; // id du doc dans users/{uid}/reservations/{id} (ou via collectionGroup)
  final String announceId;
  final String driverId;
  final String passengerId;
  final String? passengerName;
  final String? passengerPhone;
  final String status; // awaiting_rating | rated
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? ratePromptAt; // optionnel selon ton schéma
  final Map<String, dynamic>? meta; // champs libres (trajet, prix, etc.)

  // (facultatif) infos d'affichage si tu veux brancher direct la carte
  final String? depart;
  final String? departureAddress;
  final String? destination;
  final String? arrivalAddress;
  final String? timeText;
  final num? price;

  Reservation({
    required this.id,
    required this.announceId,
    required this.driverId,
    required this.passengerId,
    required this.status,
    this.passengerName,
    this.passengerPhone,
    this.createdAt,
    this.updatedAt,
    this.ratePromptAt,
    this.meta,
    this.depart,
    this.departureAddress,
    this.destination,
    this.arrivalAddress,
    this.timeText,
    this.price,
  });

  factory Reservation.fromFirestoreDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc,) {

    final data = doc.data();

    return Reservation(
      id: doc.id,
      announceId: data['announceId'] ?? '',
      driverId: data['driverId'] ?? '',
      passengerId: data['passengerId'] ?? '',
      passengerName: data['userName'] ?? '',
      passengerPhone: data['userPhone'] ?? '',
      status: data['status'] ?? '',
      createdAt: _toDate(data['createdAt']),
      updatedAt: _toDate(data['updatedAt']),
      ratePromptAt: _toDate(data['ratePromptAt']),
      meta: data['meta'] != null
          ? Map<String, dynamic>.from(data['meta'])
          : null,

      // champs d’affichage que tu as en base (vu dans ta capture)
      depart: data['depart'],
      departureAddress: data['departureAddress'],
      destination: data['destination'],
      arrivalAddress: data['arrivalAddress'],
      timeText: data['timeText'],
      price: data['price'],
    );
  }

  static DateTime? _toDate(dynamic ts) {
    if (ts == null) return null;
    if (ts is Timestamp) return ts.toDate();
    if (ts is int) return DateTime.fromMillisecondsSinceEpoch(ts);
    return null;
  }

  /// Meilleure date pour trier l’historique
  DateTime get historyDate =>
      ratePromptAt ?? updatedAt ?? createdAt ??
          DateTime.fromMillisecondsSinceEpoch(0);
}
