import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterskeleton/src/features/authentication/presentation/auth_providers.dart';
import 'package:flutterskeleton/src/l10n/string_hardcoded.dart';

class CustomProfileScreen extends ConsumerWidget {
  const CustomProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authProviders = ref.watch(authProvidersProvider);
    return ProfileScreen(
      appBar: AppBar(
        title: Text('Profile'.hardcoded),
      ),
      providers: authProviders,
    );
  }
}
