import 'package:flutter/material.dart';
import 'package:kasirku_flutter/core/helper/global_helper.dart';

class DialogHelper {
  static showSnackBar({required BuildContext context, required String text}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
    ));
  }

  static showBottomSheetDialog(
      {required BuildContext context,
      required String title,
      bool canDismiss = true,
      required Widget content}) {
    showModalBottomSheet(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        isDismissible: canDismiss,
        enableDrag: canDismiss,
        builder: (context) => SafeArea(
                child: SingleChildScrollView(
              padding: EdgeInsets.only(
                  right: 20,
                  left: 20,
                  top: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: GlobalHelper.getTextTheme(context,
                                appTextStyle: AppTextStyle.TITLE_MEDIUM)
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      (canDismiss)
                          ? IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.pop(context),
                            )
                          : const SizedBox()
                    ],
                  ),
                  const SizedBox(height: 20),
                  content
                ],
              ),
            )));
  }
}
