import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localizations/localizations.dart';
import 'package:navigation/navigation.dart';
import 'package:savings_goals/src/features/create/presentation/providers/create_savings_goal_controller.dart';
import 'package:savings_goals/src/features/create/presentation/providers/create_savings_goal_form_state_provider.dart';
import 'package:sf_shared/sf_shared.dart';

class CreateSavingsGoalScreen extends ConsumerStatefulWidget {
  const CreateSavingsGoalScreen({
    super.key,
    required this.childId,
    required this.navigationContract,
  });

  final String childId;
  final NavigationContract navigationContract;

  @override
  ConsumerState<CreateSavingsGoalScreen> createState() =>
      _CreateSavingsGoalScreenState();
}

class _CreateSavingsGoalScreenState extends ConsumerState<CreateSavingsGoalScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _targetAmountController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _targetAmountController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _targetAmountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final submitState = ref.watch(createSavingsGoalControllerProvider);
    final formState = ref.watch(createSavingsGoalFormStateControllerProvider);
    final formController = ref.read(
      createSavingsGoalFormStateControllerProvider.notifier,
    );
    final submitController = ref.read(createSavingsGoalControllerProvider.notifier);

    ref.listen(createSavingsGoalControllerProvider, (previous, next) async {
      if (next.hasError) {
        final error = next.error;
        if (error is ApiException && error.statusCode == 409) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.message)),
          );
          return;
        }
        await next.showErrorOn(context);
        return;
      }

      final wasLoading = previous?.isLoading ?? false;
      if (wasLoading && next.hasValue) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.translate(I18n.savingsGoalCreateSuccess))),
        );
        if (context.mounted) {
          context.pop();
        }
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(context.translate(I18n.savingsGoalCreateTitle))),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                onChanged: formController.updateName,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: context.translate(I18n.savingsGoalNameLabel),
                  errorText: formState.nameErrorKey == null
                      ? null
                      : context.translate(formState.nameErrorKey!),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _targetAmountController,
                onChanged: formController.updateTargetAmount,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: context.translate(I18n.savingsGoalTargetAmountLabel),
                  errorText: formState.targetAmountErrorKey == null
                      ? null
                      : context.translate(formState.targetAmountErrorKey!),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                onChanged: formController.updateDescription,
                minLines: 3,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: context.translate(I18n.savingsGoalDescriptionLabel),
                ),
              ),
              const Spacer(),
              PrimaryButton(
                label: context.translate(I18n.save),
                onPressed: formState.isValid && !submitState.isLoading
                    ? () => submitController.submit(widget.childId)
                    : null,
                isLoading: submitState.isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
