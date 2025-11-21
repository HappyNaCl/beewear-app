import 'package:beewear_app/data/source/local/token_storage.dart';
import 'package:beewear_app/providers/app_startup_provider.dart';
import 'package:beewear_app/providers/user_provider.dart';
import 'package:beewear_app/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AuthorizedScreen extends ConsumerWidget {
  const AuthorizedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokenStorage = ref.read(tokenStorageProvider);
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Authorized'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Clear tokens from secure storage
              await tokenStorage.clear();

              // Clear user data from provider
              ref.read(currentUserProvider.notifier).clearUser();

              // Invalidate the app startup provider to reset auth state
              ref.invalidate(appStartupProvider);

              // Navigate to landing page
              if (context.mounted) {
                context.go(Routes.landing);
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (currentUser?.profilePicture != null)
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(currentUser!.profilePicture!),
                )
              else
                const CircleAvatar(
                  radius: 50,
                  child: Icon(Icons.person, size: 50),
                ),
              const SizedBox(height: 24),
              Text(
                currentUser?.username ?? 'User',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                currentUser?.email ?? '',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Text(
                'User ID: ${currentUser?.userId ?? 'N/A'}',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 48),
              ElevatedButton.icon(
                onPressed: () async {
                  // Clear tokens from secure storage
                  await tokenStorage.clear();

                  // Clear user data from provider
                  ref.read(currentUserProvider.notifier).clearUser();

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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                icon: const Icon(Icons.logout),
                label: const Text('Sign Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
