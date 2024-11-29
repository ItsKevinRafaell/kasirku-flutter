import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoadingAppWidget extends StatelessWidget {
  const LoadingAppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          width: 150, height: 150, child: CircularProgressIndicator()),
    );
  }
}
