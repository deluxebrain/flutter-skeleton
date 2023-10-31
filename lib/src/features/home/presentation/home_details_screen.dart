import 'package:flutter/material.dart';
import 'package:flutterskeleton/src/l10n/string_hardcoded.dart';

class HomeDetailsScreen extends StatefulWidget {
  const HomeDetailsScreen({
    super.key,
  });

  @override
  State<HomeDetailsScreen> createState() => _HomeDetailsScreenState();
}

class _HomeDetailsScreenState extends State<HomeDetailsScreen> {
  int _counter = 0;

  @override
  Widget build(BuildContext build) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Counter'.hardcoded),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${'Details'.hardcoded}: $_counter',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Padding(padding: EdgeInsets.all(4)),
            TextButton(
                onPressed: () {
                  setState(() {
                    _counter++;
                  });
                },
                child: Text('Increment counter'.hardcoded)),
          ],
        ),
      ),
    );
  }
}
