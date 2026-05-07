import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';

class SavingGoalDetailScreen extends StatelessWidget {
  const SavingGoalDetailScreen({
    super.key,
    required this.childId,
    required this.goalId,
    required this.navigationContract,
  });

  final String childId;
  final String goalId;
  final NavigationContract navigationContract;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de objetivo')),
      body: Center(
        child: Text(
          'La funcionalidad de esta pantalla es mostrar el detalle del objetivo $goalId del niño $childId y permitir actualizar su progreso con nuevos aportes.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
