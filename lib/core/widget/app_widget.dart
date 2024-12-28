import 'package:flutter/material.dart';
import 'package:kasirku_flutter/core/di/dependency.dart';
import 'package:kasirku_flutter/core/helper/dialog_helper.dart';
import 'package:kasirku_flutter/core/provider/app_provider.dart';
import 'package:kasirku_flutter/core/widget/error_app_widget.dart';
import 'package:kasirku_flutter/core/widget/loading_app_widget.dart';
import 'package:provider/provider.dart';

abstract class AppWidget<T extends AppProvider, P1, P2>
    extends StatelessWidget {
  AppWidget({super.key, this.param1, this.param2});
  final P1? param1;
  final P2? param2;
  late T notifier;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
        create: (context) => sl(param1: param1, param2: param2),
        builder: (context, child) => _build(context));
  }

  Widget _build(BuildContext context) {
    notifier = Provider.of<T>(context);

    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      if (notifier.snackBarMessage.isNotEmpty) {
        DialogHelper.showSnackBar(
            context: context, text: notifier.snackBarMessage);
        notifier.snackBarMessage = '';
      }
      checkVariable(context);
    });

    return Scaffold(
        appBar: appBarBuild(context),
        body: (notifier.isLoading)
            ? const LoadingAppWidget()
            : (notifier.errorMessage.isNotEmpty)
                ? ErrorAppWidget(
                    description: notifier.errorMessage,
                    onPressButton: () {
                      notifier.errorMessage = '';
                      notifier.init();
                    })
                : bodyBuild(context),
        floatingActionButton: floatingActionButtonBuild(context),
        drawer: drawerBuild(context));
  }

  checkVariable(BuildContext context) {}

  AppBar? appBarBuild(BuildContext context) {
    return null;
  }

  Widget bodyBuild(BuildContext context);

  Widget? floatingActionButtonBuild(BuildContext context) {
    return null;
  }

  Widget? drawerBuild(BuildContext context) {
    return null;
  }
}
