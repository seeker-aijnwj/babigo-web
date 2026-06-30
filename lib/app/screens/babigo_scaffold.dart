/// ============================================================================
/// FILE : lib/core/ui/babigo_scaffold.dart
/// ============================================================================
///
/// SCAFFOLD OFFICIEL DE BABIGO
///
/// Ce widget devient le conteneur principal de toute l'application.
///
/// Compatible :
///
/// ✅ Mobile
/// ✅ Tablet
/// ✅ Desktop
/// ✅ Web
///
/// Fonctionnalités :
///
/// ✅ SafeArea
/// ✅ Responsive Layout
/// ✅ Max Width
/// ✅ Scroll automatique
/// ✅ Header moderne
/// ✅ Sous-titre
/// ✅ Actions
/// ✅ Floating Action Button
/// ✅ Bottom Navigation
/// ✅ Pull To Refresh
/// ✅ Future Dark Mode Ready
/// ✅ Gradient Background
///
/// ============================================================================

import 'package:flutter/material.dart';

import '../core/utils/colors.dart';

class BabiGOScaffold extends StatelessWidget {
  const BabiGOScaffold({
    super.key,

    required this.child,

    this.title,

    this.subtitle,

    this.leading,

    this.actions,

    this.floatingActionButton,

    this.bottomNavigationBar,

    this.maxWidth = 1200,

    this.padding = const EdgeInsets.all(20),

    this.backgroundColor,

    this.enableScroll = true,

    this.safeArea = true,

    this.centerTitle = false,

    this.refreshCallback,
  });

  /// ==========================================================================
  /// CONTENU PRINCIPAL
  /// ==========================================================================

  final Widget child;

  /// ==========================================================================
  /// HEADER
  /// ==========================================================================

  final String? title;

  final String? subtitle;

  final Widget? leading;

  final List<Widget>? actions;

  final bool centerTitle;

  /// ==========================================================================
  /// ACTIONS
  /// ==========================================================================

  final Widget? floatingActionButton;

  final Widget? bottomNavigationBar;

  /// ==========================================================================
  /// LAYOUT
  /// ==========================================================================

  final double maxWidth;

  final EdgeInsets padding;

  final bool enableScroll;

  final bool safeArea;

  /// ==========================================================================
  /// STYLE
  /// ==========================================================================

  final Color? backgroundColor;

  /// ==========================================================================
  /// REFRESH
  /// ==========================================================================

  final Future<void> Function()? refreshCallback;

  @override
  Widget build(BuildContext context) {
    Widget body = LayoutBuilder(
      builder: (context, constraints) {
        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxWidth,
            ),
            child: Padding(
              padding: padding,
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.stretch,
                children: [
                  if (title != null)
                    _ModernHeader(
                      title: title!,
                      subtitle: subtitle,
                      leading: leading,
                      actions: actions,
                      centerTitle: centerTitle,
                    ),

                  if (title != null)
                    const SizedBox(height: 24),

                  Expanded(
                    child: child,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (enableScroll) {
      body = SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight:
            MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: body,
          ),
        ),
      );
    }

    if (refreshCallback != null) {
      body = RefreshIndicator(
        onRefresh: refreshCallback!,
        child: body,
      );
    }

    if (safeArea) {
      body = SafeArea(child: body);
    }

    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.secondLightColor,

      floatingActionButton:
      floatingActionButton,

      bottomNavigationBar:
      bottomNavigationBar,

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              AppColors.secondColor.withValues(alpha: .03),
            ],
          ),
        ),
        child: body,
      ),
    );
  }
}

/// ============================================================================
/// HEADER MODERNE
/// ============================================================================

class _ModernHeader extends StatelessWidget {
  const _ModernHeader({
    required this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.centerTitle = false,
  });

  final String title;

  final String? subtitle;

  final Widget? leading;

  final List<Widget>? actions;

  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withValues(alpha: .04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Row(
        children: [
          if (leading != null) leading!,

          if (leading != null)
            const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: centerTitle
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                if (subtitle != null) ...[
                  const SizedBox(height: 4),

                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ],
            ),
          ),

          if (actions != null) ...actions!,
        ],
      ),
    );
  }
}