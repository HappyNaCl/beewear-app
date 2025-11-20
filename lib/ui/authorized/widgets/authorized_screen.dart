import 'package:beewear_app/data/source/local/token_storage.dart';
import 'package:beewear_app/providers/app_startup_provider.dart';
import 'package:beewear_app/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AuthorizedScreen extends ConsumerWidget {
  const AuthorizedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokenStorage = ref.read(tokenStorageProvider);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('authorized', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                // Clear tokens from secure storage
                await tokenStorage.clear();

                // Invalidate the app startup provider to reset auth state
                ref.invalidate(appStartupProvider);

                // Navigate to landing page
                if (context.mounted) {
                  context.go(Routes.landing);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
