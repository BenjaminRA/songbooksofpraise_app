import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ListBuilderItem {
  final String title;
  final String? subtitle;
  final int? number;
  final VoidCallback onTap;
  final bool loading;

  ListBuilderItem({
    required this.title,
    this.subtitle,
    this.number,
    required this.onTap,
    this.loading = false,
  });
}

enum SortOrder { asc, desc }

class ListBuilder extends StatefulWidget {
  final List<ListBuilderItem> items;
  final String Function(ListBuilderItem)? groupBy;
  final int Function(ListBuilderItem, ListBuilderItem)? sortBy;
  final SortOrder sortOrder;

  const ListBuilder({
    super.key,
    required this.items,
    this.groupBy,
    this.sortBy,
    this.sortOrder = SortOrder.asc,
  });

  @override
  State<ListBuilder> createState() => _ListBuilderState();
}

class _ListBuilderState extends State<ListBuilder> {
  late Map<String, List<ListBuilderItem>> groupedItems;

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

  @override
  void initState() {
    super.initState();

    final items = widget.items;

    if (widget.groupBy != null) {
      groupedItems = {};
      for (final item in items) {
        final groupKey = widget.groupBy!(item);
        if (!groupedItems.containsKey(groupKey)) {
          groupedItems[groupKey] = [];
        }
        groupedItems[groupKey]!.add(item);
      }
    } else {
      groupedItems = {'': items};
    }

    for (final group in groupedItems.keys) {
      _sortItems(groupedItems[group]!);
    }

    // setState(() {});
  }

  Widget _renderListItem(ListBuilderItem item) {
    return MaterialButton(
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.white,
      onPressed: item.onTap,
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
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    // If no grouping, just list all items
    if (widget.groupBy == null || groupedItems.keys.length == 1) {
      children = groupedItems[groupedItems.keys.first]!.map((item) {
        return _renderListItem(item);
      }).toList();
    } else {
      groupedItems.forEach((group, items) {
        children.add(
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              group,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        );

        children.addAll(
          items.map((item) {
            return _renderListItem(item);
          }).toList(),
        );
      });

      children.add(SizedBox(height: 20.0));
    }

    return Column(
      spacing: 16.0,
      children: children,
    );
  }
}
