import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';

class SavingsGoalsListScreen extends StatelessWidget {
  const SavingsGoalsListScreen({
    super.key,
    required this.childId,
    required this.navigationContract,
  });

  final String childId;
  final NavigationContract navigationContract;

  @override
  Widget build(BuildContext context) {
    final goals = ['goal-1', 'goal-2', 'goal-3'];
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de objetivos')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'La funcionalidad de esta pantalla es mostrar la lista de metas de ahorro del niño $childId.',
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: goals.length,
              itemBuilder: (context, index) {
                final goalId = goals[index];
                return ListTile(
                  title: Text('Meta $goalId'),
                  onTap: () => navigationContract.goToDetail(childId, goalId),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigationContract.goToCreate(childId),
        child: const Icon(Icons.add),
      ),
    );
  }
}
