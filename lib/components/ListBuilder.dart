import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ListBuilderItem {
  final String title;
  final String? subtitle;
  final int? number;
  final Future<void> Function() onTap;
  final bool loading;
  final bool? favorite;
  final Function(bool value)? onFavoriteToggle;

  ListBuilderItem({
    required this.title,
    this.subtitle,
    this.number,
    required this.onTap,
    this.loading = false,
    this.favorite,
    this.onFavoriteToggle,
  });
}

enum SortOrder { asc, desc }

class ListBuilder extends StatefulWidget {
  final List<ListBuilderItem> items;
  final String Function(ListBuilderItem)? groupBy;
  final int Function(ListBuilderItem, ListBuilderItem)? sortBy;
  final SortOrder sortOrder;
  final List<Widget>? slivers;

  const ListBuilder({
    super.key,
    required this.items,
    this.groupBy,
    this.sortBy,
    this.sortOrder = SortOrder.asc,
    this.slivers,
  });

  @override
  State<ListBuilder> createState() => _ListBuilderState();
}

class _ListBuilderState extends State<ListBuilder> {
  late Map<String, List<ListBuilderItem>> groupedItems;
  Map<String, GlobalKey> groupKeys = {};
  final ScrollController _scrollController = ScrollController();
  final ScrollController _groupScrollController = ScrollController();

  bool showSlider = false;
  String currentGroup = '';

  @override
  void initState() {
    super.initState();
    _initializeGroups();
    _scrollController.addListener(scrollControllerListener);
  }

  @override
  void didUpdateWidget(ListBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reinitialize groups if items changed
    if (oldWidget.items != widget.items ||
        oldWidget.groupBy != widget.groupBy ||
        oldWidget.sortBy != widget.sortBy ||
        oldWidget.sortOrder != widget.sortOrder) {
      _initializeGroups();
    }
  }

  void _sortItems(List<ListBuilderItem> items) {
    if (widget.sortBy != null) {
      items.sort(widget.sortBy);
    } else {
      items.sort((a, b) {
        if (a.number != null && b.number != null) {
          return a.number!.compareTo(b.number!);
        } else {
          return (a.number == null ? a.title : '${a.number} - ${a.title}').compareTo(b.number == null ? b.title : '${b.number} - ${b.title}');
        }
      });
    }

    if (widget.sortOrder == SortOrder.desc) {
      items = items.reversed.toList();
    }
  }

