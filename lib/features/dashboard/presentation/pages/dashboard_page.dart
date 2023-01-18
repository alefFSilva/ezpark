import 'package:ezpark/core/resposivity/extensions/resizer_extension.dart';
import 'package:ezpark/core/sizes/font_size.dart';
import 'package:ezpark/core/sizes/spacings.dart';
import 'package:ezpark/core/theme/colors/colors.dart';
import 'package:ezpark/features/spots/enums/spot_form_action.dart';
import 'package:ezpark/features/spots/presentation/spot_dialog.dart';
import 'package:ezpark/features/spots/providers/spots_counter_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/route/router.dart';

class DashBoardPage extends StatelessWidget {
  const DashBoardPage({Key? key}) : super(key: key);

  final List<Widget> dashboardOption = const [
    _AddNewEntryCard(),
    _EntriesListCard(),
    _RegisterNewSpotCard(),
    _ReportCard(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EzPark'),
        elevation: 3,
        shadowColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(Spacings.xs),
        child: Column(
          children: [
            const Flexible(
              flex: 2,
              child: _SpotsCard(),
            ),
            Flexible(
              flex: 5,
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: dashboardOption.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) => dashboardOption[index],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddNewEntryCard extends StatelessWidget {
  const _AddNewEntryCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return _DashboardCard(
      title: '',
      onTap: () => context.push(Routes.newEntryPage.description),
      child: Column(
        children: [
          Icon(
            Icons.directions_car_outlined,
            color: colorScheme.primary.withOpacity(.7),
            size: 44.width,
          ),
          const SizedBox(
            height: Spacings.xs,
          ),
          Text(
            'Nova entrada',
            style: textTheme.displayMedium!.copyWith(
              color: colorScheme.primary,
            ),
          )
        ],
      ),
    );
  }
}

class _EntriesListCard extends StatelessWidget {
  const _EntriesListCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return _DashboardCard(
        title: '',
        onTap: () => context.push(Routes.entriesListPage.description),
        child: Column(
          children: [
            Icon(
              Icons.format_list_bulleted_outlined,
              color: colorScheme.primary.withOpacity(.7),
              size: 44.width,
            ),
            const SizedBox(
              height: Spacings.xs,
            ),
            Text(
              'Entradas',
              textAlign: TextAlign.center,
              style: textTheme.displayMedium!.copyWith(
                color: colorScheme.primary,
              ),
            ),
          ],
        ));
  }
}

class _SpotsCard extends ConsumerWidget {
  const _SpotsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: _DashboardCard(
            title: 'Vagas',
            child: Builder(builder: (context) {
              final spotsCounter = ref.watch(spotsCounterProvider);
              return spotsCounter.when(
                loading: () => const CircularProgressIndicator(),
                error: (err, stack) => Text('Error: $err'),
                data: (response) {
                  final counter = response.data;

                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const _CardTextLine('Disponíveis:'),
                          _CardTextLine(
                            counter!.spotsAvaliable.toString(),
                            textColor: Colors.green,
                            fontWeight: FontWeight.w600,
                            fontSize: FontSize.rg,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const _CardTextLine('Ocupadas:'),
                          _CardTextLine(
                            counter.spotsOcuppied.toString(),
                            textColor: Colors.red,
                            fontWeight: FontWeight.w600,
                            fontSize: FontSize.rg,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const _CardTextLine(
                            'Total de vagas:',
                          ),
                          _CardTextLine(
                            counter.spotTotal.toString(),
                            textColor: Colors.black,
                            fontSize: FontSize.rg,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 18.height,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 180.width,
                            child: OutlinedButton(
                              onPressed: () => context.push(
                                Routes.spotsList.description,
                              ),
                              style: OutlinedButton.styleFrom(
                                elevation: 3.height,
                                shadowColor: Colors.black,
                                backgroundColor: colorScheme.secondary,
                                side: BorderSide(
                                  style: BorderStyle.solid,
                                  color: colorScheme.primary,
                                ),
                              ),
                              child: Text(
                                'Ver Vagas',
                                textAlign: TextAlign.center,
                                style: textTheme.displaySmall!.copyWith(
                                  color: AppColors.neutral500,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                },
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _RegisterNewSpotCard extends StatelessWidget {
  const _RegisterNewSpotCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return _DashboardCard(
      title: '',
      onTap: () => showDialog(
        context: context,
        builder: (context) {
          return const SpotDialog(
            spotFormAction: RespositoryAction.add,
          );
        },
      ),
      child: Column(
        children: [
          Icon(
            Icons.add_circle_outline_outlined,
            color: colorScheme.primary.withOpacity(.7),
            size: 44.width,
          ),
          const SizedBox(
            height: Spacings.xs,
          ),
          Text(
            'Cadastrar',
            textAlign: TextAlign.center,
            style: textTheme.displayMedium!.copyWith(
              color: colorScheme.primary,
            ),
          ),
          Text(
            'Nova vaga',
            textAlign: TextAlign.center,
            style: textTheme.displayMedium!.copyWith(
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return _DashboardCard(
      onTap: () => context.push(
        Routes.reportPage.description,
      ),
      child: Column(
        children: [
          Icon(
            Icons.analytics_outlined,
            color: colorScheme.primary.withOpacity(.7),
            size: 44.width,
          ),
          const SizedBox(
            height: Spacings.xs,
          ),
          Text(
            'Relatório',
            textAlign: TextAlign.center,
            style: textTheme.displayMedium!.copyWith(
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _CardTextLine extends StatelessWidget {
  const _CardTextLine(
    this.text, {
    this.textColor,
    this.fontWeight,
    this.fontSize,
    Key? key,
  }) : super(key: key);

  final String text;
  final Color? textColor;
  final FontWeight? fontWeight;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Text(
      text,
      textAlign: TextAlign.center,
      style: textTheme.labelSmall!.copyWith(
        color: textColor ?? AppColors.neutral500,
        fontWeight: fontWeight,
        fontSize: fontSize,
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({
    this.title,
    required this.child,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final String? title;
  final void Function()? onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Container(
          padding: const EdgeInsets.only(
            top: Spacings.xs,
            right: Spacings.xs,
            bottom: Spacings.xxs,
            left: Spacings.xs,
          ),
          color: Colors.white,
          child: Column(
            children: [
              Text(
                title ?? '',
                textAlign: TextAlign.center,
                style:
                    textTheme.titleMedium!.copyWith(color: colorScheme.primary),
              ),
              SizedBox(
                height: Spacings.xxs.height,
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
