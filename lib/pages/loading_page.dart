import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(),
          CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
                "If the loading goes for too long:\n - Check your internet connection\n - Allow location permissions\n - Restart the app\n - Check if update is available in the store",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  // color: Colors.grey.shade700,
                  fontSize: 16.0,
                  fontFamily: 'Spartan MB',
                )),
          )
        ],
      ),
    );
  }
}
