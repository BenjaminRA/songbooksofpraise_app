// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:songbooksofpraise_app/models/Category.dart';
// import 'package:songbooksofpraise_app/pages/CategoryPage/CategoryPage.dart';
// import 'package:songbooksofpraise_app/pages/HomePage/HomePage.dart';
// import 'package:songbooksofpraise_app/Providers/AppBarProvider.dart';

// class CategoriesSection extends StatefulWidget {
//   final Category category;

//   const CategoriesSection({super.key, required this.category});

//   @override
//   State<CategoriesSection> createState() => _CategoriesSectionState();
// }

// class _CategoriesSectionState extends State<CategoriesSection> {
//   Widget _buildCategoriesSectionItem(Category item) {
//     return MaterialButton(
//       elevation: 1.0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       color: Colors.white,
//       onPressed: () {
//         Provider.of<AppBarProvider>(context, listen: false).setTitle(
//           AppBarState(
//             title: 'Categories',
//             icon: Icons.library_books,
//           ),
//         );
//         songbookTabKey.currentState?.push(
//           MaterialPageRoute(
//             builder: (context) => CategoryPage(category: item),
//           ),
//         );
//       },
//       // onPressed: item.onPressed,
//       child: Hero(
//         tag: 'category_page_${item.title.replaceAll(" ", "_")}',
//         child: Container(
//           width: double.infinity,
//           padding: const EdgeInsets.symmetric(vertical: 18.0),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               if (item.icon != null)
//                 Container(
//                   decoration: BoxDecoration(
//                     color: item.color ?? Theme.of(context).primaryColor,
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   padding: const EdgeInsets.all(8.0),
//                   child: Icon(item.icon, color: Colors.white, size: 28.0),
//                 ),
//               if (item.icon != null) const SizedBox(width: 12.0),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(item.title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 2),
//                   Text(
//                     '${item.hymnsCount} hymns · ${item.subcategoriesCount} subcategories',
//                     style: Theme.of(context).textTheme.labelSmall,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           padding: EdgeInsets.only(top: 24.0, bottom: 28.0),
//           child: Column(
//             children: [
//               Text(
//                 'Browse Categories',
//                 style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8.0),
//               Text(
//                 'Explore hymns organized by themes and occasions',
//                 style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
//               ),
//             ],
//           ),
//         ),
//         Container(
//           width: double.infinity,
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           child: Column(
//             spacing: 16.0,
//             children: categories.map((item) => _buildCategoriesSectionItem(item)).toList(),
//           ),
//         )
//       ],
//     );
//   }
// }
