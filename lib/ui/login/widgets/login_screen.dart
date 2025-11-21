import 'package:beewear_app/providers/app_startup_provider.dart';
import 'package:beewear_app/routing/routes.dart';
import 'package:beewear_app/ui/core/themes/colors.dart';
import 'package:beewear_app/ui/core/ui/google_auth_button.dart';
import 'package:beewear_app/ui/core/ui/or_divider.dart';
import 'package:beewear_app/ui/core/ui/top_bar.dart';
import 'package:beewear_app/ui/login/view_model/login_state.dart';
import 'package:beewear_app/ui/login/view_model/login_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/themes/dimens.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.read(loginViewModelProvider.notifier);
    final state = ref.watch(loginViewModelProvider);

    ref.listen<LoginState>(loginViewModelProvider, (prev, next) {
      if (next.error != null && next.error != prev?.error) {
        debugPrint('❌ [LOGIN] Error: ${next.error}');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.error!)));
      }

      if (next.isLoggedIn && next.isLoggedIn != (prev?.isLoggedIn ?? false)) {
        debugPrint('✅ [LOGIN] Login successful!');
        debugPrint('🔄 [LOGIN] Invalidating appStartupProvider...');
        // Invalidate the app startup provider so the router knows user is authenticated
        ref.invalidate(appStartupProvider);
        debugPrint('🏠 [LOGIN] Scheduling navigation to /home...');
        // Use Future.microtask to ensure navigation happens after the widget tree updates
        Future.microtask(() {
          if (context.mounted) {
            debugPrint('🏠 [LOGIN] Navigating to /home');
            context.go(Routes.home);
          } else {
            debugPrint('⚠️ [LOGIN] Context not mounted, skipping navigation');
          }
        });
      }
    });

    return Scaffold(
      appBar: const TopBar(),
      body: Padding(
        padding: const EdgeInsets.all(Dimens.paddingHorizontal),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Login", style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 20),
              const GoogleAuthButton(),
              const SizedBox(height: 20),
              const OrDivider(),
              const SizedBox(height: 20),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: viewModel.setEmail,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                onChanged: viewModel.setPassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.black,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: state.isLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            viewModel.login();
                          }
                        },
                  child: state.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text("Login"),
                ),
              ),

              const SizedBox(height: 64),
            ],
          ),
        ),
      ),
    );
  }
}
