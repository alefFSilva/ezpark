import 'package:ezpark/core/resposivity/extensions/resizer_extension.dart';
import 'package:ezpark/core/sizes/font_size.dart';
import 'package:ezpark/core/sizes/spacings.dart';
import 'package:ezpark/core/theme/components/custom_alert_dialog.dart';
import 'package:ezpark/features/spots/enums/spot_form_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/spot.dart';
import '../spot_dialog.dart';
import '../../providers/spots_list_provider.dart';

class SpotsListPage extends StatelessWidget {
  const SpotsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas vagas'),
        elevation: 3,
        shadowColor: Colors.black,
      ),
      body: const _SpotList(),
    );
  }
}

class _SpotList extends ConsumerWidget {
  const _SpotList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncSpots = ref.watch(spotsListProvider);
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return asyncSpots.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Center(
        child: Text('Error!'),
      ),
      data: (List<Spot> spots) {
        return spots.isNotEmpty
            ? RefreshIndicator(
                onRefresh: () => ref.read(spotsListProvider.notifier).refresh(),
                child: ListView(
                  padding: const EdgeInsets.all(Spacings.m),
                  children: <Widget>[
                    for (final spot in spots)
                      Card(
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.only(left: Spacings.m),
                          title: Row(
                            children: [
                              Text(
                                'Vaga ${spot.number} - ',
                                style: const TextStyle(
                                  color: Colors.black,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                spot.spotStatus.description,
                                style: TextStyle(
                                  color: spot.spotStatus.color,
                                  fontSize: FontSize.defaultSize,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Row(
                            children: [
                              Text(
                                'Tipo: ${spot.spotType.description} - ',
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              Icon(spot.spotType.icon)
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
                                    number: spot.number,
                                    spotType: spot.spotType,
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
                                  spot,
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
                      'Nenhuma vaga encontrada',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ],
                ),
              );
      },
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
