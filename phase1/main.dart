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

// STATIC: main screen (Phase 1)
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // STATIC: top bar with the app title
      appBar: AppBar(
        title: const Text('My Study Planner'),
      ),

      // STATIC: scrollable list area
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // STATIC: heading above the list
          const Text(
            'My Goals',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          // STATIC: three hard-coded goal cards
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

      // STATIC: add button (does nothing yet)
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}