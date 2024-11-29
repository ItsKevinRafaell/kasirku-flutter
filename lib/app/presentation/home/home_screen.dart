import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:kasirku_flutter/app/presentation/home/home_notifier.dart';
import 'package:kasirku_flutter/app/presentation/order/order_screen.dart';
import 'package:kasirku_flutter/app/presentation/profil/profil_screen.dart';
import 'package:kasirku_flutter/core/helper/global_helper.dart';
import 'package:kasirku_flutter/core/widget/app_widget.dart';

class HomeScreen extends AppWidget<HomeNotifier, void, void> {
  @override
  Widget bodyBuild(BuildContext context) {
    return SafeArea(
        child: RefreshIndicator(
            onRefresh: () => notifier.init(),
            child: ListView(
              children: [
                _headerLayout(context),
                _orderTodayLayout(context),
              ],
            )));
  }

  @override
  Widget? floatingActionButtonBuild(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _onPressShowAllOrder(context),
      child: Icon(Icons.add),
    );
  }

  _headerLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          SizedBox(height: 30),
          Row(
            children: [
              InkWell(
                onTap: () => _onPressAvatar(context),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: GlobalHelper.getColorSchema(context).primary,
                  child: Text('A',
                      style: GlobalHelper.getTextTheme(context,
                              appTextStyle: AppTextStyle.HEADLINE_MEDIUM)
                          ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: GlobalHelper.getColorSchema(context)
                                  .onPrimary)),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Admin',
                        style: GlobalHelper.getTextTheme(context,
                                appTextStyle: AppTextStyle.TITLE_LARGE)
                            ?.copyWith(
                                color: GlobalHelper.getColorSchema(context)
                                    .primary,
                                fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Text('kevin@admin.com',
                        style: GlobalHelper.getTextTheme(context,
                                appTextStyle: AppTextStyle.LABEL_LARGE)
                            ?.copyWith(
                                color: GlobalHelper.getColorSchema(context)
                                    .secondary)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  _orderTodayLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(
                'Order hari ini',
                style: GlobalHelper.getTextTheme(context,
                        appTextStyle: AppTextStyle.TITLE_LARGE)
                    ?.copyWith(fontWeight: FontWeight.bold),
              )),
              FilledButton(onPressed: () {}, child: Text('Lihat semua'))
            ],
          ),
          SizedBox(height: 5),
          ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              separatorBuilder: (context, index) => SizedBox(
                    height: 5,
                  ),
              itemCount: 5,
              itemBuilder: (context, index) {
                return _itemOrderLayout(context);
              })
        ],
      ),
    );
  }

  _itemOrderLayout(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.white),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('nama_pelanggan',
                  style: GlobalHelper.getTextTheme(context,
                          appTextStyle: AppTextStyle.BODY_LARGE)
                      ?.copyWith(
                          color: GlobalHelper.getColorSchema(context).primary,
                          fontWeight: FontWeight.bold)),
              Text('22 Okt 2024 10:23',
                  style: GlobalHelper.getTextTheme(context,
                          appTextStyle: AppTextStyle.BODY_SMALL)
                      ?.copyWith(
                          color:
                              GlobalHelper.getColorSchema(context).secondary)),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Rp. 5.000 (1 Item)',
                  style: GlobalHelper.getTextTheme(context,
                          appTextStyle: AppTextStyle.BODY_MEDIUM)
                      ?.copyWith(
                          color: GlobalHelper.getColorSchema(context).primary,
                          fontWeight: FontWeight.bold)),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                  child: Text('Cash',
                      style: GlobalHelper.getTextTheme(context,
                              appTextStyle: AppTextStyle.BODY_SMALL)
                          ?.copyWith(
                              color: GlobalHelper.getColorSchema(context)
                                  .secondary)),
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 1,
                          color:
                              GlobalHelper.getColorSchema(context).secondary),
                      borderRadius: BorderRadius.circular(5)))
            ],
          )
        ]));
  }

  _onPressShowAllOrder(BuildContext context) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => OrderScreen()));
    notifier.init();
  }

  _onPressAvatar(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProfilScreen()));
  }
}
