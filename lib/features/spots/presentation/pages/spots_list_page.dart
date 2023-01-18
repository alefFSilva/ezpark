import 'package:ezpark/core/sizes/font_size.dart';
import 'package:ezpark/core/sizes/spacings.dart';
import 'package:ezpark/core/theme/components/custom_alert_dialog.dart';
import 'package:ezpark/core/theme/components/custom_page_scaffold.dart';
import 'package:ezpark/core/theme/components/no_data_founded.dart';
import 'package:ezpark/features/spots/enums/spot_form_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/components/some_error_ocurred.dart';
import '../../domain/entities/spot.dart';
import '../spot_dialog.dart';
import '../../providers/spots_list_provider.dart';

class SpotsListPage extends StatelessWidget {
  const SpotsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const CustomPageScaffold(
        pageTitle: 'Minhas vagas',
        body: _SpotList(),
      );
}

class _SpotList extends ConsumerWidget {
  const _SpotList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncSpots = ref.watch(spotsListProvider);

    return asyncSpots.when(
      error: (error, stackTrace) => const SomeErrorOcurred(),
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      data: (List<Spot> spots) {
        return spots.isNotEmpty
            ? RefreshIndicator(
                onRefresh: () => ref.read(spotsListProvider.notifier).refresh(),
                child: ListView(
                  children: <Widget>[
                    for (final spot in spots) _SpotCard(spot: spot),
                  ],
                ),
              )
            : const NoDataFounded(
                message: 'Nenhuma vaga encontrada',
              );
      },
    );
  }
}

class _SpotCard extends ConsumerWidget {
  const _SpotCard({
    required Spot spot,
    Key? key,
  })  : _spot = spot,
        super(key: key);

  final Spot _spot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: Spacings.m),
        title: Row(
          children: [
            Text(
              'Vaga ${_spot.number} - ',
              style: const TextStyle(
                color: Colors.black,
                overflow: TextOverflow.ellipsis,
                fontSize: FontSize.md,
              ),
            ),
            Text(
              _spot.spotStatus.description,
              style: TextStyle(
                color: _spot.spotStatus.color,
                fontSize: FontSize.defaultSize,
              ),
            ),
          ],
        ),
        subtitle: Row(
          children: [
            Text(
              'Tipo: ${_spot.spotType.description} - ',
              style: const TextStyle(
                color: Colors.black,
                fontSize: FontSize.defaultSize,
              ),
            ),
            Icon(_spot.spotType.icon)
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
              onPressed: () => showDialog(
                context: context,
                builder: (_) => SpotDialog(
                  spotFormAction: RespositoryAction.edit,
                  number: _spot.number,
                  spotType: _spot.spotType,
                ),
              ),
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
                context,
                ref,
                _spot,
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<dynamic> _showdeleteConfirmationDialog(
    BuildContext context,
    WidgetRef ref,
    Spot spot,
  ) {
    return showDialog(
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          message: 'Deseja apagar a vaga?',
          onPressed: () {
            ref.read(spotsListProvider.notifier).delete(
                  spotNumber: spot.number,
                );
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
