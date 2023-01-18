import 'package:ezpark/core/resposivity/extensions/resizer_extension.dart';
import 'package:ezpark/core/route/router.dart';
import 'package:ezpark/features/entry/providers/entries_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/sizes/spacings.dart';
import '../../../../core/theme/colors/colors.dart';
import '../../domain/entities/entry.dart';
import '../widgets/entry_card.dart';

class EntriesListPage extends StatelessWidget {
  const EntriesListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entradas'),
        elevation: 3,
        shadowColor: Colors.black,
      ),
      body: const _EntriesList(),
      floatingActionButton: OutlinedButton(
        onPressed: () => context.replace(
          Routes.newEntryPage.description,
        ),
        style: OutlinedButton.styleFrom(
          elevation: 4.height,
          shadowColor: Colors.black,
          backgroundColor: colorScheme.secondary,
          side: BorderSide(
            style: BorderStyle.solid,
            color: colorScheme.secondary,
          ),
        ),
        child: Text(
          'Nova entrada',
          style: textTheme.labelMedium!.copyWith(color: colorScheme.primary),
        ),
      ),
    );
  }
}

class _EntriesList extends ConsumerStatefulWidget {
  const _EntriesList();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EntriesListState();
}

class _EntriesListState extends ConsumerState<_EntriesList> {
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    final entriesProvider = ref.watch(entriesListProvider);

    return entriesProvider.when(
      data: (List<Entry> entries) {
        return entries.isNotEmpty
            ? RefreshIndicator(
                onRefresh: () => ref
                    .read(
                      entriesListProvider.notifier,
                    )
                    .refresh(),
                child: ListView(
                  padding: const EdgeInsets.all(Spacings.m),
                  children: [
                    for (final entry in entries) EntryCard(entry: entry),
                  ],
                ),
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
