import 'package:cloud_firestore/cloud_firestore.dart';


final FirebaseService _firebaseService = FirebaseService();

class FirebaseService {
  final CollectionReference tasksCollection =
  FirebaseFirestore.instance.collection('tasks');


  Future<void> addTask(String title, DateTime dateTime, String? userId) async {
    String taskId = _firebaseService.tasksCollection.doc().id; // Generate a new ID
    await _firebaseService.tasksCollection.doc(taskId).set({
      'title': title,
      'dateTime': dateTime,
      'userId': userId,
    });
  }


  Future<void> updateTask(String taskId, String title, DateTime dateTime) async {
    if (taskId.isNotEmpty) {
      await tasksCollection.doc(taskId).update({
        'title': title,
        'dateTime': dateTime,
      });
    } else {
      // Handle the case where taskId is empty
      print('Error: TaskId is empty or null');
    }
  }

  Future<void> deleteTask(String taskId) async {
    if (taskId.isNotEmpty) {
      await tasksCollection.doc(taskId).delete();
    } else {
      // Handle the case where taskId is empty
      print('Error: TaskId is empty or null');
    }
  }

  Stream<QuerySnapshot> getTasks() {
    return tasksCollection.snapshots();
  }


  Stream<QuerySnapshot> getTasksByUser(String? userId) {
    return FirebaseFirestore.instance
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }
}
