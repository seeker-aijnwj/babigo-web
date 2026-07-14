import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../database/models/admin/notification.dart';
import '../../../database/models/admin/announcement.dart';

/// ===============================================================
/// FORMULAIRE AJOUT / MODIFICATION ANNONCE
/// ===============================================================
///
/// OBJECTIFS
/// ---------
///
/// ✅ Création annonce
/// ✅ Modification annonce
/// ✅ Validation temps réel
/// ✅ Firebase Firestore
/// ✅ Compatible Desktop / Web / Mobile
/// ✅ Réutilisable partout
/// ✅ UI moderne
///
/// ===============================================================

class AnnouncementForm extends StatefulWidget {
  final Announcement? announcement;

  const AnnouncementForm({
    super.key,
    this.announcement,
  });

  @override
  State<AnnouncementForm> createState() => _AnnouncementFormState();
}

class _AnnouncementFormState  extends State<AnnouncementForm> {
  /// =============================================================
  /// FORM KEY
  /// =============================================================

  final _formKey = GlobalKey<FormState>();

  /// =============================================================
  /// CONTROLLERS
  /// =============================================================

  late final TextEditingController _shortDescController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _imageController;
  late final TextEditingController _authorIdController;
  late final TextEditingController _authorNameController;
  late final TextEditingController _targetAudienceController;
  late final TextEditingController _priorityController;
  late final TextEditingController _actionUrlController;
  late final TextEditingController _actionTextController;
  late final TextEditingController _tagsController;

  /// =============================================================
  /// VARIABLES
  /// =============================================================

  PublicationStatus _status = PublicationStatus.draft;

  bool _isPinned = false;
  bool _isImportant = false;
  bool _isActive = true;

  bool _isSaving = false;

  DateTime? _publishedAt;

  /// =============================================================
  /// INIT STATE
  /// =============================================================

  @override
  void initState() {
    super.initState();

    final announcement = widget.announcement;

    _shortDescController = TextEditingController(
    text: announcement?.shortDescription ?? '',
    );

    _descriptionController = TextEditingController(
    text: announcement?.description ?? '',
    );

    _imageController = TextEditingController(
    text: announcement?.imageUrl ?? '',
    );

    _authorIdController = TextEditingController(
    text: announcement?.authorId ?? '',
    );

    _authorNameController = TextEditingController(
    text: announcement?.authorName ?? '',
    );

    _targetAudienceController = TextEditingController(
    text: announcement?.targetAudience ?? '',
    );

    _priorityController = TextEditingController(
    text: announcement?.priority.toString() ?? '0',
    );

    _actionUrlController = TextEditingController(
    text: announcement?.actionUrl ?? '',
    );

    _actionTextController = TextEditingController(
    text: announcement?.actionText ?? '',
    );

    _tagsController = TextEditingController(
    text: announcement?.tags.join(', ') ?? '',
    );

    _status = announcement?.status ?? PublicationStatus.draft;

    _isPinned = announcement?.isPinned ?? false;
    _isImportant = announcement?.isImportant ?? false;
    _isActive = announcement?.isActive ?? true;

    _publishedAt = announcement?.publishedAt;
  }

  /// =============================================================
  /// DISPOSE
  /// =============================================================

