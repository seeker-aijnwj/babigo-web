import 'package:flutter/material.dart';

import '../core/utils/colors.dart';

/// ============================================================================
/// BABIGO APP BAR
/// ============================================================================

class BabiGOAppBar extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool centerTitle;
  final bool showBackButton;
  final List<Widget>? actions;

  const BabiGOAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.centerTitle = false,
    this.showBackButton = true,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.mainColor,
            AppColors.secondColor,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.mainColor.withValues(alpha: .18),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            16,
            12,
            16,
            20,
          ),
          child: Row(
            crossAxisAlignment:
            CrossAxisAlignment.center,
            children: [
              if (showBackButton && canPop)
                _BackButtonModern(),

              if (showBackButton && canPop)
                const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: centerTitle
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      textAlign: centerTitle
                          ? TextAlign.center
                          : TextAlign.left,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    if (subtitle != null &&
                        subtitle!.trim().isNotEmpty)
                      Padding(
                        padding:
                        const EdgeInsets.only(
                          top: 4,
                        ),
                        child: Text(
                          subtitle!,
                          textAlign: centerTitle
                              ? TextAlign.center
                              : TextAlign.left,
                          style: TextStyle(
                            color: Colors.white
                                .withValues(
                              alpha: .90,
                            ),
                            fontSize: 13,
                            fontWeight:
                            FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              if (actions != null)
                Row(
                  mainAxisSize:
                  MainAxisSize.min,
                  children: actions!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ============================================================================
/// BOUTON RETOUR PREMIUM
/// ============================================================================

class _BackButtonModern
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(
        alpha: .18,
      ),
      borderRadius:
      BorderRadius.circular(14),
      child: InkWell(
        borderRadius:
        BorderRadius.circular(14),
        onTap: () {
          Navigator.of(context).maybePop();
        },
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    );
  }
}

/// ============================================================================
/// HEADER CARD
/// ============================================================================
///
/// Carte premium à placer sous l'AppBar
/// pour afficher un résumé important.
///
/// Exemple :
///
/// - véhicule principal
/// - statistiques
/// - annonce active
/// - profil conducteur
///
/// ============================================================================

class BabiGOHeaderCard
    extends StatelessWidget {
  final Widget child;

  const BabiGOHeaderCard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius:
        BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.mainColor,
            AppColors.secondColor,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.mainColor.withValues(
              alpha: .20,
            ),
            blurRadius: 25,
            offset: const Offset(
              0,
              12,
            ),
          ),
        ],
      ),
      child: child,
    );
  }
}