  void _initializeGroups() {
    final items = widget.items;

    if (widget.groupBy != null) {
      final Map<String, List<ListBuilderItem>> newGroupedItems = {};

      for (final item in items) {
        final groupKey = widget.groupBy!(item);
        if (!newGroupedItems.containsKey(groupKey)) {
          newGroupedItems[groupKey] = [];
          // Only create GlobalKey if it doesn't exist
          if (!groupKeys.containsKey(groupKey)) {
            groupKeys[groupKey] = GlobalKey(debugLabel: 'group_$groupKey');
          }
        }

        newGroupedItems[groupKey]!.add(item);
      }

      // Remove GlobalKeys for groups that no longer exist
      groupKeys.removeWhere((key, value) => !newGroupedItems.containsKey(key));
      groupedItems = newGroupedItems;
    } else {
      groupedItems = {'': items};
      groupKeys.clear();
    }

    for (final group in groupedItems.keys) {
      _sortItems(groupedItems[group]!);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(scrollControllerListener);
    _scrollController.dispose();
    super.dispose();
  }

  void scrollControllerListener() {
    try {
      if (!mounted) return;
      if (!_scrollController.hasClients) return;

      final shouldShowSlider = _scrollController.position.pixels > 150.0;

      if (shouldShowSlider != showSlider) {
        setState(() {
          showSlider = shouldShowSlider;
        });
      }

      // Last groups
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent) {
        _groupScrollController.animateTo(
          _groupScrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        setState(() {
          currentGroup = groupedItems.keys.last;
        });
        return;
      }

      for (final group in groupedItems.keys) {
        final key = groupKeys[group];
        if (key == null) continue;

        final BuildContext? keyContext = key.currentContext;
        if (keyContext == null) continue;

        final RenderBox? groupRenderObject = keyContext.findRenderObject() as RenderBox?;
        if (groupRenderObject == null || !groupRenderObject.attached) continue;

        // Get the position of the group relative to the viewport
        final RenderAbstractViewport? viewport = RenderAbstractViewport.of(groupRenderObject);
        if (viewport == null) continue;

        final double groupVisibleFraction = viewport.getOffsetToReveal(groupRenderObject, 0.0).offset;

        if ((_scrollController.position.pixels - groupVisibleFraction).abs() < 20.0) {
          if (currentGroup == group) break;
          setState(() {
            currentGroup = group;
          });

          // only scroll if the key is not visible in _groupScrollController
          if (_groupScrollController.hasClients) {
            final groupIndex = groupKeys.keys.toList().indexOf(group);
            final itemHeight = 36.0;
            final targetOffset = groupIndex * itemHeight;
            final viewportHeight = _groupScrollController.position.viewportDimension;
            final currentOffset = _groupScrollController.offset;

            // Check if item is outside visible viewport
            if (targetOffset < currentOffset || targetOffset > currentOffset + viewportHeight - itemHeight) {
              // If scrolling down (target below viewport), align to bottom
              // If scrolling up (target above viewport), align to top
              final double alignedOffset = targetOffset < currentOffset
                  ? targetOffset // Align to top
                  : targetOffset - viewportHeight + itemHeight; // Align to bottom

              _groupScrollController.animateTo(
                alignedOffset.clamp(0.0, _groupScrollController.position.maxScrollExtent),
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          }
        }
      }
    } catch (e) {
      print('Error in scrollControllerListener: $e');
    }
  }

  Widget _renderListItem(ListBuilderItem item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: MaterialButton(
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Colors.white,
        onPressed: () async {
          await item.onTap();
          print('${item.title}: ${item.favorite}');
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.number != null ? '${item.number} - ${item.title}' : item.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  if (item.subtitle != null)
                    Text(
                      '${item.subtitle}',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                ],
              ),
              const Spacer(),
              if (item.loading)
                SpinKitThreeInOut(
                  color: Theme.of(context).primaryColor,
                  size: 18.0,
                )
              else if (item.favorite != null && item.favorite != null)
                GestureDetector(
                  onTap: () {
                    if (item.onFavoriteToggle != null) {
                      item.onFavoriteToggle!(!(item.favorite ?? false));
                    }
                  },
                  child: Icon(
                    item.favorite! ? Icons.favorite : Icons.favorite_border,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> slivers = widget.slivers != null ? List.from(widget.slivers!) : [];
    double rightMargin = groupedItems.keys.length > 1 ? 30.0 : 0.0;

    // If no grouping, just list all items
    if (widget.groupBy == null || groupedItems.keys.length == 1) {
      slivers.add(
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final items = groupedItems[groupedItems.keys.first]!;
                if (index >= items.length) return null;
                return Container(
                  margin: EdgeInsets.only(right: rightMargin),
                  child: _renderListItem(items[index]),
                );
              },
              childCount: groupedItems[groupedItems.keys.first]!.length,
            ),
          ),
        ),
      );
    } else {
      // Build slivers for each group
      groupedItems.forEach((group, items) {
        // Group header with GlobalKey
        slivers.add(
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverToBoxAdapter(
              child: Container(
                key: groupKeys[group], // GlobalKey on individual sliver
                margin: EdgeInsets.only(right: rightMargin),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  group,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                ),
              ),
            ),
          ),
        );

        // Group items
        slivers.add(
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index >= items.length) return null;
                  return Container(
                    margin: EdgeInsets.only(right: rightMargin),
                    child: _renderListItem(items[index]),
                  );
                },
                childCount: items.length,
              ),
            ),
          ),
        );
      });

      slivers.add(
        SliverToBoxAdapter(
          child: SizedBox(height: 20.0),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            physics: BouncingScrollPhysics(),
            slivers: slivers,
          ),
          if (groupedItems.keys.length > 1)
            AnimatedOpacity(
              opacity: showSlider ? 1.0 : 0.0,
              duration: Duration(milliseconds: 300),
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 50.0,
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  padding: EdgeInsets.only(left: 8.0, right: 4.0),
                  // height: double.infinity,
                  child: Card(
                    color: Colors.white,
                    elevation: 1.0,
                    child: ListView(
                      controller: _groupScrollController,
                      shrinkWrap: true,
                      children: groupedItems.keys.map((group) {
                        final isSelected = group == currentGroup;
                        return GestureDetector(
                          onTap: () {
                            final key = groupKeys[group];
                            if (key == null) return;

                            final BuildContext? keyContext = key.currentContext;
                            if (keyContext == null) return;

                            Scrollable.ensureVisible(
                              keyContext,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              group.isNotEmpty ? group[0] : '',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: isSelected ? Theme.of(context).primaryColor : Colors.black,
                                  ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
