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

// STATIC: main screen (Phase 2: now stateful)
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

      // STATIC: page layout (heading above the list)
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // STATIC: heading above the list
            const Text(
              'My Goals',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            // CONNECTION: the list on screen is built from the goals data
            Expanded(
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