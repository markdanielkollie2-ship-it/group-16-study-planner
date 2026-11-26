import 'package:cloud_firestore/cloud_firestore.dart';

final _goals = FirebaseFirestore.instance.collection('goals');

Future<List<Map<String, dynamic>>> getGoals() async {
  final snapshot = await _goals.orderBy('createdAt').get();
  return snapshot.docs
      .map((doc) => {
            'id': doc.id,
            'subject': doc['subject'],
            'hours': doc['hours'],
            'done': doc['done'],
          })
      .toList();
}

Future<void> insertGoal(String subject, int hours) async {
  await _goals.add({
    'subject': subject,
    'hours': hours,
    'done': false,
    'createdAt': FieldValue.serverTimestamp(),
  });
}

Future<void> updateDone(String id, bool done) async {
  await _goals.doc(id).update({'done': done});
}

Future<void> removeGoal(String id) async {
  await _goals.doc(id).delete();
}