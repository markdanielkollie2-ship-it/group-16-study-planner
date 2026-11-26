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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Study Planner'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'My Goals',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Card(
            child: ListTile(
              title: Text('Mathematics'),
              subtitle: Text('3 hours'),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('English'),
              subtitle: Text('2 hours'),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Mobile App Development'),
              subtitle: Text('4 hours'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
