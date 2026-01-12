import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:songbooksofpraise_app/helpers/navigateToSong.dart';
import 'package:songbooksofpraise_app/l10n/app_localizations.dart';
import 'package:songbooksofpraise_app/models/SearchResult.dart';
import 'package:songbooksofpraise_app/models/Song.dart';
import 'package:songbooksofpraise_app/models/Category.dart';
import 'package:songbooksofpraise_app/models/Songbook.dart';
import 'package:songbooksofpraise_app/Providers/AppBarProvider.dart';
import 'package:songbooksofpraise_app/api/api.dart';
import 'package:songbooksofpraise_app/pages/RootPage.dart';
import 'package:songbooksofpraise_app/pages/SongPage/SongPage.dart';
import 'package:songbooksofpraise_app/pages/Tabs/SongbooksTab/pages/CategoryPage.dart';
import 'package:songbooksofpraise_app/pages/Tabs/SongbooksTab/pages/SongbookPage.dart';

enum SearchFilter { songs, categories, songbooks }

class SongSearch extends StatefulWidget {
  const SongSearch({super.key});

  @override
  State<SongSearch> createState() => _SongSearchState();
}

class _SongSearchState extends State<SongSearch> {
  final TextEditingController _searchController = TextEditingController();
  final Set<SearchFilter> _activeFilters = {SearchFilter.songs, SearchFilter.categories, SearchFilter.songbooks};
  List<SearchResult> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    List<SearchResult> results = [];

    // Search songs if filter is active
    if (_activeFilters.contains(SearchFilter.songs)) {
      final songResults = await Song.search(query);
      results.addAll(songResults.map((item) => SearchResult(
            type: SearchResultType.song,
            data: item['song'],
            songbookTitle: item['songbook_title'],
          )));
    }

    // Search categories if filter is active
    if (_activeFilters.contains(SearchFilter.categories)) {
      final categoryResults = await Category.search(query);
      results.addAll(categoryResults.map((item) => SearchResult(
            type: SearchResultType.category,
            data: item['category'],
            songbookTitle: item['songbook_title'],
          )));
    }

    // Search songbooks if filter is active
    if (_activeFilters.contains(SearchFilter.songbooks)) {
      final songbookResults = await Songbook.search(query);
      results.addAll(songbookResults.map((songbook) => SearchResult(
            type: SearchResultType.songbook,
            data: songbook,
          )));
    }

