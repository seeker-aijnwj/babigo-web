import 'package:flutter/material.dart';
import '../../../../../app/core/themes/admin_light_theme.dart';
import '../../../database/models/admin/notification.dart';

/// ===============================================================
/// VEHICULE DETAILS PANEL
/// ===============================================================

class NotificationDetailsPanel
    extends StatefulWidget {

  final AppNotification notification;

  const NotificationDetailsPanel({
    super.key,
    required this.notification,
  });

  @override
  State<NotificationDetailsPanel>
  createState() =>
      _NotificationDetailsPanelState();
}

class _NotificationDetailsPanelState
    extends State<
        NotificationDetailsPanel> {

  @override
  Widget build(BuildContext context) {

    final notification =
        widget.notification;

    return Container(

      color: UGOAdminTheme.background,

      child: SingleChildScrollView(

        padding: const EdgeInsets.all(24),

        child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Container(

                padding: const EdgeInsets.all(8),

                  decoration: BoxDecoration(

                    color: Colors.white,

                    borderRadius: BorderRadius.circular(18),

                    boxShadow: [

                      BoxShadow(
                        blurRadius: 12,
                        color: Colors.black.withValues(alpha: .04),
                      ),
                    ],
                  ),

                  child: Column(

                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [

                            /// HEADER
                            Row(

                              children: [

                                CircleAvatar(

                                  radius: 28,

                                  backgroundColor:
                                  Colors.blue
                                      .withValues(
                                    alpha: .1,
                                  ),

                                  child: const Icon(
                                    Icons.notifications,
                                    color: Colors.blue,
                                  ),
                                ),

                                const SizedBox(width: 14),

                                Expanded(
                                  child: Column(

                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,

                                    children: [

                                      Text(
                                        notification.title,
                                        style:
                                        const TextStyle(
                                          fontSize: 24,
                                          fontWeight:
                                          FontWeight
                                              .bold,
                                        ),
                                      ),

                                      Text(
                                        notification.senderName,
                                        style:
                                        const TextStyle(
                                          color:
                                          Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 30),

                            /// MESSAGE
                            Container(

                              width: double.infinity,

                              padding:
                              const EdgeInsets.all(
                                20,
                              ),

                              decoration: BoxDecoration(

                                color: Colors.white,

                                borderRadius:
                                BorderRadius.circular(
                                  16,
                                ),
                              ),

                              child: Text(
                                notification.message,
                                style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.5,
                                ),
                              ),
                            ),

                            const SizedBox(height: 30),

                            /// ACTIONS
                            Wrap(

                              spacing: 12,
                              runSpacing: 12,

                              children: [

                                ElevatedButton.icon(
                                  icon:
                                  Icon(
                                    (notification.isRead) ?
                                        Icons.check_circle_outlined :
                                        Icons.check_circle_rounded
                                  ),
                                  label:
                                  const Text("Lu"),
                                  onPressed: () {

                                  },
                                ),

                                ElevatedButton.icon(
                                  onPressed: () {},
                                  icon:
                                  const Icon(Icons.reply),
                                  label:
                                  const Text("Répondre"),
                                ),

                                ElevatedButton.icon(
                                  onPressed: () {},
                                  icon:
                                  const Icon(Icons.share),
                                  label:
                                  const Text("Partager"),
                                ),

                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: () {},
                                  icon:
                                  const Icon(Icons.delete),
                                  label:
                                  const Text("Supprimer"),
                                ),
                              ],
                            ),
                          ],
                      ),

              ),

            ]
        )
      )
    );

  }
}