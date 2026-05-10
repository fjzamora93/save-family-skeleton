import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localizations/localizations.dart';
import 'package:navigation/navigation.dart';
import 'package:savings_goals/src/core/providers/savings_goal_form_state_provider.dart';
import 'package:savings_goals/src/features/create/presentation/providers/create_savings_goal_controller.dart';
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
    final formScope = SavingsGoalFormScopes.create;
    final formState =
        ref.watch(savingsGoalFormStateControllerProvider(formScope));
    final formController = ref.read(
      savingsGoalFormStateControllerProvider(formScope).notifier,
    );
    final submitController = ref.read(createSavingsGoalControllerProvider.notifier);

    ref.listen(createSavingsGoalControllerProvider, (previous, next) {
      if (next.hasError) {
        next.showErrorOn(context); 
        return;
      }

      final wasLoading = previous?.isLoading ?? false;
      if (wasLoading && next.hasValue) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.translate(I18n.savingsGoalCreateSuccess))),
        );
        widget.navigationContract.goBack();
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(context.translate(I18n.savingsGoalCreateTitle))),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SfTextInput(
                label: context.translate(I18n.savingsGoalNameLabel),
                controller: _nameController,
                onChanged: formController.updateName,
                textInputAction: TextInputAction.next,
                errorText: formState.nameErrorKey == null
                    ? null
                    : context.translate(formState.nameErrorKey!),
              ),
              const SizedBox(height: 16),
              SfNumberInput(
                label: context.translate(I18n.savingsGoalTargetAmountLabel),
                controller: _targetAmountController,
                onChanged: formController.updateTargetAmount,
                textInputAction: TextInputAction.next,
                errorText: formState.targetAmountErrorKey == null
                    ? null
                    : context.translate(formState.targetAmountErrorKey!),
              ),
              const SizedBox(height: 16),
              SfTextInput(
                label: context.translate(I18n.savingsGoalDescriptionLabel),
                controller: _descriptionController,
                onChanged: formController.updateDescription,
                minLines: 3,
                maxLines: 5,
              ),
              const Spacer(),
              PrimaryButton(
                label: context.translate(I18n.save),
                onPressed: formState.isValidCreate && !submitState.isLoading
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
