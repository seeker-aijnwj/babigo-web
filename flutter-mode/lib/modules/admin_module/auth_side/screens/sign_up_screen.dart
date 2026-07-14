// ============================================================================
// FILE : screens/auth/sign_up_screen.dart
// ============================================================================

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../../../app/core/utils/colors.dart';
import '../../../../app/core/utils/constants.dart';
import '../../database/models/admin/utilisateur.dart';
import '../../database/services/auth_service.dart';
import '../../screens/admin_login_screen.dart';
import '../auth_route_manager.dart';

class SignUpScreen extends StatefulWidget {
  final List<String>? images;

  const SignUpScreen({
    super.key,
    this.images,
  });

  @override
  State<SignUpScreen> createState() =>
      _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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


  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  final _phoneController = TextEditingController();

  final _passwordController = TextEditingController();

  final _confirmController = TextEditingController();

  bool _loading = false;

  bool _acceptTerms = false;

  bool _obscurePassword = true;

  bool _obscureConfirm = true;

  UserRole _selectedRole = UserRole.passenger;

  @override
  void dispose() {
    _autoTimer?.cancel();
    _pageController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
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
              child: _buildSignUpCard(),
            ),
          ),
        ),
      ],
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
              child: _buildSignUpCard(),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildSignUpCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              const SizedBox(
                height: 20,
              ),

              Utils.buildSignHeader(),

              const SizedBox(
                height: 40,
              ),

              _buildEmailField(),

              const SizedBox(
                height: 16,
              ),

              _buildPhoneField(),

              const SizedBox(
                height: 16,
              ),

              _buildRoleSelector(),

              const SizedBox(
                height: 16,
              ),

              _buildPasswordField(),

              const SizedBox(
                height: 16,
              ),

              _buildConfirmPasswordField(),

              const SizedBox(
                height: 16,
              ),

              _buildTermsCheckbox(),

              const SizedBox(
                height: 30,
              ),

              _buildRegisterButton(),

              const SizedBox(
                height: 24,
              ),

              _buildSignInLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType:
      TextInputType.emailAddress,
      decoration:
      const InputDecoration(
        labelText: "Adresse email",
        prefixIcon:
        Icon(Icons.email_outlined),
      ),
      validator: (value) {
        if (value == null ||
            value.trim().isEmpty) {
          return "Email obligatoire";
        }

        if (!value.contains("@")) {
          return "Email invalide";
        }

        return null;
      },
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType:
      TextInputType.phone,
      decoration:
      const InputDecoration(
        labelText: "Téléphone",
        prefixIcon:
        Icon(Icons.phone),
      ),
      validator: (value) {
        if (value == null ||
            value.trim().isEmpty) {
          return "Téléphone obligatoire";
        }

        return null;
      },
    );
  }

  Widget _buildRoleSelector() {
    return DropdownButtonFormField<
        UserRole>(
      initialValue: _selectedRole,
      decoration:
      const InputDecoration(
        labelText: "Je suis",
      ),
      items: UserRole.values
          .map(
            (role) =>
            DropdownMenuItem(
              value: role,
              child: Text(
                Utils.getUserRoleText(role.name),
              ),
            ),
      )
          .toList(),
      onChanged: (role) {
        if (role == null) return;

        setState(() {
          _selectedRole = role;
        });
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller:
      _passwordController,
      obscureText:
      _obscurePassword,
      decoration:
      InputDecoration(
        labelText: "Mot de passe",
        prefixIcon:
        const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword
                ? Icons.visibility
                : Icons
                .visibility_off,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword =
              !_obscurePassword;
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null ||
            value.length < 6) {
          return "6 caractères minimum";
        }

        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller:
      _confirmController,
      obscureText:
      _obscureConfirm,
      decoration:
      InputDecoration(
        labelText:
        "Confirmer le mot de passe",
        prefixIcon:
        const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureConfirm
                ? Icons.visibility
                : Icons
                .visibility_off,
          ),
          onPressed: () {
            setState(() {
              _obscureConfirm =
              !_obscureConfirm;
            });
          },
        ),
      ),
      validator: (value) {
        if (value !=
            _passwordController.text) {
          return "Les mots de passe ne correspondent pas";
        }

        return null;
      },
    );
  }

  Widget _buildTermsCheckbox() {
    return CheckboxListTile(
      value: _acceptTerms,
      contentPadding: EdgeInsets.zero,
      title: const Text(
        "J'accepte les conditions d'utilisation et la politique de confidentialité",
      ),
      onChanged: (value) {
        setState(() {
          _acceptTerms =
              value ?? false;
        });
      },
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed:
        _loading ? null : _register,
        child: _loading
            ? const SizedBox(
          width: 24,
          height: 24,
          child:
          CircularProgressIndicator(),
        )
            : const Text(
          "Créer mon compte",
        ),
      ),
    );
  }

  Widget _buildSignInLink() {
    return TextButton(
      onPressed: () {
        Navigator.push(context,
          MaterialPageRoute(builder: (_) => const AdminLoginScreen()),
        );
      },
      child: const Text(
        "J'ai déjà un compte",
      ),
    );
  }

  Future<void> _register() async {

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_acceptTerms) {

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            "Veuillez accepter les conditions.",
          ),
        ),
      );

      return;
    }

    try {

      setState(() {
        _loading = true;
      });

      await AuthService().register(
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        password: _passwordController.text,
        role: _selectedRole.name,
      );

      if (!mounted) return;

      await AuthRouteManager.redirectAfterLogin(
        context,
      );

    } catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context,).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
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