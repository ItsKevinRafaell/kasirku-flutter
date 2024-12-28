import 'package:flutter/material.dart';
import 'package:kasirku_flutter/core/helper/global_helper.dart';

class ErrorAppWidget extends StatelessWidget {
  final String description;
  final void Function() onPressButton;
  const ErrorAppWidget(
      {super.key, required this.description, required this.onPressButton});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const Icon(
                Icons.error,
                size: 75,
              ),
              const SizedBox(height: 20),
              Text('Kesalahan',
                  style: GlobalHelper.getTextTheme(context,
                          appTextStyle: AppTextStyle.HEADLINE_SMALL)
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(
                description,
                style: GlobalHelper.getTextTheme(context,
                    appTextStyle: AppTextStyle.BODY_LARGE),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                  onPressed: onPressButton,
                  label: const Text('Coba Lagi'),
                  icon: const Icon(Icons.refresh)),
            ],
          ),
        ),
      ),
    );
  }
}
