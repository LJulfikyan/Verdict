import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_dimensions.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../controllers/edit_profile_controller.dart';
import '../widgets/edit_profile_form.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EditProfileController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initialize();
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return ListView(
            padding: const EdgeInsets.all(AppDimensions.space16),
            children: const [
              LoadingSkeleton(height: 56),
              SizedBox(height: AppDimensions.space16),
              LoadingSkeleton(height: 56),
              SizedBox(height: AppDimensions.space16),
              LoadingSkeleton(height: 56),
              SizedBox(height: AppDimensions.space16),
              LoadingSkeleton(height: 56),
            ],
          );
        }

        if (controller.errorMessage.value != null &&
            controller.displayNameController.text.isEmpty) {
          return ErrorState(
            title: 'Could not load profile',
            message: controller.errorMessage.value!,
            onRetry: controller.loadProfile,
          );
        }

        return ListView(
          padding: const EdgeInsets.all(AppDimensions.space16),
          children: [
            Text(
              'Update your public profile details.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: AppDimensions.space24),
            if (controller.errorMessage.value != null) ...[
              Text(
                controller.errorMessage.value!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              const SizedBox(height: AppDimensions.space16),
            ],
            EditProfileForm(controller: controller),
          ],
        );
      }),
    );
  }
}
