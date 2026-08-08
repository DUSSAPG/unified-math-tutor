import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../services/local_account_service.dart';
import '../../services/onboarding_profile_service.dart';
import '../../shared/theme/app_theme.dart';
import 'auth_form_fields.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSubmitting = true);
    final name = _nameController.text.trim();
    await LocalAccountService.instance.createAccount(
      email: _emailController.text.trim(),
      displayName: name,
    );
    // Seed the greeting's preferred display name, but only if the learner
    // hasn't already set one — presentation identity stays decoupled from
    // account identity per the privacy contract.
    if (name.isNotEmpty &&
        OnboardingProfileService.instance.preferredDisplayName.value == null) {
      await OnboardingProfileService.instance.setPreferredDisplayName(name);
    }
    await OnboardingProfileService.instance.markOnboardingComplete();
    if (!mounted) return;
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        title: const Text('Create Account'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Create your account',
                      style: TextStyle(
                        color: colors.primaryText,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Save progress, Maths Journey data and achievements on this device.',
                      style:
                          TextStyle(color: colors.secondaryText, fontSize: 14),
                    ),
                    const SizedBox(height: 28),
                    AuthTextField(
                      controller: _nameController,
                      label: 'Name',
                      validator: (v) => validateRequired(v, 'your name'),
                    ),
                    const SizedBox(height: 14),
                    AuthTextField(
                      controller: _emailController,
                      label: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      validator: validateEmail,
                    ),
                    const SizedBox(height: 14),
                    AuthTextField(
                      controller: _passwordController,
                      label: 'Password',
                      obscureText: true,
                      validator: validatePassword,
                    ),
                    const SizedBox(height: 14),
                    AuthTextField(
                      controller: _confirmController,
                      label: 'Confirm password',
                      obscureText: true,
                      validator: (v) => v != _passwordController.text
                          ? 'Passwords do not match'
                          : null,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 52,
                      child: FilledButton(
                        onPressed: _isSubmitting ? null : _submit,
                        style: FilledButton.styleFrom(
                          backgroundColor: colors.primaryAction,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: _isSubmitting
                            ? SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: colors.onPrimaryAction,
                                ),
                              )
                            : const Text(
                                'Create Account',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: TextStyle(
                            color: colors.secondaryText,
                            fontSize: 14,
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () => context.push('/auth/sign-in'),
                          child: Text(
                            'Sign in',
                            style: TextStyle(
                              color: colors.accent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
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
