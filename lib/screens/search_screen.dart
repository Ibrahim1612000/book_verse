import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import '../widgets/book_card.dart';
import '../widgets/search_bar_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final provider = Provider.of<BookProvider>(context, listen: false);
      if (_searchController.text.isNotEmpty) {
        provider.searchBooks(_searchController.text, loadMore: true);
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bookProvider = Provider.of<BookProvider>(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text('Search', style: theme.textTheme.headlineMedium),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: SearchBarWidget(
              controller: _searchController,
              onSubmitted: (query) {
                bookProvider.searchBooks(query);
              },
            ),
          ),
          Expanded(
            child: bookProvider.isLoadingSearch
                ? const Center(child: CircularProgressIndicator())
                : bookProvider.searchError != null
                    ? Center(
                        child: Text(
                          bookProvider.searchError!,
                          style: TextStyle(color: theme.colorScheme.error),
                        ),
                      )
                    : bookProvider.searchResults.isEmpty
                        ? Center(
                            child: Text(
                              _searchController.text.isEmpty
                                  ? 'Type to begin searching'
                                  : 'No books found',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.5),
                              ),
                            ),
                          )
                        : GridView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(24),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.6,
                              mainAxisSpacing: 24,
                              crossAxisSpacing: 16,
                            ),
                            itemCount: bookProvider.searchResults.length + (bookProvider.hasMoreSearch ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == bookProvider.searchResults.length) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              return BookCard(book: bookProvider.searchResults[index]);
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
