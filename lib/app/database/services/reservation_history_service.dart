import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../modules/booking_module/models/reservation.dart';
/// Buckets déjà séparés par statut pour l’Historique
class HistoryBuckets {
  final List<Reservation> awaitingRating;
  final List<Reservation> rated;

  const HistoryBuckets({required this.awaitingRating, required this.rated});

  bool get isEmpty => awaitingRating.isEmpty && rated.isEmpty;
}

/// ---- SERVICE ----
/// TA STRUCTURE :
/// - users/{uid}/reservations/{reservationId}
///   champs: announceId, driverId, passengerId, status ("awaiting_rating"/"rated"), createdAt, (updatedAt?), (ratePromptAt?), etc.
///
/// Pour le PASSAGER: on lit directement `users/{uid}/reservations`
/// Pour le CHAUFFEUR: on lit `collectionGroup('reservations')` filtré par driverId
class HistoryService {
  HistoryService._();

  static final _db = FirebaseFirestore.instance;
  static const List<String> _historyStatuses = ['awaiting_rating', 'rated'];

  /// ---- PASSAGER ----
  /// Historique pour un passager: on lit SA sous-collection users/{uid}/reservations
  static Stream<List<Reservation>> historyForPassengerUid(String uid) {
    final queryOne = _db
        .collection('users')
        .doc(uid)
        .collection('reservations')
        .where('status', whereIn: _historyStatuses)
        // on ordonne sur createdAt pour l’index (tri final côté client sur historyDate)
        .orderBy('createdAt', descending: true);

    return queryOne.snapshots().map(
      (snap) =>
          snap.docs.map(Reservation.fromFirestoreDoc).toList(growable: false),
    );
  }

  /// Historique de toutes les réservations
  static Stream<List<Reservation>> historyForAllPassengers() {
    final queryOne = _db
        .collection('reservations')
        .where('status', whereIn: _historyStatuses)
    // on ordonne sur createdAt pour l’index (tri final côté client sur historyDate)
        .orderBy('createdAt', descending: true);
    return queryOne.snapshots().map(
          (snap) =>
          snap.docs.map(Reservation.fromFirestoreDoc).toList(growable: false),
    );
  }

  static Stream<HistoryBuckets> bucketsForPassengerUid(String uid) {
    return historyForPassengerUid(uid).map((list) {
      // tri robuste côté client
      list.sort((a, b) => b.historyDate.compareTo(a.historyDate));
      final awaiting = <Reservation>[];
      final rated = <Reservation>[];
      for (final r in list) {
        if (r.status == 'awaiting_rating') {
          awaiting.add(r);
        } else if (r.status == 'rated') {
          rated.add(r);
        }
      }
      return HistoryBuckets(awaitingRating: awaiting, rated: rated);
    });
  }

  /// ---- CHAUFFEUR ----
  /// On veut toutes les réservations (chez tous les users) où driverId == uid
  /// → collectionGroup('reservations')
  static Stream<List<Reservation>> historyForDriver(String driverId) {
    final q = _db
        .collectionGroup('reservations')
        .where('driverId', isEqualTo: driverId)
        .where('status', whereIn: _historyStatuses)
        .orderBy('createdAt', descending: true);
    return q.snapshots().map(
      (snap) =>
          snap.docs.map(Reservation.fromFirestoreDoc).toList(growable: false),
    );
  }

  static Stream<HistoryBuckets> bucketsForDriver(String driverId) {
    return historyForDriver(driverId).map((list) {
      list.sort((a, b) => b.historyDate.compareTo(a.historyDate));
      final awaiting = <Reservation>[];
      final rated = <Reservation>[];
      for (final r in list) {
        if (r.status == 'awaiting_rating') {
          awaiting.add(r);
        } else if (r.status == 'rated') {
          rated.add(r);
        }
      }
      return HistoryBuckets(awaitingRating: awaiting, rated: rated);
    });
  }
}
