/// ============================================================================
/// FIRESTORE DATABASE SERVICE
/// ============================================================================
///
/// OBJECTIF
/// --------
///
/// Centraliser toutes les interactions Firestore.
///
/// Ce service permet :
///
/// ✅ CRUD complet
/// ✅ architecture scalable
/// ✅ réutilisable partout
/// ✅ temps réel
/// ✅ filtres
/// ✅ streams
/// ✅ batch update
/// ✅ transactions
/// ✅ pagination
///
/// COLLECTIONS :
///
/// - announce_reservations
/// - counters
/// - live_locations
/// - notifications
/// - transactions
/// - trips
/// - users
/// - wallets
///
/// ============================================================================

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../app/core/utils/constants.dart';
import '../models/admin/utilisateur.dart';

class AdminDataService {

  /// ==========================================================================
  /// COLLECTION REFERENCES
  /// ==========================================================================

  static final CollectionReference usersRef =
      Utils.db.collection('users');

  static final CollectionReference tripsRef =
      Utils.db.collection('trips');

  static final CollectionReference walletsRef =
      Utils.db.collection('wallets');

  static final CollectionReference transactionsRef =
      Utils.db.collection('transactions');

  static final CollectionReference vehiclesRef =
    Utils.db.collection('vehicles');

  static final CollectionReference notificationsRef =
      Utils.db.collection('notifications');

  static final CollectionReference countersRef =
      Utils.db.collection('counters');

  static final CollectionReference liveLocationsRef =
      Utils.db.collection('live_locations');

  static final CollectionReference reservationsRef =
      Utils.db.collection('announce_reservations');


  /// ==========================================================================
  /// ==========================================================================
  /// USERS CRUD
  /// ==========================================================================
  /// ==========================================================================

  /// CREATE USER
  static Future<void> createUser({
    required String id,
    required Map<String, dynamic> data,
  }) async {

    await usersRef.doc(id).set(data);
  }

  /// GET USER
  static Future<DocumentSnapshot> getUser(
    String id,
  ) async {

    return await usersRef.doc(id).get();
  }

  /// STREAM USER
  static Stream<DocumentSnapshot> streamUser(
    String id,
  ) {

    return usersRef.doc(id).snapshots();
  }

  /// LIST PICKUP PASSENGERS FOR A TRIP
  static List<Utilisateur> streamPickupPassengers(
      List<String> passengersIds
      ) {

    List<Utilisateur> passengers = [];

    for (final passengerId in passengersIds) {

      try {

        final potentialPassenger = streamUser(passengerId) as DocumentSnapshot;

        // ❌ Erreur

        Utilisateur passenger = Utilisateur.fromFirestore(potentialPassenger);
        passengers.add(passenger);

      } catch (e) {

        debugPrint(
          "Erreur conversion utilisateur : $e",
        );
      }

    }

    return passengers;
  }

