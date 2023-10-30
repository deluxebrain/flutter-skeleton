import 'package:flutter/material.dart';
import 'package:flutterskeleton/src/l10n/string_hardcoded.dart';
import 'package:flutterskeleton/src/routing/app_router.dart';
import 'package:go_router/go_router.dart';

class CounterScreen extends StatelessWidget {
  const CounterScreen({
    super.key,
    required this.detailsPath,
  });

  final String detailsPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Counter'.hardcoded),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Counter'.hardcoded,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Padding(padding: EdgeInsets.all(4)),
            TextButton(
                onPressed: () => context.goNamed(
                      AppRoute.counterDetails.name,
                    ),
                child: Text('View details'.hardcoded)),
          ],
        ),
      ),
    );
  }
}
