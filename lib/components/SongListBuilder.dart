import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:songbooksofpraise_app/l10n/app_localizations.dart';
import 'package:songbooksofpraise_app/models/Song.dart';

class SongListBuilderItem {
  final String title;
  final String? subtitle;
  final bool loading;
  final Song song;

  SongListBuilderItem({
    required this.title,
    this.subtitle,
    this.loading = false,
    required this.song,
  });
}

enum SortOrder { asc, desc }

class SongListBuilder extends StatefulWidget {
  final List<SongListBuilderItem> items;
  final String Function(SongListBuilderItem)? groupBy;
  final int Function(SongListBuilderItem, SongListBuilderItem)? sortBy;
  final SortOrder sortOrder;
  final List<Widget>? slivers;
  final bool enableSideBar;
  final bool forceGroupHeaders;
  final Widget? emptyStateWidget;
  final Future<void> Function(SongListBuilderItem item)? onTap;

  const SongListBuilder({
    super.key,
    required this.items,
    this.groupBy,
    this.sortBy,
    this.sortOrder = SortOrder.asc,
    this.slivers,
    this.enableSideBar = true,
    this.forceGroupHeaders = false,
    this.emptyStateWidget,
    this.onTap,
  });

  @override
  State<SongListBuilder> createState() => _SongListBuilderState();
}

class _SongListBuilderState extends State<SongListBuilder> {
  late Map<String, List<SongListBuilderItem>> groupedItems;
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
  void didUpdateWidget(SongListBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reinitialize groups if items changed
    if (oldWidget.items != widget.items ||
        oldWidget.groupBy != widget.groupBy ||
        oldWidget.sortBy != widget.sortBy ||
        oldWidget.sortOrder != widget.sortOrder) {
      _initializeGroups();
    }
  }

  void _sortItems(List<SongListBuilderItem> items) {
    if (widget.sortBy != null) {
      items.sort(widget.sortBy);
    } else {
      items.sort((a, b) {
        if (a.song.number != null && b.song.number != null) {
          return a.song.number!.compareTo(b.song.number!);
        } else {
          return (a.song.number == null ? a.title : '${a.song.number} - ${a.title}')
              .compareTo(b.song.number == null ? b.title : '${b.song.number} - ${b.title}');
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
      final Map<String, List<SongListBuilderItem>> newGroupedItems = {};

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

  Widget _renderListItem(SongListBuilderItem item) {
    bool showFavorite = item.song.favorite != null;
    bool isFavorite = item.song.favorite ?? false;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: MaterialButton(
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Colors.white,
        onPressed: () async {
          widget.onTap != null ? await widget.onTap!(item) : null;

          await item.song.refresh(); // Refresh song data after potential edits in SongPage
          setState(() {});
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
                  Text(item.song.number != null ? '${item.song.number} - ${item.song.title}' : item.song.title,
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
              else if (showFavorite)
                GestureDetector(
                  onTap: () {
                    item.song.setFavorite(!isFavorite);
                    setState(() {});
                  },
                  child: Icon(
                    item.song.favorite! ? Icons.favorite : Icons.favorite_border,
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
    bool shouldShowSideBar = widget.enableSideBar == true && groupedItems.keys.length > 1;
    double rightMargin = shouldShowSideBar ? 30.0 : 0.0;

    if (widget.emptyStateWidget != null && widget.items.isEmpty) {
      slivers.add(
        SliverFillRemaining(
          child: Center(child: widget.emptyStateWidget),
        ),
      );
    } else if (widget.items.isEmpty) {
      slivers.add(
        SliverFillRemaining(
          child: Center(
            child: Text(
              AppLocalizations.of(context)!.noItemsFound,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
          ),
        ),
      );
    }

    // If no grouping, just list all items
    if (widget.groupBy == null || (groupedItems.keys.length == 1 && !widget.forceGroupHeaders)) {
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
          if (shouldShowSideBar)
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
