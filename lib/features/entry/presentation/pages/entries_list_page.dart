import 'package:ezpark/core/resposivity/extensions/resizer_extension.dart';
import 'package:ezpark/core/theme/colors/colors.dart';
import 'package:ezpark/features/entry/providers/entries_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/sizes/spacings.dart';

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

    final entriesProvider = ref.watch(entriesListProvider);
    return entriesProvider.when(
      data: (entries) {
        return ListView(
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
                              Shadow(color: Colors.black, blurRadius: 2.width)
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
                        'Entrada: ${DateFormat("dd/MM/yyyy - H:mm").format(entry.entryTime)} ',
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
                        onPressed: () => print(''),
                      )
                    ],
                  ),
                ),
              ),
          ],
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
}