    setState(() {
      _searchResults = results;
      _isSearching = false;
    });
  }

  void _toggleFilter(SearchFilter filter) {
    setState(() {
      if (_activeFilters.contains(filter)) {
        // Don't allow removing all filters
        if (_activeFilters.length > 1) {
          _activeFilters.remove(filter);
        }
      } else {
        _activeFilters.add(filter);
      }
    });

    // Re-run search if there's a query
    if (_searchController.text.isNotEmpty) {
      _performSearch(_searchController.text);
    }
  }

  Future<void> _onResultTap(SearchResult result) async {
    switch (result.type) {
      case SearchResultType.song:
        await _navigateToSong(result.data as Song);
        break;
      case SearchResultType.category:
        await _navigateToCategory(result.data as Category);
        break;
      case SearchResultType.songbook:
        await _navigateToSongbook(result.data as Songbook);
        break;
    }
  }

  Future<void> _navigateToSong(Song song) async {
    if (!mounted) return;

    navigateToSong(context, song.id);
  }

  Future<void> _navigateToCategory(Category category) async {
    List<Category> children = await Category.getSubCategoriesRecursive(category.id);

    Category? fullCategory = await Category.getCategoryByID(category.id, category.songbookID);

    fullCategory?.subcategories = children;

    if (fullCategory == null) {
      final response = await API.get('categories/${category.id}');
      fullCategory = Category.fromJson(response['category']);
    }

    if (!mounted) return;

    Provider.of<AppBarProvider>(context, listen: false).setTitle(
      AppBarState(
        title: fullCategory.name,
        icon: Icons.category,
      ),
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CategoryPage(category: fullCategory!),
      ),
    );
  }

  Future<void> _navigateToSongbook(Songbook songbook) async {
    // Fetch full songbook with categories
    final categories = await API.get('songbooks/${songbook.id}/categories');
    songbook.categories = categories['categories'].map((categoryData) => Category.fromJson(categoryData)).toList().cast<Category>();

    if (!mounted) return;

    Provider.of<AppBarProvider>(context, listen: false).setTitle(
      AppBarState(
        title: songbook.title,
        icon: Icons.library_books,
      ),
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SongbookPage(songbook: songbook),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.symmetric(
                  horizontal: BorderSide(color: Color.fromRGBO(254, 247, 218, 1.0), width: 2.0),
                ),
              ),
              child: Column(
                children: [
                  TextField(
                    autofocus: true,
                    controller: _searchController,
                    onChanged: (value) => _performSearch(value),
                    decoration: InputDecoration(
                      hintText: localizations.searchHymnsSongsOrNumbers,
                      prefixIcon: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(Icons.search, color: Color.fromRGBO(140, 147, 159, 1), size: 28),
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                _performSearch('');
                              },
                              child: const Icon(Icons.clear, color: Color.fromRGBO(140, 147, 159, 1)),
                            )
                          : null,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(221, 225, 229, 1),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Wrap(
                    alignment: WrapAlignment.spaceEvenly,
                    spacing: 8.0,
                    children: [
                      FilterChip(
                        label: Text(localizations.songs),
                        selected: _activeFilters.contains(SearchFilter.songs),
                        onSelected: (_) => _toggleFilter(SearchFilter.songs),
                        selectedColor: Color.fromRGBO(254, 247, 218, 1.0),
                        checkmarkColor: Color.fromRGBO(140, 147, 159, 1),
                      ),
                      FilterChip(
                        label: Text(localizations.categories),
                        selected: _activeFilters.contains(SearchFilter.categories),
                        onSelected: (_) => _toggleFilter(SearchFilter.categories),
                        selectedColor: Color.fromRGBO(254, 247, 218, 1.0),
                        checkmarkColor: Color.fromRGBO(140, 147, 159, 1),
                      ),
                      FilterChip(
                        label: Text(localizations.songbooks),
                        selected: _activeFilters.contains(SearchFilter.songbooks),
                        onSelected: (_) => _toggleFilter(SearchFilter.songbooks),
                        selectedColor: Color.fromRGBO(254, 247, 218, 1.0),
                        checkmarkColor: Color.fromRGBO(140, 147, 159, 1),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isSearching
                  ? Center(child: SpinKitThreeBounce(color: Theme.of(context).primaryColor))
                  : _searchController.text.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search, size: 80, color: Color.fromRGBO(140, 147, 159, 0.3)),
                              SizedBox(height: 24.0),
                              // Text(
                              //   localizations.searchPageWaitingForInputText,
                              //   style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              //         color: Color.fromRGBO(140, 147, 159, 1),
                              //         fontWeight: FontWeight.w500,
                              //       ),
                              // ),
                              // SizedBox(height: 8.0),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 48.0),
                                child: Text(
                                  localizations.searchPageWaitingForInputText,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Color.fromRGBO(140, 147, 159, 0.7),
                                      ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : _searchResults.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.search_off, size: 64, color: Color.fromRGBO(140, 147, 159, 0.5)),
                                  SizedBox(height: 16.0),
                                  Text(
                                    localizations.noResults,
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          color: Color.fromRGBO(140, 147, 159, 1),
                                        ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: _searchResults.length,
                              itemBuilder: (context, index) {
                                final result = _searchResults[index];
                                return _buildResultItem(result, localizations);
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlightedText(String text, String query) {
    final queryLower = query.toLowerCase();
    final textLower = text.toLowerCase();

    List<TextSpan> spans = [];
    int start = 0;

    while (true) {
      final index = textLower.indexOf(queryLower, start);
      if (index < 0) {
        spans.add(TextSpan(text: text.substring(start)));
        break;
      }

      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index)));
      }

      spans.add(
        TextSpan(
          text: text.substring(index, index + query.length),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );

      start = index + query.length;
    }

    return RichText(
      text: TextSpan(
        style: TextStyle(color: Colors.black),
        children: spans,
      ),
    );
  }

  Widget _buildResultItem(SearchResult result, AppLocalizations localizations) {
    IconData icon;
    Color iconColor;
    String typeLabel;

    switch (result.type) {
      case SearchResultType.song:
        icon = Icons.music_note;
        iconColor = Color.fromRGBO(74, 144, 226, 1);
        typeLabel = localizations.song;
        break;
      case SearchResultType.category:
        icon = Icons.category;
        iconColor = Color.fromRGBO(139, 195, 74, 1);
        typeLabel = localizations.category;
        break;
      case SearchResultType.songbook:
        icon = Icons.library_books;
        iconColor = Color.fromRGBO(255, 152, 0, 1);
        typeLabel = localizations.songbook;
        break;
    }

    return InkWell(
      onTap: () => _onResultTap(result),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color.fromRGBO(221, 225, 229, 0.5),
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: result.type == SearchResultType.song
                  ? SizedBox(
                      width: 24.0,
                      height: 24.0,
                      child: Center(
                        child: Text(
                          (result.data as Song).number?.toString() ?? (result.data as Song).title[0],
                          textAlign: TextAlign.center,
                          softWrap: false,
                          style: TextStyle(
                            color: iconColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0 - ((result.data as Song).number?.toString().length ?? 0) * 2.0,
                          ),
                        ),
                      ),
                    )
                  : Icon(icon, color: iconColor, size: 24.0),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHighlightedText(
                    result.title,
                    _searchController.text,
                  ),
                  // Text(
                  //   result.title,
                  //   style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  //         fontWeight: FontWeight.w600,
                  //       ),
                  //   maxLines: 2,
                  //   overflow: TextOverflow.ellipsis,
                  // ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                        decoration: BoxDecoration(
                          color: iconColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          typeLabel,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: iconColor,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                      if (result.subtitle != null && result.type != SearchResultType.song) ...[
                        const SizedBox(width: 8.0),
                        Text(
                          result.subtitle!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Color.fromRGBO(140, 147, 159, 1),
                              ),
                        ),
                      ],
                      if (result.songbookTitle != null) ...[
                        const SizedBox(width: 8.0),
                        Flexible(
                          child: Text(
                            '• ${result.songbookTitle}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Color.fromRGBO(140, 147, 159, 1),
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Color.fromRGBO(140, 147, 159, 1)),
          ],
        ),
      ),
    );
  }
}
