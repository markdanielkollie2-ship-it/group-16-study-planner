import 'package:flutter/material.dart';

void main() => runApp(const StudyPlannerApp());

class StudyPlannerApp extends StatelessWidget {
  const StudyPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Study Planner',
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> goals = [
    {'subject': 'Mathematics', 'hours': 3, 'done': false},
    {'subject': 'English', 'hours': 2, 'done': false},
    {'subject': 'Mobile App Development', 'hours': 4, 'done': false},
  ];

  void toggleGoal(int index) {
    setState(() {
      goals[index]['done'] = !goals[index]['done'];
    });
  }

  void deleteGoal(int index) {
    setState(() {
      goals.removeAt(index);
    });
  }

  void addSampleGoal() {
    setState(() {
      goals.add({'subject': 'Physics', 'hours': 2, 'done': false});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Study Planner'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'My Goals',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: goals.length,
                itemBuilder: (context, index) {
                  final goal = goals[index];
                  return Card(
                    child: ListTile(
                      leading: Checkbox(
                        value: goal['done'],
                        onChanged: (_) => toggleGoal(index),
                      ),
                      title: Text(
                        goal['subject'],
                        style: TextStyle(
                          decoration: goal['done']
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      subtitle: Text('${goal['hours']} hours'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => deleteGoal(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addSampleGoal,
        child: const Icon(Icons.add),
      ),
    );
  }
}