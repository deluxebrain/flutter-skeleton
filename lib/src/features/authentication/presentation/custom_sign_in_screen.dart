import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterskeleton/src/const/app_sizes.dart';
import 'package:flutterskeleton/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:flutterskeleton/src/features/authentication/presentation/auth_providers.dart';
import 'package:flutterskeleton/src/l10n/string_hardcoded.dart';

class CustomSignInScreen extends ConsumerWidget {
  const CustomSignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authProviders = ref.watch(authProvidersProvider);
    return SignInScreen(
      providers: authProviders,
      headerBuilder: (context, constraints, shrinkOffset) {
        return const SignInHeader();
      },
      footerBuilder: (context, action) => const SignInAnonymouslyFooter(),
      sideBuilder: (context, shrinkOffset) {
        return const SignInHeader();
      },
    );
  }
}

class SignInHeader extends ConsumerWidget {
  const SignInHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: AspectRatio(
        aspectRatio: 1,
        child: Image.asset('assets/images/app-icon.png'),
      ),
    );
  }
}

class SignInAnonymouslyFooter extends ConsumerWidget {
  const SignInAnonymouslyFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        gapH8,
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
              child: Text('or'.hardcoded),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        TextButton(
          onPressed: () => ref.read(authRepositoryProvider).signInAnonymously(),
          child: Text('Sign in anonymously'.hardcoded),
        ),
      ],
    );
  }
}
