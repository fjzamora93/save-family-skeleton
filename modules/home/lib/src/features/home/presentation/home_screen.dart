import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home/src/features/home/domain/entities/home_data.dart';
import 'package:home/src/features/home/presentation/providers/home_controller.dart';
import 'package:home/src/features/home/presentation/widgets/child_summary_card.dart';
import 'package:localizations/localizations.dart';
import 'package:navigation/navigation.dart';
import 'package:sf_shared/sf_shared.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key, required this.navigationContract});

  final NavigationContract navigationContract;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themePortProvider);
    final state = ref.watch(homeControllerProvider);

    ref.listen(homeControllerProvider, (_, next) => next.showErrorOn(context));

    return Scaffold(
      backgroundColor: theme.colorFor(ThemeCode.backgroundPrimary),
      appBar: AppBar(
        title: Text(context.translate(I18n.home)),
        backgroundColor: theme.colorFor(ThemeCode.backgroundPrimary),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: state.when(
            skipLoadingOnReload: true,
            loading: () => const Center(child: LoadingIndicator()),
            error: (error, _) => _ErrorView(error: error),
            data: (data) => _HomeContent(
              data: data,
              navigationContract: navigationContract,
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeContent extends ConsumerWidget {
  const _HomeContent({
    required this.data,
    required this.navigationContract,
  });

  final HomeData data;
  final NavigationContract navigationContract;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themePortProvider);
    final isLoading = ref.watch(
      homeControllerProvider.select((s) => s.isLoading),
    );
    final controller = ref.read(homeControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.translate(I18n.homeWelcome),
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: theme.colorFor(ThemeCode.textPrimary),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: data.children.length,
            itemBuilder: (context, index) {
              final child = data.children[index];
              return ChildSavingsCard(
                child: child,
                onTap: () => navigationContract.navigateToGoalList(child.id),
              );
            },
          ),
        ),
        PrimaryButton(
          label: context.translate(I18n.homeRefresh),
          onPressed: isLoading ? null : controller.refresh,
          isLoading: isLoading,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _ErrorView extends ConsumerWidget {
  const _ErrorView({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themePortProvider);
    final controller = ref.read(homeControllerProvider.notifier);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            formatErrorMessage(error),
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.colorFor(ThemeCode.textSecondary)),
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: context.translate(I18n.retry),
            onPressed: controller.refresh,
          ),
        ],
      ),
    );
  }
}
