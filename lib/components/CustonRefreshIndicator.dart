import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomRefreshIndicator extends StatefulWidget {
  final Future<void> Function() onRefresh;
  final Widget child;
  const CustomRefreshIndicator({super.key, required this.onRefresh, required this.child});

  @override
  State<CustomRefreshIndicator> createState() => _CustomRefreshIndicatorState();
}

class _CustomRefreshIndicatorState extends State<CustomRefreshIndicator> {
  bool isDragging = false;
  bool loading = false;
  double dragOffset = 0.0;
  ScrollController scrollController = ScrollController();

  bool _shouldTriggerRefresh(ScrollNotification notification) {
    // Determine if the scroll position is at the top
    return notification.metrics.pixels <= notification.metrics.minScrollExtent;
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (isDragging && _shouldTriggerRefresh(notification)) {
        setState(() => dragOffset -= notification.scrollDelta ?? 0.0);

        // if (dragOffset > 100.0 && !loading) {
        //   setState(() {
        //     loading = true;
        //   });

        //   widget.onRefresh().then((_) {
        //     if (mounted) {
        //       setState(() {
        //         loading = false;
        //         dragOffset = 0.0;
        //       });
        //     }
        //   });
        // }
        Future.delayed(Duration(seconds: 2)).then((_) {
          setState(() => dragOffset = 0.0);
        });
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: clampDouble(dragOffset, 0.0, 60.0),
          child: const Center(child: CircularProgressIndicator()),
        ),
        Listener(
          onPointerDown: (_) {
            setState(() {
              isDragging = true;
            });
          },
          onPointerUp: (_) {
            setState(() {
              isDragging = false;
            });
          },
          onPointerCancel: (_) {
            setState(() {
              isDragging = false;
            });
          },
          child: NotificationListener<ScrollNotification>(
            onNotification: _onScrollNotification,
            child: CustomScrollView(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: widget.child,
                ),
              ],
            ),
          ),
        ),
      ],
    );

    // return widget.child;
  }
}
