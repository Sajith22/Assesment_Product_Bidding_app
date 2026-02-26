// screens/user/register_screen.dart
import 'package:flutter/material.dart';
import '../../theme/user_theme.dart';
import '../../services/auth_service.dart';
import '../../services/notification_service.dart';
import 'auctions_screen.dart';

class UserRegisterScreen extends StatefulWidget {
  const UserRegisterScreen({super.key});

  @override
  State<UserRegisterScreen> createState() => _UserRegisterScreenState();
}

class _UserRegisterScreenState extends State<UserRegisterScreen> {
  final _formKey      = GlobalKey<FormState>();
  final _nameCtrl     = TextEditingController();
  final _emailCtrl    = TextEditingController();
  final _passCtrl     = TextEditingController();
  final _authService  = AuthService();
  final _notifService = NotificationService();

  bool _obscure  = true;
  bool _agreed   = false;
  bool _loading  = false;
  String? _error;
  int _strengthLevel = 0;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _checkStrength(String password) {
    int level = 0;
    if (password.length >= 8) level++;
    if (password.contains(RegExp(r'[A-Z]'))) level++;
    if (password.contains(RegExp(r'[0-9]'))) level++;
    if (password.contains(RegExp(r'[!@#\$%^&*]'))) level++;
    setState(() => _strengthLevel = level);
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate() || !_agreed) return;
    setState(() { _loading = true; _error = null; });

    final result = await _authService.registerUser(
      name: _nameCtrl.text,
      email: _emailCtrl.text,
      password: _passCtrl.text,
    );

    if (!mounted) return;

    if (result.isSuccess) {
      final token = await _notifService.getToken();
      if (token != null) {
        await _authService.updateFcmToken(result.user!.uid, token);
      }
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AuctionsScreen()),
      );
    } else {
      setState(() {
        _loading = false;
        _error = result.errorMessage;
      });
    }
  }

  Color get _strengthColor {
    if (_strengthLevel <= 1) return UserTheme.errorRed;
    if (_strengthLevel == 2) return UserTheme.warningGold;
    if (_strengthLevel == 3) return UserTheme.primaryBlue;
    return UserTheme.successGreen;
  }

  String get _strengthLabel {
    if (_strengthLevel == 0) return '';
    if (_strengthLevel == 1) return 'Weak';
    if (_strengthLevel == 2) return 'Fair';
    if (_strengthLevel == 3) return 'Good';
    return 'Strong';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UserTheme.surface,
      appBar: AppBar(title: const Text('Create Account')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: Responsive.maxFormWidth(context)),
            child: SingleChildScrollView(
              padding: Responsive.pagePadding(context),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Step indicator
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: UserTheme.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('STEP 1/2',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: UserTheme.primaryBlue)),
                    ),
                    const SizedBox(height: 14),
                    Text('Join BidForge',
                        style: UserTextStyles.h1.copyWith(
                            fontSize: Responsive.fs(context, 28))),
                    const SizedBox(height: 6),
                    const Text(
                      'Create your account to start participating in real-time auctions.',
                      style: UserTextStyles.body,
                    ),

                    const SizedBox(height: 24),

                    if (_error != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: UserTheme.errorRed.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: UserTheme.errorRed.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline_rounded,
                                color: UserTheme.errorRed, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(_error!,
                                  style: const TextStyle(
                                      color: UserTheme.errorRed,
                                      fontSize: 13)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],

                    TextFormField(
                      controller: _nameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Full Name *',
                        prefixIcon: Icon(Icons.person_outline_rounded,
                            size: 20, color: UserTheme.textMuted),
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty)
                              ? 'Name is required'
                              : null,
                    ),

                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email Address *',
                        hintText: 'name@example.com',
                        prefixIcon: Icon(Icons.email_outlined,
                            size: 20, color: UserTheme.textMuted),
                      ),
                      validator: (v) =>
                          (v == null || !v.contains('@'))
                              ? 'Enter a valid email'
                              : null,
                    ),

                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _passCtrl,
                      obscureText: _obscure,
                      onChanged: _checkStrength,
                      decoration: InputDecoration(
                        labelText: 'Password *',
                        hintText: 'Min. 8 characters',
                        prefixIcon: const Icon(Icons.lock_outline_rounded,
                            size: 20, color: UserTheme.textMuted),
                        suffixIcon: GestureDetector(
                          onTap: () =>
                              setState(() => _obscure = !_obscure),
                          child: Icon(
                            _obscure
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 20,
                            color: UserTheme.textMuted,
                          ),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Password required';
                        if (v.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                    ),

                    // Strength bar
                    if (_passCtrl.text.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Row(
                        children: List.generate(
                          4,
                          (i) => Expanded(
                            child: Container(
                              height: 4,
                              margin:
                                  EdgeInsets.only(right: i < 3 ? 4 : 0),
                              decoration: BoxDecoration(
                                color: i < _strengthLevel
                                    ? _strengthColor
                                    : UserTheme.divider,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (_strengthLabel.isNotEmpty)
                        Text(
                          'Password strength: $_strengthLabel',
                          style: TextStyle(
                              fontSize: 11,
                              color: _strengthColor,
                              fontWeight: FontWeight.w600),
                        ),
                    ],

                    const SizedBox(height: 16),

                    // Terms checkbox
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _agreed,
                          activeColor: UserTheme.primaryBlue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          onChanged: (v) =>
                              setState(() => _agreed = v ?? false),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: RichText(
                              text: const TextSpan(
                                style: UserTextStyles.label,
                                children: [
                                  TextSpan(text: 'I agree to the '),
                                  TextSpan(
                                    text: 'Terms of Service',
                                    style: TextStyle(
                                        color: UserTheme.primaryBlue,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  TextSpan(text: ' and '),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: TextStyle(
                                        color: UserTheme.primaryBlue,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed:
                            (_loading || !_agreed) ? null : _register,
                        child: _loading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white))
                            : const Text('Create My Account'),
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
