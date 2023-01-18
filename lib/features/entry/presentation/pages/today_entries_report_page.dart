import 'package:ezpark/core/theme/components/custom_page_scaffold.dart';
import 'package:ezpark/features/entry/providers/today_report_entries_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/entries_list.dart';

class TodayEntriesReportPage extends StatelessWidget {
  const TodayEntriesReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPageScaffold(
      pageTitle: 'Entradas do dia',
      body: Consumer(
        builder: (_, WidgetRef ref, __) => EntriesList(
          entriesAsyncValues: ref.watch(
            todayEntriesReportProvider,
          ),
        ),
      ),
    );
  }
}
