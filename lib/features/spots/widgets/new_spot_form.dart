import 'package:ezpark/core/resposivity/extensions/resizer_extension.dart';
import 'package:flutter/material.dart';

import '../../../core/sizes/spacings.dart';
import '../../../core/theme/colors/colors.dart';
import '../enums/spot_type.dart';

class NewSpotForm extends StatefulWidget {
  const NewSpotForm({Key? key}) : super(key: key);

  @override
  State<NewSpotForm> createState() => _NewSpotFormState();
}

class _NewSpotFormState extends State<NewSpotForm> {
  late final TextEditingController _spotDescription;
  SpotType? _selectedSpotType;

  @override
  void initState() {
    super.initState();
    _spotDescription = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        onChanged: () {
          setState(() {});
        },
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
                        ? () => print('salvar')
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
