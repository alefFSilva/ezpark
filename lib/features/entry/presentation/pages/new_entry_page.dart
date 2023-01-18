import 'package:ezpark/core/resposivity/extensions/resizer_extension.dart';
import 'package:ezpark/core/sizes/spacings.dart';
import 'package:ezpark/core/theme/colors/colors.dart';
import 'package:ezpark/core/theme/components/snackbar.dart';
import 'package:ezpark/features/entry/enums/entry_status.dart';
import 'package:ezpark/features/entry/providers/entries_list_provider.dart';
import 'package:ezpark/features/spots/enums/spot_form_action.dart';
import 'package:ezpark/features/spots/enums/spot_status.dart';
import 'package:ezpark/features/spots/providers/spots_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/network/response/entities/response_result.dart';
import '../../../../core/route/router.dart';
import '../../../../core/theme/components/custom_page_scaffold.dart';
import '../../../../core/theme/components/custom_text_form_field.dart';
import '../../../spots/domain/entities/spot.dart';
import '../../domain/entities/entry.dart';
import '../../enums/vehicle_colors_options.dart';
import '../../providers/entry_provider.dart';

class NewEntryPage extends StatelessWidget {
  const NewEntryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CustomPageScaffold(
      pageTitle: 'Nova entrada',
      body: _NewEntryForm(),
    );
  }
}

