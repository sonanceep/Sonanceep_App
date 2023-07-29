// flutter
import 'package:flutter/material.dart';
// packages
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RefreshScreen extends StatelessWidget {
  const RefreshScreen({
    Key? key,
    required this.onRefresh,
    required this.onLoading,
    required this.refreshController,
    required this.child,
  }) : super(key: key);

  final void Function()? onRefresh;
  final void Function()? onLoading;
  final RefreshController refreshController;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: const WaterDropHeader(),
      onRefresh: onRefresh,  //一番下でスライド後放した時の動作
      onLoading: onLoading,  //一番下でスライド中の時の動作
      controller: refreshController,
      child: child,
    );
  }
}