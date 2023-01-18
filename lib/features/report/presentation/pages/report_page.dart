import 'package:ezpark/core/resposivity/extensions/resizer_extension.dart';
import 'package:ezpark/features/report/providers/today_report_entries_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/sizes/spacings.dart';
import '../../../entry/domain/entities/entry.dart';
import '../../../entry/presentation/widgets/entry_card.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entradas do dia'),
        elevation: 3,
        shadowColor: Colors.black,
      ),
      body: const _EntriesList(),
    );
  }
}

@immutable
class _EntriesList extends ConsumerWidget {
  const _EntriesList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesProvider = ref.watch(todayEntriesReportProvider);

    return entriesProvider.when(
      data: (List<Entry> entries) {
        return entries.isNotEmpty
            ? ListView(
                padding: const EdgeInsets.all(Spacings.m),
                children: [
                  for (final entry in entries)
                    EntryCard(
                      entry: entry,
                      hideButtons: true,
                    ),
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
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
      error: (error, stackTrace) {
        return const SizedBox.shrink();
      },
    );
  }
}
