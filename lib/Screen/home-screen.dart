import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();

  String _documentId = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Firebase CRUD'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Enter name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Enter price'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _totalController,
              decoration: InputDecoration(labelText: 'Enter total'),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  createData();
                },
                child: Text('Create'),
              ),
              ElevatedButton(
                onPressed: () {
                  readData();
                },
                child: Text('Read'),
              ),
              ElevatedButton(
                onPressed: () {
                  updateData(_documentId);
                },
                child: Text('Update'),
              ),
              ElevatedButton(
                onPressed: () {
                  deleteData(_documentId);
                },
                child: Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Create data in Firestore
  Future<void> createData() async {
    await _firestore.collection('User Data').add({
      'name': _nameController.text,
      'price': _priceController.text,
      'total': _totalController.text,
    });
    _nameController.clear();
    _priceController.clear();
    _totalController.clear();
  }

  // Read data from Firestore
  // Future<void> readData() async {
  //   QuerySnapshot querySnapshot =
  //   await _firestore.collection('User Data').get();
  //   for (QueryDocumentSnapshot doc in querySnapshot.docs) {
  //     print(doc.id); // Document ID
  //     print(doc['name']); // Field value
  //     setState(() {
  //       _documentId = doc.id;
  //       _nameController.text = doc['name'];
  //       _priceController.text = doc['price'];
  //       _totalController.text = doc['total'];
  //     });
  //   }
  // }

  // Update data in Firestore

  Future<void> readData() async {
    QuerySnapshot querySnapshot =
    await _firestore.collection('User Data').get();
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      print(doc.id); // Document ID
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

      if (data != null && data.containsKey('name')) {
        print(data['name']); // Field value
        setState(() {
          _documentId = doc.id;
          _nameController.text = data['name'];
        });
      }
      if (data != null && data.containsKey('price')) {
        setState(() {
          _priceController.text = data['price'];
        });
      }
      if (data != null && data.containsKey('total')) {
        setState(() {
          _totalController.text = data['total'];
        });
      }
    }
  }


  Future<void> updateData(String documentId) async {
    await _firestore.collection('User Data').doc(documentId).update({
      'name': _nameController.text,
      'price': _priceController.text,
      'total': _totalController.text,
    });
    _nameController.clear();
    _priceController.clear();
    _totalController.clear();
  }

  // Delete data from Firestore
  Future<void> deleteData(String documentId) async {
    await _firestore.collection('User Data').doc(documentId).delete();
    _nameController.clear();
    _priceController.clear();
    _totalController.clear();
  }
}
