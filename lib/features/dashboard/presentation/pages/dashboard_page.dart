import 'package:ezpark/core/resposivity/extensions/resizer_extension.dart';
import 'package:ezpark/core/sizes/font_size.dart';
import 'package:ezpark/core/sizes/spacings.dart';
import 'package:ezpark/core/theme/colors/colors.dart';
import 'package:ezpark/core/theme/components/loading/loading_overlay.dart';
import 'package:ezpark/features/spots/enums/spot_form_action.dart';
import 'package:ezpark/features/spots/presentation/spot_dialog.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/route/router.dart';

class DashBoardPage extends StatelessWidget {
  const DashBoardPage({Key? key}) : super(key: key);

  final List<Widget> dashboardOption = const [
    _AddNewEntryCard(),
    _SpotsCard(),
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
      body: LoadingOverlay(
        child: Padding(
          padding: const EdgeInsets.all(Spacings.xs),
          child: GridView.builder(
            itemCount: dashboardOption.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) => dashboardOption[index],
          ),
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

class _SpotsCard extends StatelessWidget {
  const _SpotsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return _DashboardCard(
      onTap: () => context.push(
        Routes.spotsList.description,
      ),
      title: 'Vagas',
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _CardTextLine('Disponíveis:'),
              _CardTextLine(
                '32',
                textColor: Colors.green,
                fontWeight: FontWeight.w600,
                fontSize: FontSize.rg,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _CardTextLine('Ocupadas:'),
              _CardTextLine(
                '10',
                textColor: Colors.red,
                fontWeight: FontWeight.w600,
                fontSize: FontSize.rg,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const <Widget>[
              _CardTextLine(
                'Total de vagas:',
              ),
              _CardTextLine(
                '42',
                textColor: Colors.black,
                fontSize: FontSize.rg,
              ),
            ],
          ),
          SizedBox(
            height: 10.height,
          ),
          Text(
            'Ver Vagas',
            textAlign: TextAlign.center,
            style: textTheme.displaySmall!.copyWith(
              color: AppColors.neutral500,
              decoration: TextDecoration.underline,
              letterSpacing: 1,
            ),
          )
        ],
      ),
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
            spotFormAction: SpotFormAction.add,
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
      title: '',
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
    required this.title,
    required this.child,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final String title;
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
                title,
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
