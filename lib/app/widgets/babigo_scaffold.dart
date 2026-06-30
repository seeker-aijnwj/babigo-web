/// ============================================================================
/// FILE : lib/app/widgets/babigo_scaffold.dart
/// ============================================================================
///
/// Scaffold officiel BabiGO
///
/// Compatible :
///
/// ✅ Mobile
/// ✅ Tablette
/// ✅ Desktop
/// ✅ Web
/// ✅ Responsive
/// ✅ Firebase
/// ✅ Dark Mode
/// ✅ Loading State
/// ✅ Error State
/// ✅ Empty State
/// ✅ Pull To Refresh
/// ✅ FAB
/// ✅ Drawer
/// ✅ Bottom Navigation
///
/// ============================================================================

import 'package:flutter/material.dart';

import 'package:babigo/app/core/utils/colors.dart';

import 'babigo_app_bar.dart';

/// ============================================================================
/// BABIGO SCAFFOLD
/// ============================================================================

class BabiGOScaffold extends StatelessWidget {
  final String title;

  final String? subtitle;

  final Widget child;

  final Widget? floatingActionButton;

  final Widget? drawer;

  final Widget? bottomNavigationBar;

  final List<Widget>? actions;

  final Future<void> Function()? onRefresh;

  final bool isLoading;

  final bool hasError;

  final bool isEmpty;

  final String? errorMessage;

  final String? emptyMessage;

  final Widget? loadingWidget;

  final Widget? errorWidget;

  final Widget? emptyWidget;

  final double maxWidth;

  final bool centerTitle;

  final bool showBackButton;

  final Color? background;

  const BabiGOScaffold({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.floatingActionButton,
    this.drawer,
    this.bottomNavigationBar,
    this.actions,
    this.onRefresh,
    this.isLoading = false,
    this.hasError = false,
    this.isEmpty = false,
    this.errorMessage,
    this.emptyMessage,
    this.loadingWidget,
    this.errorWidget,
    this.emptyWidget,
    this.maxWidth = 1200,
    this.centerTitle = false,
    this.showBackButton = true,
    this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background ?? AppColors.backgroundColor,

      drawer: drawer,

      floatingActionButton: floatingActionButton,

      bottomNavigationBar: bottomNavigationBar,

      body: SafeArea(
        child: Column(
          children: [
            BabiGOAppBar(
              title: title,
              subtitle: subtitle,
              actions: actions,
              centerTitle: centerTitle,
              showBackButton: showBackButton,
            ),

            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: maxWidth,
                      ),
                      child: _buildBody(context),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    /// LOADING

    if (isLoading) {
      return loadingWidget ??
          const _DefaultLoadingState();
    }

    /// ERROR

    if (hasError) {
      return errorWidget ??
          _DefaultErrorState(
            message:
            errorMessage ??
                "Une erreur est survenue.",
          );
    }

    /// EMPTY

    if (isEmpty) {
      return emptyWidget ??
          _DefaultEmptyState(
            message:
            emptyMessage ??
                "Aucune donnée disponible.",
          );
    }

    /// REFRESHABLE CONTENT

    if (onRefresh != null) {
      return RefreshIndicator(
        color: AppColors.mainColor,
        onRefresh: onRefresh!,
        child: SingleChildScrollView(
          physics:
          const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      );
    }

    /// NORMAL CONTENT

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }
}

/// ============================================================================
/// DEFAULT LOADING
/// ============================================================================

class _DefaultLoadingState extends StatelessWidget {
  const _DefaultLoadingState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              color: AppColors.mainColor,
              strokeWidth: 4,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            "Chargement...",
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// ============================================================================
/// DEFAULT ERROR
/// ============================================================================

class _DefaultErrorState extends StatelessWidget {
  final String message;

  const _DefaultErrorState({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:
        const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red.shade400,
            ),

            const SizedBox(height: 16),

            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ============================================================================
/// DEFAULT EMPTY
/// ============================================================================

class _DefaultEmptyState extends StatelessWidget {
  final String message;

  const _DefaultEmptyState({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:
        const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 80,
              color: Colors.grey.shade400,
            ),

            const SizedBox(height: 16),

            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}