import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:babigo/app/core/utils/colors.dart';
import 'package:babigo/app/core/utils/constants.dart';
import '../auth_side/screens/sign_up_screen.dart';
import 'admin_login_screen.dart';

class AdminWelcomeScreen extends StatefulWidget {
  final List<String>? images;

  const AdminWelcomeScreen({
    super.key,
    this.images,
  });

  @override
  State<AdminWelcomeScreen> createState() => _AdminWelcomeScreenState();
}

class _AdminWelcomeScreenState extends State<AdminWelcomeScreen> {
  late final PageController _pageController;
  late final List<String> _images;

  int _index = 0;
  Timer? _autoTimer;

  @override
  void initState() {
    super.initState();

    _images = widget.images ??
        const [
          'assets/images/image-1.jpg',
          'assets/images/image-2.jpg',
          'assets/images/image-3.jpg',
          'assets/images/image-4.jpg',
        ];

    _pageController = PageController();
    _boostImageCache();
    _startAutoPlay();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    SchedulerBinding.instance.addPostFrameCallback((_) => _precacheAllImages());
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _boostImageCache() {
    final cache = PaintingBinding.instance.imageCache;
    if (cache.maximumSize < 200) cache.maximumSize = 200;
    if (cache.maximumSizeBytes < 200 << 20) {
      cache.maximumSizeBytes = 200 << 20;
    }
  }

  Future<void> _precacheAllImages() async {
    if (!mounted) return;

    try {
      await Future.wait(
        _images.map((src) => precacheImage(_providerFor(src), context)),
      );
    } catch (_) {
      // Les erreurs de préchargement ne doivent pas bloquer l'écran d'accueil.
    }
  }

  void _precacheAround(int index) {
    if (!mounted || _images.isEmpty) return;

    precacheImage(_providerFor(_images[index]), context);
    precacheImage(_providerFor(_images[(index + 1) % _images.length]), context);
    precacheImage(
      _providerFor(_images[(index - 1 + _images.length) % _images.length]),
      context,
    );
  }

  void _startAutoPlay() {
    _autoTimer?.cancel();

    if (_images.length <= 1) return;

    _autoTimer = Timer.periodic(const Duration(seconds: 6), (_) {
      if (!mounted || !_pageController.hasClients) return;

      final next = (_index + 1) % _images.length;

      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 520),
        curve: Curves.easeOutCubic,
      );
    });
  }

  bool _isUrl(String value) {
    return value.startsWith('http://') || value.startsWith('https://');
  }

  ImageProvider _providerFor(String src) {
    if (_isUrl(src)) return CachedNetworkImageProvider(src);
    return AssetImage(src);
  }

  void _goToRegister() {
    Navigator.push(context,
      MaterialPageRoute(builder: (_) => const SignUpScreen()),
    );
  }

  void _goToLogin() {
    Navigator.push(context,
      MaterialPageRoute(builder: (_) => const AdminLoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 900;

          return isDesktop ? _buildDesktop(context) : _buildMobile(context);
        },
      ),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: HeroCarousel(
                images: _images,
                index: _index,
                pageController: _pageController,
                onPageChanged: (i) {
                  setState(() => _index = i);
                  _precacheAround(i);
                },
                buildImage: _buildImage,
              ),
            ),
            const SizedBox(width: 24),

            Expanded(
              flex: 4,
              child: _ActionPanel(
                onRegister: _goToRegister,
                onLogin: _goToLogin,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobile(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: HeroCarousel(
            images: _images,
            index: _index,
            pageController: _pageController,
            onPageChanged: (i) {
              setState(() => _index = i);
              _precacheAround(i);
            },
            buildImage: _buildImage,
            compact: true,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
              child: _ActionPanel(
                onRegister: _goToRegister,
                onLogin: _goToLogin,
                compact: true,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImage(String src) {
    if (_isUrl(src)) {
      return CachedNetworkImage(
        imageUrl: src,
        fit: BoxFit.cover,
        placeholder: (_, _) => Container(color: const Color(0xFFE2E8F0)),
        errorWidget: (_, _, _) => const ImageFallback(),
        placeholderFadeInDuration: Duration.zero,
        fadeInDuration: Duration.zero,
        imageBuilder: (_, provider) {
          return Image(
            image: provider,
            fit: BoxFit.cover,
            gaplessPlayback: true,
          );
        },
      );
    }

    return Image.asset(
      src,
      fit: BoxFit.cover,
      gaplessPlayback: true,
      errorBuilder: (_, _, _) => const ImageFallback(),
    );
  }
}

class _ActionPanel extends StatelessWidget {
  final VoidCallback onRegister;
  final VoidCallback onLogin;
  final bool compact;

  const _ActionPanel({
    required this.onRegister,
    required this.onLogin,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(compact ? 18 : 26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(compact ? 26 : 32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .08),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!compact) const Spacer(),
          const Text(
            "Bienvenue sur BabiGO",
            style: TextStyle(
              color: AppColors.ink,
              fontSize: 28,
              height: 1.1,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Créez votre compte ou connectez-vous pour accéder directement à votre espace.",
            style: TextStyle(
              color: AppColors.muted,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 22),
          _PrimaryButton(
            label: "Créer mon compte",
            icon: Icons.person_add_alt_1,
            onTap: onRegister,
          ),
          const SizedBox(height: 12),
          _SecondaryButton(
            label: "Se connecter",
            icon: Icons.login,
            onTap: onLogin,
          ),
          const SizedBox(height: 20),
          // const _RoleGrid(),
          if (!compact) const Spacer(),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _PrimaryButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.mainColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _SecondaryButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.mainColor,
        side: BorderSide(color: AppColors.mainColor, width: 1.4),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}