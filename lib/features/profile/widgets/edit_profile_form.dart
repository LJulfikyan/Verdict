import 'package:flutter/material.dart';

import '../../../core/theme/app_dimensions.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileForm extends StatelessWidget {
  const EditProfileForm({required this.controller, super.key});

  final EditProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            controller: controller.displayNameController,
            labelText: 'Display Name',
            hintText: 'How your name appears',
            validator: (value) {
              final text = (value ?? '').trim();
              if (text.isEmpty) {
                return 'Display name is required.';
              }
              if (text.length < 2) {
                return 'Display name must be at least 2 characters.';
              }
              if (text.length > 40) {
                return 'Display name must be 40 characters or fewer.';
              }
              return null;
            },
          ),
          const SizedBox(height: AppDimensions.space16),
          AppTextField(
            controller: controller.countryController,
            labelText: 'Country',
            hintText: 'Country',
            validator: (value) {
              final text = (value ?? '').trim();
              if (text.isEmpty) {
                return null;
              }
              if (text.length > 40) {
                return 'Country must be 40 characters or fewer.';
              }
              return null;
            },
          ),
          const SizedBox(height: AppDimensions.space16),
          _DropdownField(
            label: 'Gender',
            value: controller.selectedGender.value.isEmpty
                ? null
                : controller.selectedGender.value,
            items: EditProfileController.genders,
            onChanged: (value) => controller.selectedGender.value = value ?? '',
          ),
          const SizedBox(height: AppDimensions.space16),
          _DropdownField(
            label: 'Age Range',
            value: controller.selectedAgeRange.value.isEmpty
                ? null
                : controller.selectedAgeRange.value,
            items: EditProfileController.ageRanges,
            onChanged: (value) =>
                controller.selectedAgeRange.value = value ?? '',
          ),
          const SizedBox(height: AppDimensions.space24),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: 'Save Changes',
              isLoading: controller.isSaving.value,
              onPressed: () async {
                final success = await controller.save();
                if (success && context.mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InputDecorator(
      decoration: InputDecoration(labelText: label),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(label, style: theme.textTheme.bodyMedium),
          items: items
              .map(
                (item) =>
                    DropdownMenuItem<String>(value: item, child: Text(item)),
              )
              .toList(growable: false),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
