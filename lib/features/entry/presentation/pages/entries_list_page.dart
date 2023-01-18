import 'package:ezpark/core/resposivity/extensions/resizer_extension.dart';
import 'package:ezpark/core/theme/colors/colors.dart';
import 'package:ezpark/core/theme/components/snackbar.dart';
import 'package:ezpark/features/entry/providers/entries_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/sizes/spacings.dart';
import '../../domain/entities/entry.dart';

class EntriesListPage extends StatelessWidget {
  const EntriesListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entradas'),
        elevation: 3,
        shadowColor: Colors.black,
      ),
      body: const _EntriesList(),
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
            ? ListView(
                padding: const EdgeInsets.all(Spacings.m),
                children: [
                  for (final entry in entries)
                    Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.only(left: Spacings.m),
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
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.grey,
                              ),
                              onPressed: () => print(''),
                              padding: EdgeInsets.zero,
                              alignment: Alignment.centerRight,
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline_outlined,
                                color: Colors.red,
                              ),
                              padding: EdgeInsets.zero,
                              onPressed: () => _showdeleteConfirmationDialog(
                                entryID: entry.id,
                              ),
                            )
                          ],
                        ),
                      ),
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
      error: (error, stackTrace) {
        return SizedBox.shrink();
      },
      loading: () {
        return CircularProgressIndicator();
      },
    );
  }

  Future<dynamic> _showdeleteConfirmationDialog({
    required String entryID,
  }) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Deseja apagar a entrada?',
            style: textTheme.titleMedium!.copyWith(
              color: colorScheme.error,
            ),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      style: BorderStyle.solid,
                      color: AppColors.neutral100,
                    ),
                  ),
                  child: Text(
                    'Cancelar',
                    style: textTheme.displaySmall!.copyWith(
                      color: AppColors.neutral100,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: Spacings.m,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ref
                        .read(entriesListProvider.notifier)
                        .delete(
                          entryId: entryID,
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
                  style: ElevatedButton.styleFrom(
                    primary: colorScheme.error,
                    elevation: 2,
                    shadowColor: Colors.black,
                    onPrimary: Theme.of(context).colorScheme.error,
                  ),
                  child: Text(
                    'Apagar',
                    style: textTheme.displaySmall!.copyWith(
                      color: AppColors.neutral1,
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
