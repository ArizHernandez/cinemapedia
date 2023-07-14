import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  Stream<String> getLoadingMessage() {
    final List<String> messages = [
      "Loading Movies",
      "Buying popcorn",
      "Loading Populars",
      "Loading Top Rated",
      "Almost there",
      "Wait...",
      "This is taking longer than expected 🤨"
    ];

    return Stream.periodic(
      const Duration(milliseconds: 1200),
      (step) {
        return messages[step];
      },
    ).take(messages.length);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Wait please..."),
          SizedBox(height: 10),
          CircularProgressIndicator(
            strokeWidth: 2,
          ),
          SizedBox(height: 10),
          StreamBuilder(
            stream: getLoadingMessage(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Text("Loading...");

              return Text(snapshot.data!);
            },
          )
        ],
      ),
    );
  }
}
