import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import '../widgets/book_card.dart';
import '../widgets/category_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      Provider.of<BookProvider>(context, listen: false).fetchHomeBooks(loadMore: true);
    }
  }

  @override
  void dispose() {
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
        title: Text('BookVerse', style: theme.textTheme.headlineMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              'Curated for you',
              style: theme.textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 8),
          const CategorySlider(),
          const SizedBox(height: 16),
          Expanded(
            child: bookProvider.isLoadingHome
                ? const Center(child: CircularProgressIndicator())
                : bookProvider.homeError != null
                    ? Center(
                        child: Text(
                          bookProvider.homeError!,
                          style: TextStyle(color: theme.colorScheme.error),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          await bookProvider.fetchHomeBooks();
                        },
                        child: GridView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(24),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.6,
                            mainAxisSpacing: 24,
                            crossAxisSpacing: 16,
                          ),
                          itemCount: bookProvider.homeBooks.length + (bookProvider.hasMoreHome ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == bookProvider.homeBooks.length) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            return BookCard(book: bookProvider.homeBooks[index]);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
