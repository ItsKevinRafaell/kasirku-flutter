import 'package:flutter/material.dart';
import 'package:kasirku_flutter/app/domain/entity/order.dart';
import 'package:kasirku_flutter/app/presentation/home/home_notifier.dart';
import 'package:kasirku_flutter/app/presentation/input_order/input_order_screen.dart';
import 'package:kasirku_flutter/app/presentation/order/order_screen.dart';
import 'package:kasirku_flutter/app/presentation/profil/profil_screen.dart';
import 'package:kasirku_flutter/core/helper/date_time_helper.dart';
import 'package:kasirku_flutter/core/helper/global_helper.dart';
import 'package:kasirku_flutter/core/helper/number_helper.dart';
import 'package:kasirku_flutter/core/widget/app_widget.dart';

class HomeScreen extends AppWidget<HomeNotifier, void, void> {
  HomeScreen({super.key});

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
      onPressed: () => _onPressCreateOrder(context),
      child: const Icon(Icons.add),
    );
  }

  _headerLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          const SizedBox(height: 30),
          Row(
            children: [
              InkWell(
                onTap: () => _onPressAvatar(context),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: GlobalHelper.getColorSchema(context).primary,
                  child: Text(notifier.name.substring(0, 1).toUpperCase(),
                      style: GlobalHelper.getTextTheme(context,
                              appTextStyle: AppTextStyle.HEADLINE_MEDIUM)
                          ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: GlobalHelper.getColorSchema(context)
                                  .onPrimary)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(notifier.name,
                        style: GlobalHelper.getTextTheme(context,
                                appTextStyle: AppTextStyle.TITLE_LARGE)
                            ?.copyWith(
                                color: GlobalHelper.getColorSchema(context)
                                    .primary,
                                fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text(notifier.email,
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
          const SizedBox(height: 20),
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
              FilledButton(
                  onPressed: () => _onPressShowAllOrder(context),
                  child: const Text('Lihat semua'))
            ],
          ),
          const SizedBox(height: 5),
          ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              separatorBuilder: (context, index) => const SizedBox(
                    height: 5,
                  ),
              itemCount: notifier.listOrder.length,
              itemBuilder: (context, index) {
                final item = notifier.listOrder[index];
                return _itemOrderLayout(context, item);
              })
        ],
      ),
    );
  }

  _itemOrderLayout(BuildContext context, OrderEntity item) {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.name,
                  style: GlobalHelper.getTextTheme(context,
                          appTextStyle: AppTextStyle.BODY_LARGE)
                      ?.copyWith(
                          color: GlobalHelper.getColorSchema(context).primary,
                          fontWeight: FontWeight.bold)),
              Text(
                  DateTimeHelper.formatDateTimeFromString(
                      dateTimeString: item.updatedAt!,
                      format: 'dd MMM yyyy HH:mm'),
                  style: GlobalHelper.getTextTheme(context,
                          appTextStyle: AppTextStyle.BODY_SMALL)
                      ?.copyWith(
                          color:
                              GlobalHelper.getColorSchema(context).secondary)),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  '${NumberHelper.formatIdr(item.totalPrice!)} (${item.items.length} item)',
                  style: GlobalHelper.getTextTheme(context,
                          appTextStyle: AppTextStyle.BODY_MEDIUM)
                      ?.copyWith(
                          color: GlobalHelper.getColorSchema(context).primary,
                          fontWeight: FontWeight.bold)),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 1,
                          color:
                              GlobalHelper.getColorSchema(context).secondary),
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(item.paymentMethod!.name,
                      style: GlobalHelper.getTextTheme(context,
                              appTextStyle: AppTextStyle.BODY_SMALL)
                          ?.copyWith(
                              color: GlobalHelper.getColorSchema(context)
                                  .secondary)))
            ],
          )
        ]));
  }

  _onPressShowAllOrder(BuildContext context) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => OrderScreen()));
    notifier.init();
  }

  _onPressCreateOrder(BuildContext context) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => InputOrderScreen()));
    notifier.init();
  }

  _onPressAvatar(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProfilScreen()));
  }
}
