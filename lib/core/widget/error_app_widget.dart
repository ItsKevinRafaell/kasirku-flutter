import 'package:flutter/foundation.dart';
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
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Icon(
                Icons.error,
                size: 75,
              ),
              SizedBox(height: 20),
              Text('Kesalahan',
                  style: GlobalHelper.getTextTheme(context,
                          appTextStyle: AppTextStyle.HEADLINE_SMALL)
                      ?.copyWith(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text(
                description,
                style: GlobalHelper.getTextTheme(context,
                    appTextStyle: AppTextStyle.BODY_LARGE),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              FilledButton.icon(
                  onPressed: onPressButton,
                  label: Text('Coba Lagi'),
                  icon: Icon(Icons.refresh)),
            ],
          ),
        ),
      ),
    );
  }
}
