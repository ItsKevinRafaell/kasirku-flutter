import 'package:flutter/material.dart';

class LoadingAppWidget extends StatelessWidget {
  const LoadingAppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
          width: 150, height: 150, child: CircularProgressIndicator()),
    );
  }
}
