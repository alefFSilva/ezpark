import 'package:ezpark/features/entry/providers/today_report_entries_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/entries_list.dart';

class TodayEntriesReportPage extends StatelessWidget {
  const TodayEntriesReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entradas do dia'),
        elevation: 3,
        shadowColor: Colors.black,
      ),
      body: Consumer(builder: (_, WidgetRef ref, __) {
        return EntriesList(
          entriesAsyncValues: ref.watch(
            todayEntriesReportProvider,
          ),
        );
      }),
    );
  }
}
