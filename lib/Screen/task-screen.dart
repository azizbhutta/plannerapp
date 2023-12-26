import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:plannerapp/Screen/profile-screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final searchFilterController = TextEditingController();
  DateTime _selectedDateTime = DateTime.now();
  DateTime? pickedDate;
  String? myTask;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

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
              TextFormField(
                controller: _editTitleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value!.isEmpty) {
                    Fluttertoast.showToast(
                        backgroundColor: Colors.purple,
                        msg: "please enter Task");
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Text(
                      'Date: ${DateFormat('yyyy-MM-dd').format(_editDateTime!)}'),
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
                await _firebaseService.updateTask(
                    task.id!, _editTitleController.text, DateTime.now());
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

  void clearLoginStatus() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove("loggedIn");
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Always return false to prevent going back
        SystemNavigator.pop();
        // Return true to allow the pop, or false to prevent it.
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Planner',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.redAccent,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
              icon: const Icon(
                Icons.person_rounded,
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
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Do you want to SignOut?'),
                      actions: [
                        TextButton(
                          child: const Text('Yes'),
                          onPressed: () {
                            _auth.signOut().then((value) {
                              // Clear login status in shared preferences
                              clearLoginStatus();
                              // Navigate to the login screen
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                                    (route) => false, // Remove all existing routes from the stack
                              );
                            }).onError((error, stackTrace) {
                              Utils().toastMessage(error.toString());
                            });
                          },
                          style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: Colors.green,
                              textStyle: const TextStyle(
                                fontSize: 14,
                              )),
                        ),
                        TextButton(
                          child: const Text('No'),
                          onPressed: () => Navigator.pop(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TaskListScreen())),
                          style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: Colors.green,
                              textStyle: const TextStyle(
                                fontSize: 14,
                              )),
                        ),
                      ],
                    );
                  });
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: searchFilterController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                  hintText: 'Search',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.teal,
                  ),
                ),
                onChanged: (String value) {
                  setState(() {});
                },
              ),
            ),
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
              stream: _firebaseService.getTasksByUser(_auth.currentUser?.uid),
              // stream: _firebaseService.getTasks(),
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
                  Map<String, dynamic> data =
                      doc.data() as Map<String, dynamic>;
                  return Task.fromMap(data, doc.id);
                }).toList();

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    myTask =
                        snapshot.data!.docs[index]['title'].toString();
                    print('hello $myTask');
                    Task task = tasks[index];
                    if(searchFilterController.text.isEmpty){
                      return ListTile(
                        title: Text(task.title ?? 'No Title'),
                        subtitle: Text(
                          task.dateTime != null
                              ? DateFormat('yyyy-MM-dd hh:mm a')
                              .format(task.dateTime!.toLocal())
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
                    } else if(myTask!.toLowerCase().contains(searchFilterController.text.toLowerCase())){
                      return ListTile(
                        title: Text(task.title ?? 'No Title'),
                        subtitle: Text(
                          task.dateTime != null
                              ? DateFormat('yyyy-MM-dd hh:mm a')
                              .format(task.dateTime!.toLocal())
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
                    }return Container();
                  },
                );

              },
            )),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Add Task'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(labelText: 'Title'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            Fluttertoast.showToast(
                                backgroundColor: Colors.purple,
                                msg: "please enter Task");
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8.0),
                      Form(
                        key: _formKey,
                        child: Row(
                          children: [
                            Text(
                                'Date: ${DateFormat('yyyy-MM-dd').format(_selectedDateTime)}'),
                            IconButton(
                              icon: const Icon(Icons.calendar_today),
                              onPressed: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: _selectedDateTime,
                                  firstDate: DateTime(2010),
                                  lastDate: DateTime(2101),
                                );

                                if (pickedDate != null &&
                                    pickedDate != _selectedDateTime) {
                                  setState(() {
                                    _selectedDateTime = pickedDate;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (_selectedDateTime != null) {
                              if (_titleController.text.isNotEmpty) {
                                // The task title is not empty, proceed to add the task
                                await _firebaseService.addTask(
                                    _titleController.text,
                                    DateTime.now(),
                                    _auth.currentUser?.uid);
                                _titleController.clear();
                                Fluttertoast.showToast(
                                    backgroundColor: Colors.purple,
                                    msg: "Task added successfully");
                                Navigator.of(context).pop();
                              } else {
                                // The task title is empty, show a message
                                Fluttertoast.showToast(
                                    backgroundColor: Colors.purple,
                                    msg: "Please enter a task title");
                              }
                            } else {
                              Fluttertoast.showToast(
                                  backgroundColor: Colors.purple,
                                  msg: "Please pick a date");
                            }
                          }
                        },
                        child: const Text('Add Task'),
                      ),

                    ],
                  ),
                );
              },
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
