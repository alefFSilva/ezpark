import 'package:ezpark/core/resposivity/extensions/resizer_extension.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/sizes/spacings.dart';
import '../../../../core/theme/colors/colors.dart';
import '../../domain/entities/entry.dart';
import 'entry_card.dart';

class EntriesList extends ConsumerWidget {
  const EntriesList({
    required AsyncValue<List<Entry>> entriesAsyncValues,
    super.key,
  }) : _entriesAsyncValues = entriesAsyncValues;

  final AsyncValue<List<Entry>> _entriesAsyncValues;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return _entriesAsyncValues.when(
      data: (List<Entry> entries) {
        return entries.isNotEmpty
            ? ListView(
                padding: const EdgeInsets.all(Spacings.m),
                children: [
                  for (final entry in entries) EntryCard(entry: entry),
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.sentiment_dissatisfied_outlined,
                      color: Theme.of(context).colorScheme.primary,
                      size: 40.width,
                    ),
                    Text(
                      'Nenhuma entrada encontrada',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ],
                ),
              );
      },
      error: (error, stackTrace) {
        return Center(
          child: Text(
            'Ops, algum erro aconteceu',
            style: textTheme.bodySmall!.copyWith(
              color: AppColors.supportError,
            ),
          ),
        );
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
