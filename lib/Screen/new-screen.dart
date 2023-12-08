
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../Aut/firebase-service.dart';
import '../Aut/login-screen.dart';
import '../model/task-model.dart';
import '../utiles/utils.dart';



class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final TextEditingController _titleController = TextEditingController();
  DateTime _selectedDateTime = DateTime.now();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _editTaskDialog(Task task) async {
    TextEditingController _editTitleController = TextEditingController();

    print("Hello Shaki $_editTitleController");

    print("AR ${task.dateTime}");

    DateTime? _editDateTime = task.dateTime;
    print("Date $_editDateTime");

    _editTitleController.text = task.title!;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _editTitleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Text('Date: ${DateFormat('yyyy-MM-dd').format(_editDateTime!)}'),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _editDateTime!,
                        firstDate: DateTime(2010),
                        lastDate: DateTime(2101),
                      );

                      if (pickedDate != null && pickedDate != _editDateTime) {
                        setState(() {
                          _editDateTime = pickedDate;
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _firebaseService.updateTask(task.id!, _editTitleController.text, _editDateTime!);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteTask(String taskId) async {
    await _firebaseService.deleteTask(taskId);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // return true;
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        // appBar: AppBar(
        //   automaticallyImplyLeading: false,
        //   title: Center(child: const Text('Planner')),
        // ),

        appBar: AppBar(
          centerTitle: true,
          title: const Text('Planner',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.redAccent,
          actions: [
            IconButton(
              onPressed: () {
                // Navigator.pushReplacement(context,
                //     MaterialPageRoute(builder: (context) => const ProductFire()));
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 10,
            )
          ],
          leading: IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return AlertDialog(
                      title: const Text ('Do you want to SignOut?'),
                      actions: [
                        TextButton(
                          child :const Text('Yes'),
                          onPressed: () {
                            _auth.signOut().then((value) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginScreen()));
                            }).onError((error, stackTrace) {
                              Utils().toastMessage(error.toString());
                            });
                          },
                          style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: Colors.green,
                              textStyle: const TextStyle(
                                fontSize: 14,
                              )
                          ),

                        ),
                        TextButton(
                          child :const Text('No'),
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>  TaskListScreen())),
                          style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor:Colors.green,
                              textStyle: const TextStyle(
                                fontSize:14,
                              )
                          ),
                        ),
                      ],
                    );
                  }
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        hintText: 'Enter task title...',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _selectedDateTime,
                        firstDate: DateTime(2010),
                        lastDate: DateTime(2101),
                      );

                      if (pickedDate != null && pickedDate != _selectedDateTime) {
                        setState(() {
                          _selectedDateTime = pickedDate;
                        });
                      }
                    },
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_titleController.text.isNotEmpty) {
                        await _firebaseService.addTask(_titleController.text, _selectedDateTime);
                        _titleController.clear();
                      }
                    },
                    child: const Text('Add Task'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firebaseService.getTasks(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  List<Task> tasks = snapshot.data!.docs.map((doc) {
                    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                    return Task.fromMap(data, doc.id);
                  }).toList();

                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      Task task = tasks[index];
                      return ListTile(
                        title: Text(task.title ?? 'No Title'),
                        subtitle: Text(
                          task.dateTime != null
                              ? DateFormat('yyyy-MM-dd HH:mm').format(task.dateTime!)
                              : 'No Date',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                await _editTaskDialog(task);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                await _deleteTask(task.id!);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              )


            ),
          ],
        ),
      ),
    );
  }
}