  @override
  void dispose() {
    _shortDescController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
    _authorIdController.dispose();
    _authorNameController.dispose();
    _targetAudienceController.dispose();
    _priorityController.dispose();
    _actionUrlController.dispose();
    _actionTextController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  /// =============================================================
  /// SAVE ANNOUNCEMENT
  /// =============================================================

  Future<void> _saveAnnouncement() async {
    /// Validation formulaire
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      setState(() {
        _isSaving = true;
      });

      final firestore = FirebaseFirestore.instance;

      final docRef = widget.announcement == null ?
        firestore.collection('announcements').doc()
        : firestore
        .collection('announcements')
        .doc(widget.announcement!.id);

      final announcement = Announcement(
        id: docRef.id,
        shortDescription: _shortDescController.text.trim(),
        description: _descriptionController.text.trim(),
        imageUrl: _imageController.text.trim(),
        status: _status,
        publishedAt: _publishedAt,
        authorId: _authorIdController.text.trim(),
        authorName: _authorNameController.text.trim(),
        targetAudience: _targetAudienceController.text.trim(),
        priority: int.tryParse( _priorityController.text.trim(),) ?? 0,
        tags: _tagsController.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
        views: widget.announcement?.views ?? 0,
        likes: widget.announcement?.likes ?? 0,
        commentsCount: widget.announcement?.commentsCount ?? 0,
        isPinned: _isPinned,
        isImportant: _isImportant,
        isActive: _isActive,
        actionUrl: _actionUrlController.text.trim(),
        actionText: _actionTextController.text.trim(),
        createdAt: widget.announcement?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        type: PublicationType.announce,
        tripId: '',
      );

      await docRef.set(announcement.toJson());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              widget.announcement == null
              ? 'Annonce créée avec succès'
              : 'Annonce modifiée avec succès',
            ),
          ),
        );

        Navigator.pop(context);
      }

  } catch (e) {

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Erreur : $e',
            ),
          ),
        );
      }

  } finally {

      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  /// =============================================================
  /// BUILD
  /// =============================================================

  @override
  Widget build(BuildContext context) {
  return Scaffold(

    backgroundColor: Colors.grey.shade100,
    appBar: AppBar(

      elevation: 0,
      title: Text( widget.announcement == null ? 'Nouvelle annonce'
      : 'Modifier annonce',
      ),
    ),
    body: Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 1100,
            ),
            child: Column(
              children: [

                _buildMainCard(),

                const SizedBox(height: 20),

                _buildOptionsCard(),

                const SizedBox(height: 20),

                _buildActionCard(),

                const SizedBox(height: 30),

                _buildButtons(),

              ],
            ),
          ),
        ),
      ),
    ),
  );
}

  /// =============================================================
  /// CARD PRINCIPALE
  /// =============================================================

  Widget _buildMainCard() {

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),

      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Informations principales',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildField(
              controller: _shortDescController,
              label: 'Titre court',
              icon: Icons.short_text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Titre obligatoire';
                }
                return null;
                },
            ),

            const SizedBox(height: 16),

            _buildField(
              controller: _descriptionController,
              label: 'Description complète',
              icon: Icons.description,
              maxLines: 6,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Description obligatoire';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            _buildField(
              controller: _imageController,
              label: 'Image URL',
              icon: Icons.image,
            ),

            const SizedBox(height: 16),

            Row(
              children: [

                Expanded(
                  child: _buildField(
                    controller: _authorIdController,
                    label: 'Auteur ID',
                    icon: Icons.badge,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: _buildField(
                    controller: _authorNameController,
                    label: 'Nom auteur',
                    icon: Icons.person,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: [

                Expanded(
                  child: _buildField(
                    controller: _targetAudienceController,
                    label: 'Audience cible',
                    icon: Icons.groups,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: _buildField(
                    controller: _priorityController,
                    label: 'Priorité',
                    icon: Icons.priority_high,
                    keyboardType:
                    TextInputType.number,
                  ),
                ),

              ],
            ),

          ],
        ),
      ),
    );

  }

  /// =============================================================
  /// CARD OPTIONS
  /// =============================================================

  Widget _buildOptionsCard() {

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),

      ),

      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Options & publication',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            DropdownButtonFormField<PublicationStatus>(
              value: _status,
              decoration: InputDecoration(
                labelText: 'Statut',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              items: PublicationStatus.values.map(
                    (status) => DropdownMenuItem(
                      value: status,
                      child: Text(status.name),
                    ),
              ).toList(),

              onChanged: (value) {
                setState(() {
                  _status = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            _buildField(
              controller: _tagsController,
              label: 'Tags séparés par des virgules',
              icon: Icons.tag,
            ),

            const SizedBox(height: 20),

            _buildField(
              controller: _actionUrlController,
              label: 'Lien action',
              icon: Icons.link,
            ),

            const SizedBox(height: 20),

            _buildField(
              controller: _actionTextController,
              label: 'Texte du bouton action',
              icon: Icons.smart_button,
            ),

            const SizedBox(height: 20),

            Wrap(
              spacing: 16,
              runSpacing: 10,
              children: [
                _buildSwitch(
                  title: 'Épinglée',
                  value: _isPinned,
                  onChanged: (v) {
                    setState(() {
                      _isPinned = v;
                    });
                  },
                ),

                _buildSwitch(
                  title: 'Importante',
                  value: _isImportant,
                  onChanged: (v) {
                    setState(() {
                      _isImportant = v;
                    });
                  },
                ),

                _buildSwitch(
                  title: 'Active',
                  value: _isActive,
                  onChanged: (v) {
                    setState(() {
                      _isActive = v;
                    });
                   },
                ),
              ],
            ),
          ],
        ),
      ),
    );

  }

  /// =============================================================
  /// CARD ACTION
  /// =============================================================

  Widget _buildActionCard() {

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Expanded(
              child: ListTile(
                leading: const Icon(Icons.visibility),
                title: const Text('Vues'),
                subtitle: Text(
                  '${widget.announcement?.views ?? 0}',
                ),
              ),
            ),

            Expanded(
              child: ListTile(
                leading: const Icon(Icons.favorite),
                title: const Text('Likes'),
                subtitle: Text(
                  '${widget.announcement?.likes ?? 0}',
                ),
              ),
            ),

            Expanded(
              child: ListTile(
                leading: const Icon(Icons.comment),
                title: const Text('Commentaires'),
                subtitle: Text(
                  '${widget.announcement?.commentsCount ?? 0}',
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }

  /// =============================================================
  /// BOUTONS
  /// =============================================================

  Widget _buildButtons() {

    return Row(
      children: [

        Expanded(
          child: OutlinedButton(
            onPressed: _isSaving
                ? null
                : () {
              Navigator.pop(context);
              },
            child: const Text('ANNULER'),
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isSaving ? null : _saveAnnouncement,
            icon: _isSaving ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
                : const Icon(Icons.save),
            label: Text(
              _isSaving ? 'Enregistrement...' : 'ENREGISTRER',
            ),
          ),
        ),
      ],
    );

  }

  /// =============================================================
  /// FIELD GENERIC
  /// =============================================================

  Widget _buildField({

    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
    TextInputType? keyboardType,

  }) {

    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// =============================================================
  /// SWITCH GENERIC
  /// =============================================================

  Widget _buildSwitch({

    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {

    return Container(

      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),

      decoration: BoxDecoration(

        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title),

          const SizedBox(width: 10),

          Switch(
            value: value,
            onChanged: onChanged,
          ),

        ],

      ),

    );

  }

}

/*
/// AJOUT
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => const AnnouncementForm(),
  ),
);
```

```dart
/// MODIFICATION
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => AnnouncementForm(
      announcement: announcement,
    ),
  ),
);
```
*/