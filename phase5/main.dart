import 'package:material_ui/material_ui.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'database_helper.dart' as db;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const StudyPlannerApp());
}

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

class AddGoalScreen extends StatefulWidget {
  const AddGoalScreen({super.key});

  @override
  State<AddGoalScreen> createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  final subjectController = TextEditingController();
  final hoursController = TextEditingController();

  String? errorMessage;

  @override
  void dispose() {
    subjectController.dispose();
    hoursController.dispose();
    super.dispose();
  }

  void saveGoal() {
    final subject = subjectController.text.trim();
    final hours = int.tryParse(hoursController.text.trim());

    if (subject.isEmpty) {
      setState(() => errorMessage = 'Please enter a subject.');
      return;
    }

    if (hours == null || hours <= 0) {
      setState(() => errorMessage = 'Hours must be a number greater than 0.');
      return;
    }

    setState(() => errorMessage = null);

    Navigator.pop(context, {
      'subject': subject,
      'hours': hours,
      'done': false,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Goal')),
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
            if (errorMessage != null)
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 16),
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> goals = [];

  @override
  void initState() {
    super.initState();
    loadGoals();
  }

  Future<void> loadGoals() async {
    final saved = await db.getGoals();
    setState(() {
      goals = saved;
    });
  }

  int get totalHours =>
      goals.fold(0, (sum, goal) => sum + (goal['hours'] as int));
  int get completedCount => goals.where((goal) => goal['done'] == true).length;
  int get remainingCount => goals.length - completedCount;

  Future<void> toggleGoal(int index) async {
    final goal = goals[index];
    final newDone = !(goal['done'] as bool);
    await db.updateDone(goal['id'] as String, newDone);
    setState(() {
      goal['done'] = newDone;
    });
  }

  Future<void> deleteGoal(int index) async {
    final goal = goals[index];
    await db.removeGoal(goal['id'] as String);
    setState(() {
      goals.removeAt(index);
    });
  }

  Future<void> openAddGoalScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddGoalScreen()),
    );

    if (result != null) {
      await db.insertGoal(result['subject'] as String, result['hours'] as int);
      await loadGoals();
    }
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
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'My Goals',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            goals.isEmpty
                ? const Expanded(
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
        onPressed: openAddGoalScreen,
        child: const Icon(Icons.add),
      ),
    );
  }
}