class _NewEntryForm extends ConsumerStatefulWidget {
  const _NewEntryForm({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<_NewEntryForm> createState() => _NewEntryFormState();
}

class _NewEntryFormState extends ConsumerState<_NewEntryForm> {
  late final TextEditingController _vehicleNameController;
  late final TextEditingController _vehiclePlateController;
  VehicleColorsOption? _selectedColor;
  Spot? _selectedSpot;

  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _vehicleNameController = TextEditingController();
    _vehiclePlateController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    _setSnackbarListener(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: Spacings.m.height,
        horizontal: Spacings.m.width,
      ),
      child: Form(
        autovalidateMode: AutovalidateMode.always,
        key: _formKey,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Align(
                child: _AddPhotoButton(),
              ),
              SizedBox(
                height: Spacings.xl.height,
              ),
              CustomTextFormField(
                labelText: 'Nome do veículo',
                valuesToUppercase: true,
                controller: _vehicleNameController,
                onChanged: null,
                keyboardType: TextInputType.number,
                validator: (String? value) {
                  if (value == null || (value.isEmpty)) {
                    return 'Por favor, preencha o nome do veiculo';
                  }
                  return null;
                },
              ),
              CustomTextFormField(
                valuesToUppercase: true,
                labelText: 'Placa do veículo',
                controller: _vehiclePlateController,
                onChanged: null,
                keyboardType: TextInputType.number,
                validator: (String? value) {
                  if (value == null || (value.isEmpty)) {
                    return 'Por favor, preencha a placa do veiculo';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<VehicleColorsOption>(
                value: _selectedColor,
                validator: (VehicleColorsOption? value) {
                  if (value == null) {
                    return 'Por favor, escolha uma cor';
                  }
                  return null;
                },
                hint: Text(
                  'Cor do veículo',
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: AppColors.neutral500,
                      ),
                ),
                icon: Icon(
                  Icons.expand_more_outlined,
                  color: colorScheme.primary,
                ),
                dropdownColor: AppColors.neutral50,
                onChanged: (VehicleColorsOption? value) {
                  setState(() {
                    _selectedColor = value!;
                  });
                },
                items: <DropdownMenuItem<VehicleColorsOption>>[
                  for (final colorOption in VehicleColorsOption.values)
                    DropdownMenuItem(
                      value: colorOption,
                      child: _DropdownCarColorItem(
                        carColorsOption: colorOption,
                      ),
                    ),
                ],
              ),
              Consumer(
                builder: (context, ref, _) {
                  final spotsAsync = ref.watch(avaliableSpotsListProvider);

                  return spotsAsync.when(
                    data: (List<Spot> data) {
                      return DropdownButtonFormField<Spot>(
                        validator: (Spot? value) {
                          if (value == null) {
                            return 'Por favor, escolha uma vaga';
                          }
                          return null;
                        },
                        onChanged: (Spot? value) {
                          setState(
                            () {
                              _selectedSpot = value;
                            },
                          );
                        },
                        value: _selectedSpot,
                        hint: Text(
                          data.isEmpty
                              ? 'Não há vagas disponíveis'
                              : 'Vagas disponíveis',
                          style: textTheme.labelSmall!.copyWith(
                            color: data.isEmpty
                                ? Colors.red
                                : AppColors.neutral500,
                          ),
                        ),
                        icon: Icon(
                          Icons.expand_more_outlined,
                          color: colorScheme.primary,
                        ),
                        items: <DropdownMenuItem<Spot>>[
                          for (final spot in data)
                            DropdownMenuItem(
                              value: spot,
                              child: _DropdownItemLeadingIcon(
                                description: 'Vaga: ${spot.number.toString()}',
                                leadingIcon: spot.spotType.icon,
                                leadingIconColor: colorScheme.primary,
                                applyShadowToLeadingIcon: false,
                              ),
                            )
                        ],
                      );
                    },
                    error: (error, stackTrace) => const SizedBox.shrink(),
                    loading: () => const CircularProgressIndicator(),
                  );
                },
              ),
              SizedBox(
                height: Spacings.xl.height,
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _formKey.currentState != null &&
                              _formKey.currentState!.validate()
                          ? () {
                              _onSaveEntry();
                            }
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
      ),
    );
  }

  void _onSaveEntry() {
    ref
        .read(entryNotifierProvider.notifier)
        .saveEntry(
          entryToSave: Entry(
            id: '',
            vehicleName: _vehicleNameController.text,
            vehiclePlate: _vehiclePlateController.text,
            vehicleColor: _selectedColor!,
            spot: _selectedSpot!,
            entryTime: DateTime.now(),
            status: EntryStatus.active,
            completedTime: null,
          ),
          respositoryAction: RespositoryAction.add,
        )
        .then(
      (_) {
        ref.read(spotsListProvider.notifier).setStatus(
              spotNumber: _selectedSpot!.number,
              spotStatus: SpotStatus.occupied,
            );
        ref.invalidate(entriesListProvider);
        context.replace(Routes.entriesListPage.description);
      },
    );
  }

  void _setSnackbarListener(BuildContext context) {
    ref.listen<AsyncValue<ResponseResult>>(
      entryNotifierProvider,
      (_, state) {
        if (state.value != null && state.value!.success) {
          showSnackBarMessage(
            context,
            message: 'Entrada cadastrada com sucesso!',
          );
        } else if (state.value != null && state.value!.success) {
          showSnackBarMessage(
            context,
            message: state.value!.errorMessage!,
          );
        }
      },
    );
  }
}

class _DropdownCarColorItem extends StatelessWidget {
  const _DropdownCarColorItem({
    Key? key,
    required this.carColorsOption,
  }) : super(key: key);

  final VehicleColorsOption carColorsOption;

  @override
  Widget build(BuildContext context) {
    return _DropdownItemLeadingIcon(
      description: carColorsOption.description,
      leadingIcon: Icons.circle,
      leadingIconColor: carColorsOption.color,
    );
  }
}

class _DropdownItemLeadingIcon extends StatelessWidget {
  const _DropdownItemLeadingIcon({
    Key? key,
    required this.description,
    required this.leadingIcon,
    required this.leadingIconColor,
    this.applyShadowToLeadingIcon = true,
  }) : super(key: key);

  final IconData leadingIcon;
  final Color leadingIconColor;
  final String description;
  final bool applyShadowToLeadingIcon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            leadingIcon,
            color: leadingIconColor,
            shadows: applyShadowToLeadingIcon
                ? [
                    Shadow(
                      blurRadius: 4.width,
                    )
                  ]
                : null,
          ),
          SizedBox(
            width: 5.width,
          ),
          Text(
            description,
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  color: AppColors.neutral500,
                ),
          ),
        ],
      ),
    );
  }
}

class _AddPhotoButton extends StatelessWidget {
  const _AddPhotoButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: null,
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(Spacings.m),
          child: Column(
            children: [
              Icon(
                Icons.add_a_photo_outlined,
                size: 100.height,
              ),
              Text(
                'Adicionar foto',
                style: textTheme.displaySmall!.copyWith(
                  color: AppColors.neutral500,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
