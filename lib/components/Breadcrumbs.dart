import 'package:flutter/material.dart';

class Breadcrumbs extends StatefulWidget {
  final List<String> items;

  const Breadcrumbs({super.key, required this.items});

  @override
  State<Breadcrumbs> createState() => _BreadcrumbsState();
}

class _BreadcrumbsState extends State<Breadcrumbs> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Scroll to the end of the breadcrumbs after the first frame is rendered
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> crumbs = [];

    for (int i = 0; i < widget.items.length; i++) {
      final item = widget.items[i];
      bool isLast = i == widget.items.length - 1;

      crumbs.add(
        GestureDetector(
          onTap: () {
            for (int j = widget.items.length - i; j > 1; j--) {
              Navigator.of(context).pop();
            }
          },
          child: Text(
            item,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  // fontWeight: FontWeight.bold,
                  color: !isLast ? Theme.of(context).primaryColor : null,
                ),
          ),
        ),
      );

      if (!isLast) {
        crumbs.add(Text(' > ', style: Theme.of(context).textTheme.bodyMedium));
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 250, 231, 1.0),
      ),
      width: MediaQuery.of(context).size.width,
      height: 45.0,
      child: ListView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: crumbs,
          ),
        ],
      ),
    );
  }
}
