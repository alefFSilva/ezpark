import 'package:ezpark/core/resposivity/extensions/resizer_extension.dart';
import 'package:ezpark/core/route/router.dart';
import 'package:ezpark/features/entry/providers/entries_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../widgets/entries_list.dart';

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
      body: Consumer(
        builder: (_, WidgetRef ref, __) => EntriesList(
          entriesAsyncValues: ref.watch(
            entriesListProvider,
          ),
        ),
      ),
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
