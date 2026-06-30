import 'package:babigo/modules/admin_module/database/models/admin/announcement.dart';
import 'package:babigo/modules/admin_module/database/services/admin_data_service.dart';
import 'package:babigo/modules/admin_module/screens/booking/trip_details_panel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../app/core/themes/admin_light_theme.dart';
import '../../database/models/admin/notification.dart';
import '../../database/models/admin/trip_ad.dart';

/// ===============================================================
/// LEFT OPERATIONS PANEL
/// ===============================================================
///
/// OBJECTIF
/// ---------
///
/// Cette zone représente :
///
/// ✅ le panneau de navigation gauche
/// ✅ les sous-menus des opérations
/// ✅ la liste dynamique des données
/// ✅ l'affichage des trajets
/// ✅ l'affichage des annonces
/// ✅ une architecture extensible
///
/// STYLE
/// ------
///
/// Inspiré de :
///
/// - WhatsApp Desktop
/// - Slack
/// - Notion
/// - Discord
///
/// ===============================================================

enum OperationMenuType {
  trips,
  announcements,
  notifications,
}

class OperationsLeftPanel extends StatefulWidget {

  final Function(TripAd trip)? onTripSelected;

  final Function(Announcement announcement)?
  onAnnouncementSelected;

  final Function(AppNotification notification)?
  onNotificationSelected;

  final bool isDesktop;

  const OperationsLeftPanel({
    super.key,
    this.onTripSelected,
    this.onAnnouncementSelected,
    this.onNotificationSelected,
    required this.isDesktop,
  });

  @override
  State<OperationsLeftPanel> createState() =>
      _OperationsLeftPanelState();
}

