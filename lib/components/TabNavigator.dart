import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songbooksofpraise_app/Providers/AppBarProvider.dart';

class TabNavigatorObserver extends NavigatorObserver {
  final VoidCallback? onPopToInitialRoute;

  TabNavigatorObserver({this.onPopToInitialRoute});

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);

    if (previousRoute?.isFirst ?? false) {
      onPopToInitialRoute?.call();
    }

    BuildContext? context = route.navigator?.context;

    if (context != null) {
      Provider.of<AppBarProvider>(context, listen: false).popTitle();
    }
  }
}

class TabNavigator extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final Widget child;
  final VoidCallback? onPopToInitialRoute;

  const TabNavigator({
    required this.navigatorKey,
    required this.child,
    this.onPopToInitialRoute,
    super.key,
  });

  @override
  State<TabNavigator> createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  // final HeroController _heroController = HeroController(createRectTween: (begin, end) {
  // return RectTween(begin: begin, end: end);
  // });
  late final TabNavigatorObserver _observer = TabNavigatorObserver(onPopToInitialRoute: widget.onPopToInitialRoute);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.navigatorKey.currentState?.canPop() ?? false) {
          widget.navigatorKey.currentState?.pop();
          Provider.of<AppBarProvider>(context, listen: false).popTitle();
          return false;
        }
        return true;
      },
      child: Navigator(
        key: widget.navigatorKey,
        observers: [_observer],
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => widget.child,
        ),
      ),
    );
  }
}
