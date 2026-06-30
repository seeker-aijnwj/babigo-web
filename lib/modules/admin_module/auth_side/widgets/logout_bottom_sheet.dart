/// ============================================================================
/// FILE : auth/widgets/logout_bottom_sheet.dart
///
/// Utilisation dans un menu
///
/// ListTile(
///   leading: const Icon(
///     Icons.logout,
///   ),
///   title: const Text(
///     "Déconnexion",
///   ),
///   onTap: () {
///     LogoutBottomSheet.show(
///       context,
///     );
///   },
/// ),
/// ============================================================================

import 'package:flutter/material.dart';

import '../../database/services/auth_service.dart';

class LogoutBottomSheet {

  LogoutBottomSheet._();

  // ==========================================================================
  // SHOW
  // ==========================================================================

  static Future<void> show(
      BuildContext context,
      ) async {

    await showModalBottomSheet(

      context: context,

      backgroundColor: Colors.transparent,

      isScrollControlled: true,

      builder: (_) {

        return const _LogoutSheetContent();
      },
    );
  }
}

// ============================================================================
// CONTENT
// ============================================================================

class _LogoutSheetContent extends StatefulWidget {

  const _LogoutSheetContent();

  @override
  State<_LogoutSheetContent>
  createState() =>
      _LogoutSheetContentState();
}

class _LogoutSheetContentState
    extends State<_LogoutSheetContent> {

  bool _loading = false;

  @override
  Widget build(
      BuildContext context,
      ) {

    return Container(

      decoration: const BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.vertical(
          top: Radius.circular(32),
        ),
      ),

      padding: const EdgeInsets.all(24),

      child: SafeArea(

        child: Column(

          mainAxisSize:
          MainAxisSize.min,

          children: [

            _buildHandle(),

            const SizedBox(height: 20),

            _buildIcon(),

            const SizedBox(height: 20),

            _buildTitle(),

            const SizedBox(height: 10),

            _buildDescription(),

            const SizedBox(height: 30),

            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle() {

    return Container(

      width: 50,

      height: 5,

      decoration: BoxDecoration(

        color: Colors.grey.shade300,

        borderRadius:
        BorderRadius.circular(
          100,
        ),
      ),
    );
  }

  Widget _buildIcon() {

    return Container(

      width: 90,

      height: 90,

      decoration: BoxDecoration(

        color:
        Colors.red.shade50,

        shape:
        BoxShape.circle,
      ),

      child: Icon(

        Icons.logout_rounded,

        size: 42,

        color:
        Colors.red.shade700,
      ),
    );
  }

  Widget _buildTitle() {

    return const Text(

      "Déconnexion",

      textAlign:
      TextAlign.center,

      style: TextStyle(
        fontSize: 22,
        fontWeight:
        FontWeight.bold,
      ),
    );
  }

  Widget _buildDescription() {

    return Text(

      "Souhaitez-vous vraiment quitter votre session BabiGO ?",

      textAlign:
      TextAlign.center,

      style: TextStyle(

        color:
        Colors.grey.shade700,

        fontSize: 15,
      ),
    );
  }

  Widget _buildButtons() {

    return Row(

      children: [

        Expanded(
          child: OutlinedButton(

            onPressed:
            _loading
                ? null
                : () {

              Navigator.pop(
                context,
              );
            },

            child:
            const Text(
              "Annuler",
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: ElevatedButton(

            onPressed:
            _loading
                ? null
                : _logout,

            child: _loading

                ? const SizedBox(
              width: 20,
              height: 20,
              child:
              CircularProgressIndicator(
                strokeWidth:
                2,
              ),
            )

                : const Text(
              "Déconnexion",
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _logout() async {

    try {

      setState(() {
        _loading = true;
      });

      await AuthService.signOut();

      if (!mounted) return;

      Navigator.of(context)
          .pushNamedAndRemoveUntil(
        '/signin',
            (route) => false,
      );

    } catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content:
          Text(e.toString()),
        ),
      );
    } finally {

      if (mounted) {

        setState(() {
          _loading = false;
        });
      }
    }
  }
}