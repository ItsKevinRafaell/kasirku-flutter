import 'package:flutter/material.dart';
import 'package:flutter/src/material/app_bar.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:kasirku_flutter/app/presentation/profil/profil_notifier.dart';
import 'package:kasirku_flutter/core/helper/global_helper.dart';
import 'package:kasirku_flutter/core/widget/app_widget.dart';

class ProfilScreen extends AppWidget<ProfilNotifier, void, void> {
  @override
  AppBar? appBarBuild(BuildContext context) {
    return AppBar();
  }

  @override
  Widget bodyBuild(BuildContext context) {
    return SafeArea(
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                _headerLayout(context),
                Container(
                    width: double.maxFinite,
                    child:
                        ElevatedButton(onPressed: () {}, child: Text('Logout')))
              ],
            )));
  }

  _headerLayout(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        CircleAvatar(
          radius: 60,
          backgroundColor: GlobalHelper.getColorSchema(context).primary,
          child: Text('A',
              style: GlobalHelper.getTextTheme(context,
                      appTextStyle: AppTextStyle.DISPLAY_MEDIUM)
                  ?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: GlobalHelper.getColorSchema(context).onPrimary)),
        ),
        SizedBox(height: 20),
        Text('Admin',
            style: GlobalHelper.getTextTheme(context,
                    appTextStyle: AppTextStyle.TITLE_LARGE)
                ?.copyWith(
                    color: GlobalHelper.getColorSchema(context).primary,
                    fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Text('kevin@admin.com',
            style: GlobalHelper.getTextTheme(context,
                    appTextStyle: AppTextStyle.BODY_SMALL)
                ?.copyWith(
                    color: GlobalHelper.getColorSchema(context).secondary)),
        SizedBox(height: 20),
      ],
    );
  }
}
