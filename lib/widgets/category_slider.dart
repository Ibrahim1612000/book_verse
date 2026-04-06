import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';

class CategorySlider extends StatelessWidget {
  const CategorySlider({super.key});

  final List<String> categories = const [
    'Fiction',
    'Science',
    'Technology',
    'Business',
    'History',
    'Programming',
  ];

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);
    final theme = Theme.of(context);

    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = bookProvider.currentCategory == category;

          return ActionChip(
            label: Text(category),
            labelStyle: theme.textTheme.labelMedium?.copyWith(
              color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            backgroundColor: isSelected ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9999),
              side: isSelected 
                  ? BorderSide.none
                  : BorderSide(color: theme.colorScheme.outlineVariant, width: 0.5),
            ),
            onPressed: () {
              bookProvider.setCategory(category);
            },
          );
        },
      ),
    );
  }
}
