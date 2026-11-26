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

// STATIC: second screen where the user types a new goal (Phase 4)
class AddGoalScreen extends StatefulWidget {
  const AddGoalScreen({super.key});

  @override
  State<AddGoalScreen> createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  // LOGIC: controllers read the text typed in the fields
  final subjectController = TextEditingController();
  final hoursController = TextEditingController();

  // LOGIC: error message shown under the fields (null = no error)
  String? errorMessage;

  // LOGIC: free the controllers when the screen closes
  @override
  void dispose() {
    subjectController.dispose();
    hoursController.dispose();
    super.dispose();
  }

  // LOGIC: check the input, then send the new goal back to the first screen
  void saveGoal() {
    final subject = subjectController.text.trim();
    final hours = int.tryParse(hoursController.text.trim());

    // LOGIC: validation - subject must not be empty
    if (subject.isEmpty) {
      setState(() => errorMessage = 'Please enter a subject.');
      return;
    }

    // LOGIC: validation - hours must be a number greater than 0
    if (hours == null || hours <= 0) {
      setState(() => errorMessage = 'Hours must be a number greater than 0.');
      return;
    }

    // input is valid, so clear any old error message
    setState(() => errorMessage = null);

    // CONNECTION: Navigator.pop sends the new goal back to HomeScreen
    Navigator.pop(context, {
      'subject': subject,
      'hours': hours,
      'done': false,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // STATIC: top bar
      appBar: AppBar(title: const Text('Add Goal')),

      // STATIC: the form
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: subjectController,
              decoration: const InputDecoration(
                labelText: 'Subject',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: hoursController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Hours',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // STATIC: error message (only shown when errorMessage is set)
            if (errorMessage != null)
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),

            const SizedBox(height: 16),
            // CONNECTION: Save button calls the saveGoal function
            ElevatedButton(
              onPressed: saveGoal,
              child: const Text('Save'),
            ),
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

  // LOGIC: open the add-goal screen and wait for the goal it returns
  Future<void> openAddGoalScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddGoalScreen()),
    );

    // ignore the result if the user pressed back (result is null)
    if (result != null) {
      setState(() {
        goals.add(result);
      });
    }
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

      // CONNECTION: add button opens the add-goal screen
      floatingActionButton: FloatingActionButton(
        onPressed: openAddGoalScreen,
        child: const Icon(Icons.add),
      ),
    );
  }
}