  /// GET ALL USERS
  static Stream<QuerySnapshot> streamUsers() {

    return usersRef
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// GET ALL PASSENGERS
  static Stream<QuerySnapshot> streamPassengers() {

    return usersRef
        .where('role', isEqualTo: 'passenger')
        .snapshots();
  }

  /// GET ALL DRIVERS
  static Stream<QuerySnapshot> streamDrivers() {

    return usersRef
        .where('role', isEqualTo: 'driver')
        .snapshots();
  }

  /// GET ALL FLEET MANAGERS
  static Stream<QuerySnapshot> streamFleetManagers() {

    return usersRef
        .where('role', isEqualTo: 'fleet')
        .snapshots();
  }

  /// GET ALL SUPPORT
  static Stream<QuerySnapshot> streamSupport() {

    return usersRef
        .where('role', isEqualTo: 'support')
        .snapshots();
  }

  /// UPDATE USER
  static Future<void> updateUser({
    required String id,
    required Map<String, dynamic> data,
  }) async {

    await usersRef.doc(id).update(data);
  }

  /// DELETE USER
  static Future<void> deleteUser(
    String id,
  ) async {

    await usersRef.doc(id).delete();
  }

  /// SEARCH USERS
  static Future<QuerySnapshot> searchUsers(
    String keyword,
  ) async {

    return await usersRef
        .where(
          'keywords',
          arrayContains: keyword.toLowerCase(),
        )
        .get();
  }

  /// ==========================================================================
  /// ==========================================================================
  /// TRIPS CRUD
  /// ==========================================================================
  /// ==========================================================================

  static Future<void> createTrip({
    required String id,
    required Map<String, dynamic> data,
  }) async {

    await tripsRef.doc(id).set(data);
  }

  static Future<DocumentSnapshot> getTrip(
    String id,
  ) async {

    return await tripsRef.doc(id).get();
  }

  static Stream<DocumentSnapshot> streamTrip(
    String id,
  ) {

    return tripsRef.doc(id).snapshots();
  }

  static Stream<QuerySnapshot> streamTrips() {

    return tripsRef
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  static Stream<QuerySnapshot> streamTripsByStatus(
    String status,
  ) {

    return tripsRef
        .where('status', isEqualTo: status)
        .snapshots();
  }

  static Stream<QuerySnapshot> streamTripsByDriver(
    String driverId,
  ) {

    return tripsRef
        .where('driverId', isEqualTo: driverId)
        .snapshots();
  }

  static Future<void> updateTrip({
    required String id,
    required Map<String, dynamic> data,
  }) async {

    await tripsRef.doc(id).update(data);
  }

  static Future<void> deleteTrip(
    String id,
  ) async {

    await tripsRef.doc(id).delete();
  }

  /// ==========================================================================
  /// ==========================================================================
  /// WALLET CRUD
  /// ==========================================================================
  /// ==========================================================================

  static Future<void> createWallet({
    required String id,
    required Map<String, dynamic> data,
  }) async {

    await walletsRef.doc(id).set(data);
  }

  static Future<DocumentSnapshot> getWallet(
    String id,
  ) async {

    return await walletsRef.doc(id).get();
  }

  static Stream<DocumentSnapshot> streamWallet(
    String id,
  ) {

    return walletsRef.doc(id).snapshots();
  }

  static Future<void> updateWallet({
    required String id,
    required Map<String, dynamic> data,
  }) async {

    await walletsRef.doc(id).update(data);
  }

  static Future<void> deleteWallet(
    String id,
  ) async {

    await walletsRef.doc(id).delete();
  }

  /// CREDIT WALLET
  static Future<void> creditWallet({
    required String walletId,
    required double amount,
  }) async {

    await walletsRef.doc(walletId).update({

      'balance': FieldValue.increment(amount),

      'updatedAt': Timestamp.now(),
    });
  }

  /// DEBIT WALLET
  static Future<void> debitWallet({
    required String walletId,
    required double amount,
  }) async {

    await walletsRef.doc(walletId).update({

      'balance': FieldValue.increment(-amount),

      'updatedAt': Timestamp.now(),
    });
  }

  /// ==========================================================================
  /// ==========================================================================
  /// TRANSACTIONS CRUD
  /// ==========================================================================
  /// ==========================================================================

  static Future<void> createTransaction({
    required String id,
    required Map<String, dynamic> data,
  }) async {

    await transactionsRef.doc(id).set(data);
  }

  static Future<DocumentSnapshot> getTransaction(
    String id,
  ) async {

    return await transactionsRef.doc(id).get();
  }

  static Stream<QuerySnapshot> streamTransactions() {

    return transactionsRef
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  static Stream<QuerySnapshot> streamUserTransactions(
    String userId,
  ) {

    return transactionsRef
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  static Stream<QuerySnapshot> streamFewUserTransactions(
      String userId,
      ) {

    return transactionsRef
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true,)
        .limit(10)
        .snapshots();
  }

  static Future<void> updateTransaction({
    required String id,
    required Map<String, dynamic> data,
  }) async {

    await transactionsRef.doc(id).update(data);
  }

  static Future<void> deleteTransaction(
    String id,
  ) async {

    await transactionsRef.doc(id).delete();
  }


  /// ==========================================================================
  /// ==========================================================================
  /// VEHICLES CRUD
  /// ==========================================================================
  /// ==========================================================================

  static Future<void> createVehicle({
    required String id,
    required Map<String, dynamic> data,
  }) async {

    await vehiclesRef.doc(id).set(data);
  }

  static Stream<QuerySnapshot> streamAllVehicles() {

    return vehiclesRef
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  static Stream<QuerySnapshot> streamVehicles(String userId) {

    return vehiclesRef
        .where('ownerId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  static Future<void> markVehicleAsRead(
      String id,
      ) async {

    await vehiclesRef.doc(id).update({

      'isRead': true,
    });
  }

  static Future<void> deleteVehicle(
      String id,
      ) async {

    await vehiclesRef.doc(id).delete();
  }

  /// ==========================================================================
  /// ==========================================================================
  /// NOTIFICATIONS CRUD
  /// ==========================================================================
  /// ==========================================================================

  static Future<void> createNotification({
    required String id,
    required Map<String, dynamic> data,
  }) async {

    await notificationsRef.doc(id).set(data);
  }

  static Stream<QuerySnapshot> streamAllNotifications() {

    return notificationsRef
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  static Stream<QuerySnapshot> streamNotifications(
    String userId,
  ) {

    return notificationsRef
        .where('receiverId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  static Future<void> markNotificationAsRead(
    String id,
  ) async {

    await notificationsRef.doc(id).update({

      'isRead': true,
    });
  }

  static Future<void> deleteNotification(
    String id,
  ) async {

    await notificationsRef.doc(id).delete();
  }

  /// ==========================================================================
  /// ==========================================================================
  /// LIVE LOCATIONS CRUD
  /// ==========================================================================
  /// ==========================================================================

  static Future<void> createLiveLocation({
    required String id,
    required Map<String, dynamic> data,
  }) async {

    await liveLocationsRef.doc(id).set(data);
  }

  static Stream<DocumentSnapshot> streamLiveLocation(
    String tripId,
  ) {

    return liveLocationsRef.doc(tripId).snapshots();
  }

  static Future<void> updateLiveLocation({
    required String id,
    required Map<String, dynamic> data,
  }) async {

    await liveLocationsRef.doc(id).update(data);
  }

  static Future<void> deleteLiveLocation(
    String id,
  ) async {

    await liveLocationsRef.doc(id).delete();
  }

  /// ==========================================================================
  /// ==========================================================================
  /// RESERVATIONS CRUD
  /// ==========================================================================
  /// ==========================================================================

  static Future<void> createReservation({
    required String id,
    required Map<String, dynamic> data,
  }) async {

    await reservationsRef.doc(id).set(data);
  }

  static Future<DocumentSnapshot> getReservation(
    String id,
  ) async {

    return await reservationsRef.doc(id).get();
  }

  static Stream<QuerySnapshot> streamReservations() {

    return reservationsRef
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  static Stream<QuerySnapshot> streamTripReservations(
    String tripId,
  ) {

    return reservationsRef
        .where('tripId', isEqualTo: tripId)
        .snapshots();
  }

  static Future<void> updateReservation({
    required String id,
    required Map<String, dynamic> data,
  }) async {

    await reservationsRef.doc(id).update(data);
  }

  static Future<void> deleteReservation(
    String id,
  ) async {

    await reservationsRef.doc(id).delete();
  }

  /// ==========================================================================
  /// ==========================================================================
  /// COUNTERS CRUD
  /// ==========================================================================
  /// ==========================================================================

  static Future<void> createCounter({
    required String id,
    required Map<String, dynamic> data,
  }) async {

    await countersRef.doc(id).set(data);
  }

  static Future<DocumentSnapshot> getCounter(
    String id,
  ) async {

    return await countersRef.doc(id).get();
  }

  static Future<void> incrementCounter(
    String id,
  ) async {

    await countersRef.doc(id).update({

      'value': FieldValue.increment(1),
    });
  }

  static Future<void> decrementCounter(
    String id,
  ) async {

    await countersRef.doc(id).update({

      'value': FieldValue.increment(-1),
    });
  }

  static Future<void> updateCounter({
    required String id,
    required Map<String, dynamic> data,
  }) async {

    await countersRef.doc(id).update(data);
  }

  static Future<void> deleteCounter(
    String id,
  ) async {

    await countersRef.doc(id).delete();
  }

  /// ==========================================================================
  /// ==========================================================================
  /// GENERIC HELPERS
  /// ==========================================================================
  /// ==========================================================================

  /// DOCUMENT EXISTS
  static Future<bool> documentExists({
    required String collection,
    required String id,
  }) async {

    final doc = await Utils.db
        .collection(collection)
        .doc(id)
        .get();

    return doc.exists;
  }

  /// GENERIC DELETE
  static Future<void> deleteDocument({
    required String collection,
    required String id,
  }) async {

    await Utils.db
        .collection(collection)
        .doc(id)
        .delete();
  }

  /// SERVER TIMESTAMP
  static FieldValue serverTimestamp() {

    return FieldValue.serverTimestamp();
  }

  /// BATCH DELETE
  static Future<void> batchDelete({
    required String collection,
  }) async {

    final snapshot =
        await Utils.db.collection(collection).get();

    final batch = Utils.db.batch();

    for (final doc in snapshot.docs) {

      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  /// ==========================================================================
  /// FIREBASE TRANSACTION
  /// ==========================================================================

  static Future<void> transferMoney({

    required String senderWalletId,

    required String receiverWalletId,

    required double amount,

  }) async {

    await Utils.db.runTransaction((transaction) async {

      final senderRef =
          walletsRef.doc(senderWalletId);

      final receiverRef =
          walletsRef.doc(receiverWalletId);

      final senderSnapshot =
          await transaction.get(senderRef);

      // final receiverSnapshot = await transaction.get(receiverRef);

      final senderBalance =
          senderSnapshot['balance'];

      if (senderBalance < amount) {

        throw Exception(
          "Solde insuffisant",
        );
      }

      transaction.update(senderRef, {

        'balance':
            FieldValue.increment(-amount),
      });

      transaction.update(receiverRef, {

        'balance':
            FieldValue.increment(amount),
      });
    });
  }
}