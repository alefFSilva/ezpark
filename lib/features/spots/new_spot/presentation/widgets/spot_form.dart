import 'package:ezpark/core/resposivity/extensions/resizer_extension.dart';
import 'package:ezpark/core/route/router.dart';
import 'package:ezpark/features/spots/enums/spot_form_action.dart';
import 'package:ezpark/features/spots/enums/spot_status.dart';
import 'package:ezpark/features/spots/providers/add_spot_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/network/response/entities/response_result.dart';
import '../../../../../core/sizes/spacings.dart';
import '../../../../../core/theme/colors/colors.dart';
import '../../../../../core/theme/components/loading/loading_overlay.dart';
import '../../../domain/entities/add_spot.dart';
import '../../../domain/entities/spot.dart';
import '../../../enums/spot_type.dart';
import '../../../providers/add_spot_provider.dart';
import '../../../providers/spots_list_provider.dart';

class SpotForm extends ConsumerStatefulWidget {
  const SpotForm({
    Key? key,
    required this.spotFormAction,
    this.number,
    this.spotType,
  }) : super(key: key);

  final int? number;
  final SpotType? spotType;
  final SpotFormAction spotFormAction;

  @override
  ConsumerState<SpotForm> createState() => _SpotFormState();
}

class _SpotFormState extends ConsumerState<SpotForm> {
  late final TextEditingController _spotDescription;
  SpotType? _selectedSpotType;

  @override
  void initState() {
    super.initState();
    _selectedSpotType = _selectedSpotType ?? widget.spotType;
    _spotDescription = TextEditingController();

    if (widget.number != null) {
      _spotDescription.text = widget.number.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    _setResponseListener(context);

    return Padding(
      padding: const EdgeInsets.all(Spacings.xs),
      child: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: _TextFormField(
                controller: _spotDescription,
                labelText: 'Número da vaga',
                onChanged: null,
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(
              height: Spacings.m.height,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: DropdownButton(
                    underline: Container(
                      height: .5.height,
                      color: colorScheme.primary,
                    ),
                    icon: Icon(
                      Icons.expand_more_outlined,
                      color: colorScheme.primary,
                    ),
                    alignment: Alignment.center,
                    value: _selectedSpotType,
                    hint: Text(
                      'Tipo de veículo',
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: AppColors.neutral500,
                          ),
                    ),
                    dropdownColor: AppColors.neutral50,
                    items: <DropdownMenuItem<SpotType>>[
                      DropdownMenuItem(
                        value: SpotType.car,
                        child: Center(
                          child: Text(
                            SpotType.car.description,
                            style: textTheme.labelSmall!.copyWith(
                              color: AppColors.neutral500,
                            ),
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: SpotType.motorcycle,
                        child: Center(
                          child: Text(
                            SpotType.motorcycle.description,
                            style: textTheme.labelSmall!.copyWith(
                              color: AppColors.neutral500,
                            ),
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: SpotType.truck,
                        child: Center(
                          child: Text(
                            SpotType.truck.description,
                            style: textTheme.labelSmall!.copyWith(
                              color: AppColors.neutral500,
                            ),
                          ),
                        ),
                      ),
                    ],
                    onChanged: (SpotType? value) {
                      setState(() {
                        _selectedSpotType = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    onPressed: (_selectedSpotType != null &&
                            _spotDescription.text.isNotEmpty)
                        ? () => _saveSpot()
                        : null,
                    style: ElevatedButton.styleFrom(
                      primary: colorScheme.primary,
                      elevation: 2,
                      shadowColor: Colors.black,
                      onPrimary: Theme.of(context).colorScheme.onPrimary,
                    ),
                    child: Text(
                      'Salvar',
                      style: textTheme.displaySmall!.copyWith(
                        color: AppColors.neutral1,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _toggleLoading() => ref.read(loadingOverlayProvider.notifier).toggle();
  void _setResponseListener(BuildContext context) =>
      ref.listen<AsyncValue<ResponseResult>>(
        spotNotiferProvider,
        (_, state) {
          if (!state.isLoading &&
              (state.value != null && !state.value!.success)) {
            _toggleLoading();
            _showSnackBarMessage(
              message: state.value!.errorMessage!,
              isAnErrorMessage: true,
            );
          } else if (state.value != null && state.value!.success) {
            _toggleLoading();
            Navigator.pop(context);
            if (widget.spotFormAction == SpotFormAction.add) {
              context.push(Routes.spotsList.description);
            }

            String messageOperation =
                widget.spotFormAction == SpotFormAction.add
                    ? 'cadastrada'
                    : 'editada';
            _showSnackBarMessage(
              message: 'Vaga $messageOperation com sucesso!',
            );
          }
        },
      );

  void _showSnackBarMessage({
    required String message,
    bool isAnErrorMessage = false,
  }) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: isAnErrorMessage
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).colorScheme.primary,
          content: Text(
            message,
            style: TextStyle(
              color: isAnErrorMessage
                  ? Theme.of(context).colorScheme.onError
                  : Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      );

  void _saveSpot() {
    _toggleLoading();
    ref
        .read(spotNotiferProvider.notifier)
        .saveSpot(
          Spot(
            number: int.parse(_spotDescription.text),
            spotType: _selectedSpotType!,
            spotStatus: SpotStatus.active,
          ),
          widget.spotFormAction,
        )
        .then(
          (value) => ref.read(spotsListProvider.notifier).refresh(),
        );
  }
}

class _TextFormField extends StatelessWidget {
  const _TextFormField({
    Key? key,
    required this.controller,
    required this.onChanged,
    required this.labelText,
    this.keyboardType,
    this.validator,
  }) : super(key: key);

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? Function(String? p1)? validator;
  final String labelText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      keyboardType: keyboardType,
      cursorColor: AppColors.neutral50,
      textAlign: TextAlign.center,
      style: textTheme.displayMedium!.copyWith(
        color: AppColors.neutral400,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        labelText: labelText,
        errorStyle: TextStyle(
          color: colorScheme.error,
        ),
        labelStyle: textTheme.labelSmall!.copyWith(
          color: AppColors.neutral500,
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.error,
          ),
        ),
      ),
    );
  }
}