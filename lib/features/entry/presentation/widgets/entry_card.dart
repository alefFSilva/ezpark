import 'package:ezpark/core/resposivity/extensions/resizer_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/sizes/spacings.dart';
import '../../../../core/theme/colors/colors.dart';
import '../../../../core/theme/components/custom_alert_dialog.dart';
import '../../../../core/theme/components/snackbar.dart';
import '../../domain/entities/entry.dart';
import '../../enums/entry_status.dart';
import '../../providers/entries_list_provider.dart';

class EntryCard extends ConsumerWidget {
  const EntryCard({
    required Entry entry,
    bool hideButtons = false,
    super.key,
  })  : _entry = entry,
        _hideButtons = hideButtons;

  final Entry _entry;
  final bool _hideButtons;

  @override
  Widget build(BuildContext context, ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: Spacings.m),
        title: Row(
          children: [
            Text(
              '${_entry.vehicleName} - ',
              style: textTheme.titleMedium!.copyWith(
                color: AppColors.neutral600,
              ),
            ),
            Text(
              '${_entry.vehiclePlate} ',
              style:
                  textTheme.titleMedium!.copyWith(color: AppColors.neutral500),
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
                  color: _entry.vehicleColor.color,
                  shadows: [Shadow(color: Colors.black, blurRadius: 2.width)],
                ),
              ],
            ),
            Text(
              'Nº da Vaga: ${_entry.spot.number} ',
              style: textTheme.titleSmall!.copyWith(
                color: AppColors.neutral400,
              ),
            ),
            Text(
              'Entrada: ${DateFormat("dd/MM/yyyy - H:mm").format(
                _entry.entryTime,
              )} ',
              style: textTheme.titleSmall!.copyWith(
                color: AppColors.neutral400,
              ),
            ),
            (_entry.status == EntryStatus.completed &&
                    _entry.completedTime != null)
                ? Text(
                    'Saída: ${DateFormat("dd/MM/yyyy - H:mm").format(
                      _entry.completedTime!,
                    )} ',
                    style: textTheme.titleSmall!.copyWith(
                      color: AppColors.neutral400,
                    ),
                  )
                : Visibility(
                    visible: !_hideButtons,
                    child: _CompleteEntryButton(entry: _entry),
                  ),
          ],
        ),
        trailing: Visibility(
          visible: !_hideButtons,
          child: Row(
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
                  context,
                  ref,
                  entryID: _entry.id,
                  spotNumber: _entry.spot.number,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> _showdeleteConfirmationDialog(
    BuildContext context,
    WidgetRef ref, {
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
