import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:songbooksofpraise_app/models/Category.dart';

Widget renderCategories(BuildContext context, Category category, {void Function()? onPressed, int? loadingCategory}) {
  return MaterialButton(
    elevation: 1.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    color: Colors.white,
    onPressed: onPressed,
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
              Text(category.name, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(
                '${category.songCount} songs${category.categoriesCount > 0 ? ' • ${category.categoriesCount} subcategories' : ''}',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
          const Spacer(),
          if (loadingCategory == category.id)
            SpinKitThreeInOut(
              color: Theme.of(context).primaryColor,
              size: 18.0,
            ),
        ],
      ),
    ),
  );
}