class _OperationsLeftPanelState
    extends State<OperationsLeftPanel> {

  /// =============================================================
  /// MENU ACTUEL
  /// =============================================================

  OperationMenuType _selectedMenu = OperationMenuType.trips;

  /// SEARCH
  final TextEditingController _searchController = TextEditingController();

  /// =============================================================
  /// BUILD
  /// =============================================================
  @override
  Widget build(BuildContext context) {

    return Container(

      width: 420,

      decoration: BoxDecoration(

        color: Colors.white,

        border: Border(
          right: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
      ),

      child: Column(

        children: [

          /// HEADER
          _buildHeader(),

          /// SEARCH BAR
          _buildSearchBar(),

          /// SUB MENUS
          _buildMenus(),

          /// LIST CONTENT
          Expanded(
            child: _buildCurrentList(),
          ),

        ],
      ),
    );
  }

  /// =============================================================
  /// HEADER
  /// =============================================================

  Widget _buildHeader() {

    return Container(

      padding: const EdgeInsets.all(16),

      child: Row(

        children: [

          const CircleAvatar(
            radius: 22,
            backgroundColor:
            UGOAdminTheme.primaryBlue,
            child: Icon(
              Icons.dashboard,
              color: Colors.white,
            ),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  "Opérations",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                SizedBox(height: 2),

                Text(
                  "Gestion des activités",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          /// =====================================================
          /// ACTIONS
          /// =====================================================

          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  /// =============================================================
  /// SEARCH BAR
  /// =============================================================

  Widget _buildSearchBar() {

    return Padding(

      padding:
      const EdgeInsets.symmetric(
        horizontal: 16,
      ),

      child: TextField(

        controller: _searchController,

        decoration: InputDecoration(

          hintText:
          "Rechercher un trajet ou une annonce...",

          prefixIcon:
          const Icon(Icons.search),

          filled: true,

          fillColor: Colors.grey.shade100,

          border: OutlineInputBorder(

            borderRadius:
            BorderRadius.circular(14),

            borderSide: BorderSide.none,
          ),
        ),

        onChanged: (_) {
          setState(() {});
        },
      ),
    );
  }

  /// =============================================================
  /// MENUS
  /// =============================================================

  Widget _buildMenus() {

    return Container(

      margin: const EdgeInsets.only(top: 14),

      height: 60,

      child: ListView(

        scrollDirection: Axis.horizontal,

        padding:
        const EdgeInsets.symmetric(
          horizontal: 16,
        ),

        children: [

          /// ===================================================
          /// TRAJETS
          /// ===================================================

          _buildMenuItem(

            icon: Icons.route,

            title: "Trajets",

            selected:
            _selectedMenu ==
                OperationMenuType.trips,

            onTap: () {

              setState(() {
                _selectedMenu =
                    OperationMenuType.trips;
              });
            },
          ),

          const SizedBox(width: 10),

          /// ===================================================
          /// ANNONCES
          /// ===================================================

          _buildMenuItem(

            icon: Icons.campaign,

            title: "Annonces",

            selected:
            _selectedMenu ==
                OperationMenuType
                    .announcements,

            onTap: () {

              setState(() {
                _selectedMenu =
                    OperationMenuType
                        .announcements;
              });
            },
          ),

          const SizedBox(width: 10),

          /// ===================================================
          /// NOTIFICATIONS
          /// ===================================================

          _buildMenuItem(

            icon: Icons.notifications,

            title: "Notifications",

            selected:
            _selectedMenu ==
                OperationMenuType
                    .notifications,

            onTap: () {

              setState(() {
                _selectedMenu =
                    OperationMenuType
                        .notifications;
              });
            },
          ),

        ],
      ),
    );
  }

  /// =============================================================
  /// MENU ITEM
  /// =============================================================

  Widget _buildMenuItem({

    required IconData icon,
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {

    return InkWell(

      onTap: onTap,

      borderRadius:
      BorderRadius.circular(12),

      child: AnimatedContainer(

        duration:
        const Duration(milliseconds: 200),

        padding:
        const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),

        decoration: BoxDecoration(

          color: selected
              ? UGOAdminTheme.primaryBlue
              .withValues(alpha: .1)
              : Colors.transparent,

          borderRadius:
          BorderRadius.circular(12),

          border: Border.all(
            color: selected
                ? UGOAdminTheme.primaryBlue
                : Colors.grey.shade300,
          ),
        ),

        child: Row(

          children: [

            Icon(
              icon,
              size: 18,
              color: selected
                  ? UGOAdminTheme.primaryBlue
                  : Colors.grey,
            ),

            const SizedBox(width: 8),

            Text(

              title,

              style: TextStyle(

                color: selected
                    ? UGOAdminTheme.primaryBlue
                    : Colors.grey.shade700,

                fontWeight: selected
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// =============================================================
  /// CURRENT LIST
  /// =============================================================

  Widget _buildCurrentList() {

    switch (_selectedMenu) {

    /// =========================================================
    /// TRAJETS
    /// =========================================================

      case OperationMenuType.trips:

        return _buildTripsList();

    /// =========================================================
    /// ANNONCES
    /// =========================================================

      case OperationMenuType.announcements:

        return _buildAnnouncementsList();

    /// =========================================================
    /// NOTIFICATIONS
    /// =========================================================

      case OperationMenuType.notifications:

        return _buildNotificationsList();
    }
  }

  /// =============================================================
  /// LISTE DES TRAJETS
  /// =============================================================

  Widget _buildTripsList() {

    return StreamBuilder<QuerySnapshot>(

      stream: AdminDataService.streamTrips(),

      builder: (context, snapshot) {

        if (!snapshot.hasData) {

          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final trips = snapshot.data!.docs
            .map(
              (e) => TripAd.fromFirestore(e),
        )
            .toList();

        return ListView.builder(

          itemCount: trips.length,

          itemBuilder: (context, index) {

            final trip = trips[index];

            return ListTile(

              leading: const CircleAvatar(
                child: Icon(Icons.route),
              ),

              title: Text(
                trip.fullRoute,
              ),

              subtitle: Text(
                trip.getStatusName(trip.status),
              ),

              onTap: () {

                setState(() {

                  TripDetailsPanel(trip: trip);

                });
              },
            );
          },
        );
      },
    );
  }

  /// =============================================================
  /// LISTE DES ANNONCES
  /// =============================================================

  Widget _buildAnnouncementsList() {

    return StreamBuilder<QuerySnapshot>(

      stream: AdminDataService.streamReservations(),

      builder: (context, snapshot) {

        if (!snapshot.hasData) {

          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final announcements = snapshot
            .data!.docs
            .map(
              (e) => Announcement.getAnnounceReservationData(e),
        )
            .toList();

        return ListView.builder(

          itemCount: announcements.length,

          itemBuilder: (context, index) {

            final announcement = announcements[index];

            return ListTile(

              leading: const CircleAvatar(
                child: Icon(Icons.campaign),
              ),

              title: Text(
                announcement.announceNumber!,
              ),

              subtitle: Text(
                announcement.reservedCount.toString(),
                maxLines: 1,
                overflow:
                TextOverflow.ellipsis,
              ),

              onTap: () {

                widget
                    .onAnnouncementSelected
                    ?.call(announcement);
              },
            );
          },
        );
      },
    );
  }

  /// =============================================================
  /// LISTE DES ANNONCES
  /// =============================================================

  Widget _buildNotificationsList() {

    return StreamBuilder<QuerySnapshot>(

      stream: AdminDataService.streamAllNotifications(),

      builder: (context, snapshot) {

        if (!snapshot.hasData) {

          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final notifications = snapshot
            .data!.docs
            .map(
              (e) => AppNotification.fromFirestore(e),
        )
            .toList();

        return ListView.builder(

          itemCount: notifications.length,

          itemBuilder: (context, index) {

            final notification = notifications[index];

            return ListTile(

              leading: const CircleAvatar(
                child: Icon(Icons.notifications_active),
              ),

              title: Text(
                "Course $notification.tripId",
              ),

              subtitle: Text(
                notification.createdAt.toString(),
                maxLines: 1,
                overflow:
                TextOverflow.ellipsis,
              ),

              onTap: () {

                widget
                    .onNotificationSelected
                    ?.call(notification);
              },
            );
          },
        );
      },
    );
  }

}