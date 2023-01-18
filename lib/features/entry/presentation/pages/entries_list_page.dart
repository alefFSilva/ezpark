import 'package:ezpark/core/resposivity/extensions/resizer_extension.dart';
import 'package:ezpark/core/route/router.dart';
import 'package:ezpark/core/theme/colors/colors.dart';
import 'package:ezpark/core/theme/components/snackbar.dart';
import 'package:ezpark/features/entry/enums/entry_status.dart';
import 'package:ezpark/features/entry/providers/entries_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/sizes/spacings.dart';
import '../../../../core/theme/components/custom_alert_dialog.dart';
import '../../domain/entities/entry.dart';

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

    ref.listen(entriesListProvider, (_, state) {});

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
                    for (final entry in entries)
                      Card(
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.only(left: Spacings.m),
                          title: Row(
                            children: [
                              Text(
                                '${entry.vehicleName} - ',
                                style: textTheme.titleMedium!.copyWith(
                                  color: AppColors.neutral600,
                                ),
                              ),
                              Text(
                                '${entry.vehiclePlate} ',
                                style: textTheme.titleMedium!
                                    .copyWith(color: AppColors.neutral500),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Cor: ',
                                    style: textTheme.titleSmall!.copyWith(
                                      color: AppColors.neutral400,
                                    ),
                                  ),
                                  Icon(
                                    Icons.square,
                                    size: 20.width,
                                    color: entry.vehicleColor.color,
                                    shadows: [
                                      Shadow(
                                          color: Colors.black,
                                          blurRadius: 2.width)
                                    ],
                                  ),
                                ],
                              ),
                              Text(
                                'Nº da Vaga: ${entry.spot.number} ',
                                style: textTheme.titleSmall!.copyWith(
                                  color: AppColors.neutral400,
                                ),
                              ),
                              Text(
                                'Entrada: ${DateFormat("dd/MM/yyyy - H:mm").format(
                                  entry.entryTime,
                                )} ',
                                style: textTheme.titleSmall!.copyWith(
                                  color: AppColors.neutral400,
                                ),
                              ),
                              (entry.status == EntryStatus.completed &&
                                      entry.completedTime != null)
                                  ? Text(
                                      'Saída: ${DateFormat("dd/MM/yyyy - H:mm").format(
                                        entry.completedTime!,
                                      )} ',
                                      style: textTheme.titleSmall!.copyWith(
                                        color: AppColors.neutral400,
                                      ),
                                    )
                                  : _CompleteEntryButton(entry: entry),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline_outlined,
                                  color: Colors.red,
                                ),
                                padding: EdgeInsets.zero,
                                onPressed: () => _showdeleteConfirmationDialog(
                                  entryID: entry.id,
                                  spotNumber: entry.spot.number,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
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
        return SizedBox.shrink();
      },
      loading: () {
        return const CircularProgressIndicator();
      },
    );
  }

  Future<dynamic> _showdeleteConfirmationDialog({
    required String entryID,
    required int spotNumber,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          message: 'Deseja apagar a entrada?',
          onPressed: () {
            ref
                .read(entriesListProvider.notifier)
                .delete(
                  entryId: entryID,
                  spotNumber: spotNumber,
                )
                .then(
              (value) {
                ref.read(entriesListProvider.notifier).refresh();
                showSnackBarMessage(
                  context,
                  message: 'Entrada deletada com sucesso',
                );

                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }
}

class _CompleteEntryButton extends ConsumerWidget {
  const _CompleteEntryButton({
    Key? key,
    required this.entry,
  }) : super(key: key);

  final Entry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        OutlinedButton(
          onPressed: (() {
            showDialog(
              context: context,
              builder: (context) {
                return CustomAlertDialog(
                  message: 'Deseja confirmar a saída deste veículo?',
                  onPressed: () {
                    ref
                        .read(entriesListProvider.notifier)
                        .setStatus(
                          entryID: entry.id,
                          spotNumber: entry.spot.number,
                          status: EntryStatus.completed,
                        )
                        .then(
                      (response) {
                        response.success
                            ? showSnackBarMessage(context,
                                message: 'Saída realizada com sucesso')
                            : showSnackBarMessage(
                                context,
                                message: response.errorMessage!,
                              );
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              },
            );
          }),
          style: OutlinedButton.styleFrom(
            elevation: 1.height,
            shadowColor: Colors.black,
            backgroundColor: colorScheme.secondary,
            side: BorderSide(
              style: BorderStyle.solid,
              color: colorScheme.secondary,
            ),
          ),
          child: Text(
            'Registrar saída',
            style: textTheme.bodySmall!.copyWith(
              color: colorScheme.error,
            ),
          ),
        ),
      ],
    );
  }
}
