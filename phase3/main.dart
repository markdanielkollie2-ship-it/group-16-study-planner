import 'package:flutter/material.dart';

void main() => runApp(const StudyPlannerApp());

// STATIC: root of the app
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

// STATIC: reusable summary card (used three times)
class SummaryCard extends StatelessWidget {
  final String title;
  final String value;

  const SummaryCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(title),
          ],
        ),
      ),
    );
  }
}

// STATIC: main screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // LOGIC: data (list of maps with the keys subject, hours, done)
  List<Map<String, dynamic>> goals = [
    {'subject': 'Mathematics', 'hours': 3, 'done': false},
    {'subject': 'English', 'hours': 2, 'done': false},
    {'subject': 'Mobile App Development', 'hours': 4, 'done': false},
  ];

  // LOGIC: statistics, calculated from the goals list
  int get totalHours =>
      goals.fold(0, (sum, goal) => sum + (goal['hours'] as int));
  int get completedCount => goals.where((goal) => goal['done'] == true).length;
  int get remainingCount => goals.length - completedCount;

  // LOGIC: mark a goal as done or not done
  void toggleGoal(int index) {
    setState(() {
      goals[index]['done'] = !goals[index]['done'];
    });
  }

  // LOGIC: remove a goal from the list
  void deleteGoal(int index) {
    setState(() {
      goals.removeAt(index);
    });
  }

  // LOGIC: add a sample goal to the list
  void addSampleGoal() {
    setState(() {
      goals.add({'subject': 'Physics', 'hours': 2, 'done': false});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // STATIC: top bar with the app title
      appBar: AppBar(
        title: const Text('My Study Planner'),
      ),

      // STATIC: page layout (summary row, heading, list)
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CONNECTION: summary cards show values from the statistics getters
            Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: 'Total hours',
                    value: '$totalHours',
                  ),
                ),
                Expanded(
                  child: SummaryCard(
                    title: 'Completed',
                    value: '$completedCount',
                  ),
                ),
                Expanded(
                  child: SummaryCard(
                    title: 'Remaining',
                    value: '$remainingCount',
                  ),
                ),
              ],
            ),

            // STATIC: heading above the list
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'My Goals',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),

            // CONNECTION: show a message when empty, otherwise the goals list
            goals.isEmpty
                ? const Expanded(
                    // STATIC: friendly empty-state message
                    child: Center(
                      child: Text('No goals yet. Tap + to add one.'),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: goals.length,
                      itemBuilder: (context, index) {
                        final goal = goals[index];
                        return Card(
                          child: ListTile(
                            // CONNECTION: checkbox calls the toggle function
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
                            // CONNECTION: delete icon calls the delete function
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

      // CONNECTION: add button calls the function that adds a sample goal
      floatingActionButton: FloatingActionButton(
        onPressed: addSampleGoal,
        child: const Icon(Icons.add),
      ),
    );
  }
}