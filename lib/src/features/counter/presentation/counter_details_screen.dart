import 'package:flutter/material.dart';
import 'package:flutterskeleton/src/l10n/string_hardcoded.dart';

class CounterDetailsScreen extends StatefulWidget {
  const CounterDetailsScreen({
    super.key,
  });

  @override
  State<CounterDetailsScreen> createState() => _CounterDetailsScreenState();
}

class _CounterDetailsScreenState extends State<CounterDetailsScreen> {
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
