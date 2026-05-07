import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';

class CreateSavingsGoalScreen extends StatelessWidget {
  const CreateSavingsGoalScreen({
    super.key,
    required this.childId,
    required this.navigationContract,
  });

  final String childId;
  final NavigationContract navigationContract;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear objetivo')),
      body: Center(
        child: Text(
          'La funcionalidad de esta pantalla es crear una nueva meta de ahorro para el niño $childId, validando nombre, monto objetivo y descripción antes de enviarla.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
