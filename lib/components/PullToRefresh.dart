import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PullToRefresh extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final List<Widget> slivers;

  const PullToRefresh({
    super.key,
    required this.onRefresh,
    required this.slivers,
  });

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    if (isIOS) {
      return CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          CupertinoSliverRefreshControl(onRefresh: onRefresh),
          ...slivers,
        ],
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: slivers,
      ),
    );
  }
}
