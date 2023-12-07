// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../Aut/firebase-service.dart';
// import '../model/task-model.dart';
//
// class TaskListScreen extends StatefulWidget {
//   @override
//   _TaskListScreenState createState() => _TaskListScreenState();
// }
//
// class _TaskListScreenState extends State<TaskListScreen> {
//   final FirebaseService _firebaseService = FirebaseService();
//   final TextEditingController _titleController = TextEditingController();
//   DateTime _selectedDateTime = DateTime.now();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Task Manager'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _titleController,
//                     decoration: InputDecoration(
//                       hintText: 'Enter task title...',
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.calendar_today),
//                   onPressed: () async {
//                     DateTime? pickedDate = await showDatePicker(
//                       context: context,
//                       initialDate: _selectedDateTime,
//                       firstDate: DateTime.now(),
//                       lastDate: DateTime(2101),
//                     );
//
//                     if (pickedDate != null && pickedDate != _selectedDateTime) {
//                       setState(() {
//                         _selectedDateTime = pickedDate;
//                       });
//                     }
//                   },
//                 ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     if (_titleController.text.isNotEmpty) {
//                       await _firebaseService.addTask(_titleController.text, _selectedDateTime);
//                       _titleController.clear();
//                     }
//                   },
//                   child: Text('Add Task'),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: _firebaseService.getTasks(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasError) {
//                   return Center(
//                     child: Text('Error: ${snapshot.error}'),
//                   );
//                 }
//
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }
//
//                 List<Task> tasks = snapshot.data!.docs
//                     .map((doc) => Task.fromMap(doc.data() as Map<String, dynamic>))
//                     .toList();
//
//                 return ListView.builder(
//                   itemCount: tasks.length,
//                   itemBuilder: (context, index) {
//                     Task task = tasks[index];
//                     return ListTile(
//                       title: Text(task.title ?? 'No Title'), // Display a default value if title is null.
//                       subtitle: Text(task.dateTime?.toString() ?? 'No Date'),
//                       trailing: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           IconButton(
//                             icon: Icon(Icons.edit),
//                             onPressed: () async {
//                               // Implement edit functionality
//                             },
//                           ),
//                           IconButton(
//                             icon: Icon(Icons.delete),
//                             onPressed: () async {
//                               await _firebaseService.deleteTask(task.id.toString());
//                             },
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Aut/firebase-service.dart';
import '../model/task-model.dart';



class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final TextEditingController _titleController = TextEditingController();
  DateTime _selectedDateTime = DateTime.now();

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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: const Text('Planner')),
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





            // StreamBuilder<QuerySnapshot>(
            //   stream: _firebaseService.getTasks(),
            //   builder: (context, snapshot) {
            //     if (snapshot.hasError) {
            //       return Center(
            //         child: Text('Error: ${snapshot.error}'),
            //       );
            //     }
            //
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return const Center(
            //         child: CircularProgressIndicator(),
            //       );
            //     }
            //
            //     List<Task> tasks = snapshot.data!.docs.map((doc) {
            //       // Get document ID along with data
            //       Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            //       return Task.fromMap(data, doc.id);
            //     }).toList();
            //
            //
            //     return ListView.builder(
            //       itemCount: tasks.length,
            //       itemBuilder: (context, index) {
            //         print("Aziz ${tasks[index].id}");
            //         Task task = tasks[index];
            //         return ListTile(
            //           title: Text(task.title ?? 'No Title'),
            //           subtitle: Text(task.dateTime != null ? DateFormat('yyyy-MM-dd HH:mm').format(task.dateTime!) : 'No Date'),
            //           trailing: Row(
            //             mainAxisSize: MainAxisSize.min,
            //             children: [
            //               IconButton(
            //                 icon: const Icon(Icons.edit),
            //                 onPressed: () async {
            //                   await _editTaskDialog(task);
            //                 },
            //               ),
            //               IconButton(
            //                 icon: const Icon(Icons.delete),
            //                 onPressed: () async {
            //                   await _deleteTask(task.id!);
            //                 },
            //               ),
            //             ],
            //           ),
            //         );
            //       },
            //     );
            //   },
            // ),
          ),
        ],
      ),
    );
  }
}

