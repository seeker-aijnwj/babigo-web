import 'package:flutter/material.dart';
import '../../../database/models/admin/announcement.dart';

/// ===============================================================
/// ANNOUNCEMENT DETAILS PANEL
/// ===============================================================

class AnnouncementDetailsPanel
    extends StatefulWidget {

  final Announcement announcement;

  const AnnouncementDetailsPanel({
    super.key,
    required this.announcement,
  });

  @override
  State<AnnouncementDetailsPanel>
  createState() =>
      _AnnouncementDetailsPanelState();
}

class _AnnouncementDetailsPanelState
    extends State<
        AnnouncementDetailsPanel> {

  @override
  Widget build(BuildContext context) {

    final announcement =
        widget.announcement;

    return Container(

      color: Colors.grey.shade50,

      child: SingleChildScrollView(

        padding: const EdgeInsets.all(24),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            /// IMAGE
            if (announcement.imageUrl
                .isNotEmpty)

              ClipRRect(

                borderRadius:
                BorderRadius.circular(
                  16,
                ),

                child: Image.network(
                  announcement.imageUrl,
                  height: 240,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

            const SizedBox(height: 24),

            /// TITRE
            Text(
              announcement.announceNumber!,
              style: const TextStyle(
                fontSize: 28,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            /// DESCRIPTION
            Text(
              announcement.description,
              style:
              const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 30),

            /// INFOS
            Wrap(

              spacing: 14,
              runSpacing: 14,

              children: [

                Chip(
                  label: Text(
                    announcement.type.name,
                  ),
                ),

                Chip(
                  label: Text(
                    announcement.status
                        .name,
                  ),
                ),

                Chip(
                  label: Text(
                    "${announcement.views} vues",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            /// ACTIONS
            Wrap(

              spacing: 12,
              runSpacing: 12,

              children: [

                ElevatedButton.icon(
                  onPressed: () {},
                  icon:
                  const Icon(Icons.edit),
                  label:
                  const Text("Modifier"),
                ),

                ElevatedButton.icon(
                  onPressed: () {},
                  icon:
                  const Icon(Icons.send),
                  label:
                  const Text("Publier"),
                ),

                ElevatedButton.icon(
                  onPressed: () {},
                  icon:
                  const Icon(Icons.push_pin),
                  label:
                  const Text("Épingler"),
                ),

                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    Colors.red,
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
    );
  }
}