// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// //
// // class HomeScreen extends StatefulWidget {
// //   @override
// //   _HomeScreenState createState() => _HomeScreenState();
// // }
// //
// // class _HomeScreenState extends State<HomeScreen> {
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// //   final TextEditingController _nameController = TextEditingController();
// //   final TextEditingController _priceController = TextEditingController();
// //   final TextEditingController _totalController = TextEditingController();
// //
// //   String _documentId = "";
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Flutter Firebase CRUD'),
// //       ),
// //       body: Column(
// //         children: [
// //           Padding(
// //             padding: const EdgeInsets.all(8.0),
// //             child: TextField(
// //               controller: _nameController,
// //               decoration: InputDecoration(labelText: 'Enter name'),
// //             ),
// //           ),
// //           Padding(
// //             padding: const EdgeInsets.all(8.0),
// //             child: TextField(
// //               controller: _priceController,
// //               decoration: InputDecoration(labelText: 'Enter price'),
// //             ),
// //           ),
// //           Padding(
// //             padding: const EdgeInsets.all(8.0),
// //             child: TextField(
// //               controller: _totalController,
// //               decoration: InputDecoration(labelText: 'Enter total'),
// //             ),
// //           ),
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceAround,
// //             children: [
// //               ElevatedButton(
// //                 onPressed: () {
// //                   createData();
// //                 },
// //                 child: Text('Create'),
// //               ),
// //               ElevatedButton(
// //                 onPressed: () {
// //                   readData();
// //                 },
// //                 child: Text('Read'),
// //               ),
// //               ElevatedButton(
// //                 onPressed: () {
// //                   updateData(_documentId);
// //                 },
// //                 child: Text('Update'),
// //               ),
// //               ElevatedButton(
// //                 onPressed: () {
// //                   deleteData(_documentId);
// //                 },
// //                 child: Text('Delete'),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   // Create data in Firestore
// //   Future<void> createData() async {
// //     await _firestore.collection('User Data').add({
// //       'name': _nameController.text,
// //       'price': _priceController.text,
// //       'total': _totalController.text,
// //     });
// //     _nameController.clear();
// //     _priceController.clear();
// //     _totalController.clear();
// //   }
// //
// //   // Read data from Firestore
// //   // Future<void> readData() async {
// //   //   QuerySnapshot querySnapshot =
// //   //   await _firestore.collection('User Data').get();
// //   //   for (QueryDocumentSnapshot doc in querySnapshot.docs) {
// //   //     print(doc.id); // Document ID
// //   //     print(doc['name']); // Field value
// //   //     setState(() {
// //   //       _documentId = doc.id;
// //   //       _nameController.text = doc['name'];
// //   //       _priceController.text = doc['price'];
// //   //       _totalController.text = doc['total'];
// //   //     });
// //   //   }
// //   // }
// //
// //   // Update data in Firestore
// //
// //   Future<void> readData() async {
// //     QuerySnapshot querySnapshot =
// //     await _firestore.collection('User Data').get();
// //     for (QueryDocumentSnapshot doc in querySnapshot.docs) {
// //       print(doc.id); // Document ID
// //       Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
// //
// //       if (data != null && data.containsKey('name')) {
// //         print(data['name']); // Field value
// //         setState(() {
// //           _documentId = doc.id;
// //           _nameController.text = data['name'];
// //         });
// //       }
// //       if (data != null && data.containsKey('price')) {
// //         setState(() {
// //           _priceController.text = data['price'];
// //         });
// //       }
// //       if (data != null && data.containsKey('total')) {
// //         setState(() {
// //           _totalController.text = data['total'];
// //         });
// //       }
// //     }
// //   }
// //
// //
// //   Future<void> updateData(String documentId) async {
// //     await _firestore.collection('User Data').doc(documentId).update({
// //       'name': _nameController.text,
// //       'price': _priceController.text,
// //       'total': _totalController.text,
// //     });
// //     _nameController.clear();
// //     _priceController.clear();
// //     _totalController.clear();
// //   }
// //
// //   // Delete data from Firestore
// //   Future<void> deleteData(String documentId) async {
// //     await _firestore.collection('User Data').doc(documentId).delete();
// //     _nameController.clear();
// //     _priceController.clear();
// //     _totalController.clear();
// //   }
// // }
//
//
//
// // import 'dart:io';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:firebase_database/firebase_database.dart';
// // import 'package:firebase_database/ui/firebase_animated_list.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:fluttertoast/fluttertoast.dart';
// // import 'package:posproject/screens/addproduct.dart';
// // import 'package:posproject/utils/utils.dart';
// // import 'login.dart';
// //
// //
// //
// // class ProductListFireScreen extends StatefulWidget {
// //   const ProductListFireScreen({Key? key}) : super(key: key);
// //
// //   @override
// //   State<ProductListFireScreen> createState() => _ProductListFireScreenState();
// // }
// //
// // class _ProductListFireScreenState extends State<ProductListFireScreen> {
// //   final _auth = FirebaseAuth.instance;
// //   final fireStore = FirebaseFirestore.instance.collection('products').snapshots();
// //
// //   CollectionReference ref = FirebaseFirestore.instance.collection('products');
// //
// //   // final editController = TextEditingController();
// //   final searchFilterController = TextEditingController();
// //   final nameController = TextEditingController();
// //   final priceController = TextEditingController();
// //   final quantityController = TextEditingController();
// //   final purchasepriceController = TextEditingController();
// //
// //   String? productName;
// //   String? salePrice;
// //   String? productQuantity;
// //   String? purchasePrice;
// //
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return WillPopScope(
// //       onWillPop: () async {
// //         // return true;
// //         SystemNavigator.pop();
// //         return false;
// //       },
// //       child: Scaffold(
// //         backgroundColor: const Color(0xFFeeeeee),
// //         appBar: AppBar(
// //           centerTitle: true,
// //           title: const Text('Products List',
// //               style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
// //           backgroundColor: Colors.redAccent,
// //           actions: [
// //             IconButton(
// //               onPressed: () {
// //                 Navigator.pushReplacement(context,
// //                     MaterialPageRoute(builder: (context) => const ProductFire()));
// //               },
// //               icon: const Icon(
// //                 Icons.add,
// //                 color: Colors.white,
// //               ),
// //             ),
// //             const SizedBox(
// //               width: 10,
// //             )
// //           ],
// //           leading: IconButton(
// //             onPressed: () {
// //               showDialog(
// //                   context: context,
// //                   builder: (BuildContext context){
// //                     return AlertDialog(
// //                       title: const Text ('Do you want to SignOut?'),
// //                       actions: [
// //                         TextButton(
// //                           child :const Text('Yes'),
// //                           onPressed: () {
// //                             _auth.signOut().then((value) {
// //                               Navigator.push(
// //                                   context,
// //                                   MaterialPageRoute(
// //                                       builder: (context) => const LoginScreen()));
// //                             }).onError((error, stackTrace) {
// //                               Utils().toastMessage(error.toString());
// //                             });
// //                           },
// //                           style: TextButton.styleFrom(
// //                               primary: Colors.white,
// //                               backgroundColor: Colors.green,
// //                               textStyle: const TextStyle(
// //                                 fontSize: 14,
// //                               )
// //                           ),
// //
// //                         ),
// //                         TextButton(
// //                           child :const Text('No'),
// //                           onPressed: () => Navigator.push(
// //                               context,
// //                               MaterialPageRoute(
// //                                   builder: (context) => const ProductListFireScreen())),
// //                           style: TextButton.styleFrom(
// //                               primary: Colors.white,
// //                               backgroundColor:Colors.green,
// //                               textStyle: const TextStyle(
// //                                 fontSize:14,
// //                               )
// //                           ),
// //                         ),
// //                       ],
// //                     );
// //                   }
// //               );
// //             },
// //             icon: const Icon(Icons.logout),
// //           ),
// //         ),
// //         body: Container(
// //           child: Column(
// //             children: [
// //               const SizedBox(height: 10,),
// //               Padding(
// //                 padding: const EdgeInsets.symmetric(horizontal: 10),
// //                 child: TextFormField(
// //                   controller: searchFilterController,
// //                   decoration: const InputDecoration(
// //                     contentPadding: EdgeInsets.symmetric(vertical: 5.0),
// //                     hintText: 'Search',
// //                     border: OutlineInputBorder(),
// //                     prefixIcon:  Icon(Icons.search,color: Colors.teal,),
// //                   ),
// //                   onChanged: (String value){
// //                     setState(() {
// //
// //                     });
// //                   },
// //                 ),
// //               ),
// //               StreamBuilder(
// //                   stream: fireStore,
// //                   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
// //                     if(snapshot.connectionState == ConnectionState.waiting)
// //                       return CircularProgressIndicator();
// //
// //                     if(snapshot.hasError)
// //                       return Text("Some Error");
// //                     return
// //
// //
// //                       //   Expanded(
// //                       //   child: ListView.builder(
// //                       //     itemCount: snapshot.data!.docs.length,
// //                       //     itemBuilder: (context, index){
// //                       //       return ExpansionTile(
// //                       //         title: Text(snapshot.data!.docs[index].id.toString()),
// //                       //         title: Text(snapshot.data!.docs[index].id.toString()),
// //                       //         subtitle: ,
// //                       //       );
// //                       //     },
// //                       //   ),
// //                       // );
// //
// //                       Expanded(
// //                         child: ListView.builder(
// //                             itemCount: snapshot.data!.docs.length,
// //                             itemBuilder: (context, index){
// //                               salePrice =
// //                                   snapshot.data!.docs[index]['saleprice'].toString();
// //                               productQuantity =
// //                                   snapshot.data!.docs[index]['productquantity'].toString();
// //                               purchasePrice =
// //                                   snapshot.data!.docs[index]['purchaseprice'].toString();
// //                               final productName =
// //                               snapshot.data!.docs[index]['productname'].toString();
// //                               if(searchFilterController.text.isEmpty){
// //                                 return ExpansionTile(
// //                                   collapsedTextColor: Colors.black,
// //                                   textColor: Colors.redAccent,
// //                                   iconColor: Colors.redAccent,
// //                                   leading: const Icon(
// //                                     Icons.inventory_2_outlined,
// //                                     color: Colors.teal,
// //                                   ),
// //                                   title: Text(
// //                                     snapshot.data!.docs[index]['productname'].toString(),
// //                                     style: const TextStyle(
// //                                         fontWeight: FontWeight.w800, fontSize: 17),
// //                                   ),
// //                                   children: [
// //                                     Padding(
// //                                       padding: const EdgeInsets.only(left: 13),
// //                                       child: Align(
// //                                         alignment: Alignment.topLeft,
// //                                         child: Text(
// //                                           "Sale Price" +
// //                                               "                                      " + salePrice.toString(),
// //                                           // snapshot.child('saleprice').value.toString(),
// //                                           style: const TextStyle(
// //                                               color: Colors.black,
// //                                               fontSize: 17,
// //                                               fontWeight: FontWeight.w400),
// //                                         ),
// //                                       ),
// //                                     ),
// //                                     const SizedBox(
// //                                       height: 5.0,
// //                                     ),
// //                                     Padding(
// //                                       padding: const EdgeInsets.only(left: 13),
// //                                       child: Align(
// //                                         alignment: Alignment.topLeft,
// //                                         child: Text(
// //                                           "Product Quantity" +
// //                                               "                           " + productQuantity.toString(),
// //
// //                                           style: const TextStyle(
// //                                               color: Colors.black,
// //                                               fontSize: 17,
// //                                               fontWeight: FontWeight.w400),
// //                                         ),
// //                                       ),
// //                                     ),
// //                                     const SizedBox(
// //                                       height: 5.0,
// //                                     ),
// //                                     Padding(
// //                                       padding: const EdgeInsets.only(left: 13),
// //                                       child: Align(
// //                                         alignment: Alignment.topLeft,
// //                                         child: Text(
// //                                           "Purchase Price" +
// //                                               "                               " + purchasePrice.toString(),
// //                                           // snapshot.child('saleprice').value.toString(),
// //                                           style: const TextStyle(
// //                                               color: Colors.black,
// //                                               fontSize: 17,
// //                                               fontWeight: FontWeight.w400),
// //                                         ),
// //                                       ),
// //                                     ),
// //                                     const SizedBox(
// //                                       height: 5.0,
// //                                     ),
// //                                     Row(
// //                                       children: [
// //                                         const Padding(
// //                                           padding: EdgeInsets.only(left: 14),
// //                                           child: Text(
// //                                             "Update Data",
// //                                             style: TextStyle(
// //                                                 color: Colors.black,
// //                                                 fontWeight: FontWeight.bold,
// //                                                 fontSize: 18),
// //                                           ),
// //                                         ),
// //                                         const SizedBox(
// //                                           width: 180,
// //                                         ),
// //                                         IconButton(onPressed: (){
// //                                           showMyDialog(
// //                                             snapshot.data!.docs[index]['id'].toString(),
// //                                             snapshot.data!.docs[index]['productname'].toString(),
// //                                             snapshot.data!.docs[index]['saleprice'].toString(),
// //                                             snapshot.data!.docs[index]['productquantity'].toString(),
// //                                             snapshot.data!.docs[index]['purchaseprice'].toString(),
// //
// //                                           );
// //                                         }, icon: Icon(Icons.edit, color: Colors.green,))
// //
// //                                       ],
// //                                     ),
// //                                     const SizedBox(height: 10),
// //                                     Row(
// //                                       children: [
// //                                         const Padding(
// //                                           padding: EdgeInsets.only(left: 14),
// //                                           child: Text(
// //                                             "Delete Data",
// //                                             style: TextStyle(
// //                                                 color: Colors.black,
// //                                                 fontWeight: FontWeight.bold,
// //                                                 fontSize: 18),
// //                                           ),
// //                                         ),
// //                                         const SizedBox(
// //                                           width: 180,
// //                                         ),
// //                                         GestureDetector(
// //                                             onTap: () {
// //                                               showDialog(
// //                                                   context: context,
// //                                                   builder: (BuildContext context) {
// //                                                     return AlertDialog(
// //                                                       content: const Text(
// //                                                           "Are you sure you want to delete, if yes then press delete"),
// //                                                       actions: [
// //                                                         const SizedBox(
// //                                                           height: 4.0,
// //                                                         ),
// //                                                         Row(
// //                                                           mainAxisAlignment:
// //                                                           MainAxisAlignment.spaceEvenly,
// //                                                           children: [
// //                                                             MaterialButton(
// //                                                               onPressed: () {
// //                                                                 ref.doc (snapshot.data!.docs[index]['id'].toString()).delete();
// //                                                                 // Ref.child(snapshot.child("id").value.toString()).remove();
// //                                                                 setState(() {
// //                                                                   Navigator.pop(context, MaterialPageRoute(builder: (context) => const ProductListFireScreen()));
// //                                                                 });
// //                                                               },
// //                                                               color: Colors.redAccent,
// //                                                               child: const Text(
// //                                                                 "Delete",
// //                                                                 style: TextStyle(
// //                                                                     color: Colors.white),
// //                                                               ),
// //                                                             ),
// //                                                             MaterialButton(
// //                                                               color: Colors.green,
// //                                                               onPressed: () {
// //                                                                 Navigator.pop(context);
// //                                                               },
// //                                                               child: const Text(
// //                                                                 "No",
// //                                                                 style: TextStyle(
// //                                                                     color: Colors.white),
// //                                                               ),
// //                                                             )
// //                                                           ],
// //                                                         )
// //                                                       ],
// //                                                     );
// //                                                   });
// //                                             },
// //                                             child: const Icon(
// //                                               Icons.delete,
// //                                               color: Colors.red,
// //                                               size: 25,
// //                                             ))
// //                                       ],
// //                                     ),
// //                                     const SizedBox(
// //                                       height: 20,
// //                                     ),
// //
// //                                   ],
// //                                 );
// //                               }else if(productName.toLowerCase().contains(searchFilterController.text.toLowerCase())){
// //                                 return ExpansionTile(
// //                                   collapsedTextColor: Colors.black,
// //                                   textColor: Colors.redAccent,
// //                                   iconColor: Colors.redAccent,
// //                                   leading: const Icon(
// //                                     Icons.inventory_2_outlined,
// //                                     color: Colors.teal,
// //                                   ),
// //                                   title: Text(
// //                                     snapshot.data!.docs[index]['productname'].toString(),
// //                                     style: const TextStyle(
// //                                         fontWeight: FontWeight.w800, fontSize: 17),
// //                                   ),
// //                                   children: [
// //                                     Padding(
// //                                       padding: const EdgeInsets.only(left: 13),
// //                                       child: Align(
// //                                         alignment: Alignment.topLeft,
// //                                         child: Text(
// //                                           "Sale Price" +
// //                                               "                                      " + salePrice.toString(),
// //                                           // snapshot.child('saleprice').value.toString(),
// //                                           style: const TextStyle(
// //                                               color: Colors.black,
// //                                               fontSize: 17,
// //                                               fontWeight: FontWeight.w400),
// //                                         ),
// //                                       ),
// //                                     ),
// //                                     const SizedBox(
// //                                       height: 5.0,
// //                                     ),
// //                                     Padding(
// //                                       padding: const EdgeInsets.only(left: 13),
// //                                       child: Align(
// //                                         alignment: Alignment.topLeft,
// //                                         child: Text(
// //                                           "Product Quantity" +
// //                                               "                           " + productQuantity.toString(),
// //
// //                                           style: const TextStyle(
// //                                               color: Colors.black,
// //                                               fontSize: 17,
// //                                               fontWeight: FontWeight.w400),
// //                                         ),
// //                                       ),
// //                                     ),
// //                                     const SizedBox(
// //                                       height: 5.0,
// //                                     ),
// //                                     Padding(
// //                                       padding: const EdgeInsets.only(left: 13),
// //                                       child: Align(
// //                                         alignment: Alignment.topLeft,
// //                                         child: Text(
// //                                           "Purchase Price" +
// //                                               "                               " + purchasePrice.toString(),
// //                                           // snapshot.child('saleprice').value.toString(),
// //                                           style: const TextStyle(
// //                                               color: Colors.black,
// //                                               fontSize: 17,
// //                                               fontWeight: FontWeight.w400),
// //                                         ),
// //                                       ),
// //                                     ),
// //                                     const SizedBox(
// //                                       height: 5.0,
// //                                     ),
// //                                     Row(
// //                                       children: [
// //                                         const Padding(
// //                                           padding: EdgeInsets.only(left: 14),
// //                                           child: Text(
// //                                             "Update Data",
// //                                             style: TextStyle(
// //                                                 color: Colors.black,
// //                                                 fontWeight: FontWeight.bold,
// //                                                 fontSize: 18),
// //                                           ),
// //                                         ),
// //                                         const SizedBox(
// //                                           width: 180,
// //                                         ),
// //                                         IconButton(onPressed: (){
// //                                           showMyDialog(
// //                                             snapshot.data!.docs[index]['id'].toString(),
// //                                             snapshot.data!.docs[index]['productname'].toString(),
// //                                             snapshot.data!.docs[index]['saleprice'].toString(),
// //                                             snapshot.data!.docs[index]['productquantity'].toString(),
// //                                             snapshot.data!.docs[index]['purchaseprice'].toString(),
// //                                           );
// //                                         }, icon: Icon(Icons.edit, color: Colors.green,))
// //
// //                                       ],
// //                                     ),
// //                                     const SizedBox(height: 10),
// //                                     Row(
// //                                       children: [
// //                                         const Padding(
// //                                           padding: EdgeInsets.only(left: 14),
// //                                           child: Text(
// //                                             "Delete Data",
// //                                             style: TextStyle(
// //                                                 color: Colors.black,
// //                                                 fontWeight: FontWeight.bold,
// //                                                 fontSize: 18),
// //                                           ),
// //                                         ),
// //                                         const SizedBox(
// //                                           width: 180,
// //                                         ),
// //                                         GestureDetector(
// //                                             onTap: () {
// //                                               showDialog(
// //                                                   context: context,
// //                                                   builder: (BuildContext context) {
// //                                                     return AlertDialog(
// //                                                       content: const Text(
// //                                                           "Are you sure you want to delete, if yes then press delete"),
// //                                                       actions: [
// //                                                         const SizedBox(
// //                                                           height: 4.0,
// //                                                         ),
// //                                                         Row(
// //                                                           mainAxisAlignment:
// //                                                           MainAxisAlignment.spaceEvenly,
// //                                                           children: [
// //                                                             MaterialButton(
// //                                                               onPressed: () {
// //                                                                 ref.doc (snapshot.data!.docs[index]['id'].toString()).delete();
// //                                                                 // Ref.child(snapshot.child("id").value.toString()).remove();
// //                                                                 setState(() {
// //                                                                   Navigator.pop(context, MaterialPageRoute(builder: (context) => const ProductListFireScreen()));
// //                                                                 });
// //                                                               },
// //                                                               color: Colors.redAccent,
// //                                                               child: const Text(
// //                                                                 "Delete",
// //                                                                 style: TextStyle(
// //                                                                     color: Colors.white),
// //                                                               ),
// //                                                             ),
// //                                                             MaterialButton(
// //                                                               height: 10.0,
// //                                                               minWidth: double.infinity,
// //                                                               color: Colors.green,
// //                                                               onPressed: () {
// //                                                                 Navigator.pop(context);
// //                                                               },
// //                                                               child: const Text(
// //                                                                 "No",
// //                                                                 style: TextStyle(
// //                                                                     color: Colors.white),
// //                                                               ),
// //                                                             )
// //                                                           ],
// //                                                         )
// //                                                       ],
// //                                                     );
// //                                                   });
// //                                             },
// //                                             child: const Icon(
// //                                               Icons.delete,
// //                                               color: Colors.red,
// //                                               size: 25,
// //                                             ))
// //                                       ],
// //                                     ),
// //                                     const SizedBox(
// //                                       height: 20,
// //                                     ),
// //
// //                                   ],
// //                                 );
// //                               }else {
// //                                 return Container();
// //                               }
// //                             }),
// //                       );
// //                   }
// //               )
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   showMyDialog(String id ,String productName, String salePrice, String productQuantity, String purchasePrice) async {
// //     // nameController.text = products;
// //     nameController.text = productName;
// //     priceController.text = salePrice.toString();
// //     purchasepriceController.text = purchasePrice.toString();
// //     quantityController.text = productQuantity.toString();
// //
// //     return showDialog(
// //         context: context,
// //         builder: (BuildContext context ) {
// //           return AlertDialog(
// //             title: const Text('Update'),
// //             content: Container(
// //               width: MediaQuery.of(context).size.width,
// //               height: 250,
// //               child: Column(
// //                 children: [
// //                   TextFormField(
// //                     controller: nameController,
// //                     decoration: const InputDecoration(
// //                       hintText: "Product Name",
// //                     ),
// //                   ),
// //                   const SizedBox(height: 10,),
// //                   TextFormField(
// //                     controller: priceController,
// //                     keyboardType: TextInputType.number,
// //                     decoration: const InputDecoration(
// //                       hintText: "Sale Price",
// //                     ),
// //                   ),
// //                   const SizedBox(height: 10,),
// //                   TextFormField(
// //                     controller: quantityController,
// //                     keyboardType: TextInputType.number,
// //                     decoration: const InputDecoration(
// //                       hintText: "Product Quantity",
// //                     ),
// //                   ),
// //                   const SizedBox(height: 10,),
// //                   TextFormField(
// //                     controller: purchasepriceController,
// //                     keyboardType: TextInputType.number,
// //                     decoration: const InputDecoration(
// //                       hintText: "Purchase Price",
// //                     ),
// //                   )
// //                 ],
// //               ),
// //             ),
// //             actions: [
// //               TextButton(
// //                   onPressed: () {
// //                     Navigator.pop(context);
// //                   },
// //                   child: const Text('Cancel')),
// //               TextButton(
// //                   onPressed: () {
// //                     Navigator.pop(context);
// //                     ref.doc (id).update({
// //                       "productname": nameController.text.toLowerCase(),
// //                       "saleprice": priceController.text,
// //                       "productquantity": quantityController.text,
// //                       "purchaseprice": purchasepriceController.text,
// //                     }).then((value) {
// //                       Fluttertoast.showToast(msg: "Post Updated");
// //                     }).onError((error, stackTrace) {
// //                       Fluttertoast.showToast(msg: error.toString());
// //                     });
// //
// //                   },
// //                   child: const Text('Update')),
// //             ],
// //           );
// //         });
// //   }
// // }
//
//
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_database/ui/firebase_animated_list.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:posproject/screens/addproduct.dart';
// import 'package:posproject/utils/utils.dart';
// import 'login.dart';
//
//
//
// class ProductListFireScreen extends StatefulWidget {
//   const ProductListFireScreen({Key? key}) : super(key: key);
//
//   @override
//   State<ProductListFireScreen> createState() => _ProductListFireScreenState();
// }
//
// class _ProductListFireScreenState extends State<ProductListFireScreen> {
//   final _auth = FirebaseAuth.instance;
//   final fireStore = FirebaseFirestore.instance.collection('products').snapshots();
//
//   CollectionReference ref = FirebaseFirestore.instance.collection('products');
//
//   // final editController = TextEditingController();
//   final searchFilterController = TextEditingController();
//   final nameController = TextEditingController();
//   final priceController = TextEditingController();
//   final quantityController = TextEditingController();
//   final purchasepriceController = TextEditingController();
//
//   String? productName;
//   String? salePrice;
//   String? productQuantity;
//   String? purchasePrice;
//
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         // return true;
//         SystemNavigator.pop();
//         return false;
//       },
//       child: Scaffold(
//         backgroundColor: const Color(0xFFeeeeee),
//         appBar: AppBar(
//           centerTitle: true,
//           title: const Text('Products List',
//               style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//           backgroundColor: Colors.redAccent,
//           actions: [
//             IconButton(
//               onPressed: () {
//                 Navigator.pushReplacement(context,
//                     MaterialPageRoute(builder: (context) => const ProductFire()));
//               },
//               icon: const Icon(
//                 Icons.add,
//                 color: Colors.white,
//               ),
//             ),
//             const SizedBox(
//               width: 10,
//             )
//           ],
//           leading: IconButton(
//             onPressed: () {
//               showDialog(
//                   context: context,
//                   builder: (BuildContext context){
//                     return AlertDialog(
//                       title: const Text ('Do you want to SignOut?'),
//                       actions: [
//                         TextButton(
//                           child :const Text('Yes'),
//                           onPressed: () {
//                             _auth.signOut().then((value) {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => const LoginScreen()));
//                             }).onError((error, stackTrace) {
//                               Utils().toastMessage(error.toString());
//                             });
//                           },
//                           style: TextButton.styleFrom(
//                               primary: Colors.white,
//                               backgroundColor: Colors.green,
//                               textStyle: const TextStyle(
//                                 fontSize: 14,
//                               )
//                           ),
//
//                         ),
//                         TextButton(
//                           child :const Text('No'),
//                           onPressed: () => Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => const ProductListFireScreen())),
//                           style: TextButton.styleFrom(
//                               primary: Colors.white,
//                               backgroundColor:Colors.green,
//                               textStyle: const TextStyle(
//                                 fontSize:14,
//                               )
//                           ),
//                         ),
//                       ],
//                     );
//                   }
//               );
//             },
//             icon: const Icon(Icons.logout),
//           ),
//         ),
//         body: Container(
//           child: Column(
//             children: [
//               const SizedBox(height: 10,),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                 child: TextFormField(
//                   controller: searchFilterController,
//                   decoration: const InputDecoration(
//                     contentPadding: EdgeInsets.symmetric(vertical: 5.0),
//                     hintText: 'Search',
//                     border: OutlineInputBorder(),
//                     prefixIcon:  Icon(Icons.search,color: Colors.teal,),
//                   ),
//                   onChanged: (String value){
//                     setState(() {
//
//                     });
//                   },
//                 ),
//               ),
//               StreamBuilder(
//                   stream: fireStore,
//                   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
//                     if(snapshot.connectionState == ConnectionState.waiting)
//                       return CircularProgressIndicator();
//
//                     if(snapshot.hasError)
//                       return Text("Some Error");
//                     return
//
//
//                       //   Expanded(
//                       //   child: ListView.builder(
//                       //     itemCount: snapshot.data!.docs.length,
//                       //     itemBuilder: (context, index){
//                       //       return ExpansionTile(
//                       //         title: Text(snapshot.data!.docs[index].id.toString()),
//                       //         title: Text(snapshot.data!.docs[index].id.toString()),
//                       //         subtitle: ,
//                       //       );
//                       //     },
//                       //   ),
//                       // );
//
//                       Expanded(
//                         child: ListView.builder(
//                             itemCount: snapshot.data!.docs.length,
//                             itemBuilder: (context, index){
//                               salePrice =
//                                   snapshot.data!.docs[index]['saleprice'].toString();
//                               productQuantity =
//                                   snapshot.data!.docs[index]['productquantity'].toString();
//                               purchasePrice =
//                                   snapshot.data!.docs[index]['purchaseprice'].toString();
//                               final productName =
//                               snapshot.data!.docs[index]['productname'].toString();
//                               if(searchFilterController.text.isEmpty){
//                                 return ExpansionTile(
//                                   collapsedTextColor: Colors.black,
//                                   textColor: Colors.redAccent,
//                                   iconColor: Colors.redAccent,
//                                   leading: const Icon(
//                                     Icons.inventory_2_outlined,
//                                     color: Colors.teal,
//                                   ),
//                                   title: Text(
//                                     snapshot.data!.docs[index]['productname'].toString(),
//                                     style: const TextStyle(
//                                         fontWeight: FontWeight.w800, fontSize: 17),
//                                   ),
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.only(left: 13),
//                                       child: Align(
//                                         alignment: Alignment.topLeft,
//                                         child: Text(
//                                           "Sale Price" +
//                                               "                                      " + salePrice.toString(),
//                                           // snapshot.child('saleprice').value.toString(),
//                                           style: const TextStyle(
//                                               color: Colors.black,
//                                               fontSize: 17,
//                                               fontWeight: FontWeight.w400),
//                                         ),
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       height: 5.0,
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.only(left: 13),
//                                       child: Align(
//                                         alignment: Alignment.topLeft,
//                                         child: Text(
//                                           "Product Quantity" +
//                                               "                           " + productQuantity.toString(),
//
//                                           style: const TextStyle(
//                                               color: Colors.black,
//                                               fontSize: 17,
//                                               fontWeight: FontWeight.w400),
//                                         ),
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       height: 5.0,
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.only(left: 13),
//                                       child: Align(
//                                         alignment: Alignment.topLeft,
//                                         child: Text(
//                                           "Purchase Price" +
//                                               "                               " + purchasePrice.toString(),
//                                           // snapshot.child('saleprice').value.toString(),
//                                           style: const TextStyle(
//                                               color: Colors.black,
//                                               fontSize: 17,
//                                               fontWeight: FontWeight.w400),
//                                         ),
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       height: 5.0,
//                                     ),
//                                     Row(
//                                       children: [
//                                         const Padding(
//                                           padding: EdgeInsets.only(left: 14),
//                                           child: Text(
//                                             "Update Data",
//                                             style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 18),
//                                           ),
//                                         ),
//                                         const SizedBox(
//                                           width: 180,
//                                         ),
//                                         IconButton(onPressed: (){
//                                           showMyDialog(
//                                             snapshot.data!.docs[index]['id'].toString(),
//                                             snapshot.data!.docs[index]['productname'].toString(),
//                                             snapshot.data!.docs[index]['saleprice'].toString(),
//                                             snapshot.data!.docs[index]['productquantity'].toString(),
//                                             snapshot.data!.docs[index]['purchaseprice'].toString(),
//
//                                           );
//                                         }, icon: Icon(Icons.edit, color: Colors.green,))
//
//                                       ],
//                                     ),
//                                     const SizedBox(height: 10),
//                                     Row(
//                                       children: [
//                                         const Padding(
//                                           padding: EdgeInsets.only(left: 14),
//                                           child: Text(
//                                             "Delete Data",
//                                             style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 18),
//                                           ),
//                                         ),
//                                         const SizedBox(
//                                           width: 180,
//                                         ),
//                                         GestureDetector(
//                                             onTap: () {
//                                               showDialog(
//                                                   context: context,
//                                                   builder: (BuildContext context) {
//                                                     return AlertDialog(
//                                                       content: const Text(
//                                                           "Are you sure you want to delete, if yes then press delete"),
//                                                       actions: [
//                                                         const SizedBox(
//                                                           height: 4.0,
//                                                         ),
//                                                         Row(
//                                                           mainAxisAlignment:
//                                                           MainAxisAlignment.spaceEvenly,
//                                                           children: [
//                                                             MaterialButton(
//                                                               onPressed: () {
//                                                                 ref.doc (snapshot.data!.docs[index]['id'].toString()).delete();
//                                                                 // Ref.child(snapshot.child("id").value.toString()).remove();
//                                                                 setState(() {
//                                                                   Navigator.pop(context, MaterialPageRoute(builder: (context) => const ProductListFireScreen()));
//                                                                 });
//                                                               },
//                                                               color: Colors.redAccent,
//                                                               child: const Text(
//                                                                 "Delete",
//                                                                 style: TextStyle(
//                                                                     color: Colors.white),
//                                                               ),
//                                                             ),
//                                                             MaterialButton(
//                                                               color: Colors.green,
//                                                               onPressed: () {
//                                                                 Navigator.pop(context);
//                                                               },
//                                                               child: const Text(
//                                                                 "No",
//                                                                 style: TextStyle(
//                                                                     color: Colors.white),
//                                                               ),
//                                                             )
//                                                           ],
//                                                         )
//                                                       ],
//                                                     );
//                                                   });
//                                             },
//                                             child: const Icon(
//                                               Icons.delete,
//                                               color: Colors.red,
//                                               size: 25,
//                                             ))
//                                       ],
//                                     ),
//                                     const SizedBox(
//                                       height: 20,
//                                     ),
//
//                                   ],
//                                 );
//                               }
//                               else if(productName.toLowerCase().contains(searchFilterController.text.toLowerCase())){
//                                 return ExpansionTile(
//                                   collapsedTextColor: Colors.black,
//                                   textColor: Colors.redAccent,
//                                   iconColor: Colors.redAccent,
//                                   leading: const Icon(
//                                     Icons.inventory_2_outlined,
//                                     color: Colors.teal,
//                                   ),
//                                   title: Text(
//                                     snapshot.data!.docs[index]['productname'].toString(),
//                                     style: const TextStyle(
//                                         fontWeight: FontWeight.w800, fontSize: 17),
//                                   ),
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.only(left: 13),
//                                       child: Align(
//                                         alignment: Alignment.topLeft,
//                                         child: Text(
//                                           "Sale Price" +
//                                               "                                      " + salePrice.toString(),
//                                           // snapshot.child('saleprice').value.toString(),
//                                           style: const TextStyle(
//                                               color: Colors.black,
//                                               fontSize: 17,
//                                               fontWeight: FontWeight.w400),
//                                         ),
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       height: 5.0,
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.only(left: 13),
//                                       child: Align(
//                                         alignment: Alignment.topLeft,
//                                         child: Text(
//                                           "Product Quantity" +
//                                               "                           " + productQuantity.toString(),
//
//                                           style: const TextStyle(
//                                               color: Colors.black,
//                                               fontSize: 17,
//                                               fontWeight: FontWeight.w400),
//                                         ),
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       height: 5.0,
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.only(left: 13),
//                                       child: Align(
//                                         alignment: Alignment.topLeft,
//                                         child: Text(
//                                           "Purchase Price" +
//                                               "                               " + purchasePrice.toString(),
//                                           // snapshot.child('saleprice').value.toString(),
//                                           style: const TextStyle(
//                                               color: Colors.black,
//                                               fontSize: 17,
//                                               fontWeight: FontWeight.w400),
//                                         ),
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       height: 5.0,
//                                     ),
//                                     Row(
//                                       children: [
//                                         const Padding(
//                                           padding: EdgeInsets.only(left: 14),
//                                           child: Text(
//                                             "Update Data",
//                                             style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 18),
//                                           ),
//                                         ),
//                                         const SizedBox(
//                                           width: 180,
//                                         ),
//                                         IconButton(onPressed: (){
//                                           showMyDialog(
//                                             snapshot.data!.docs[index]['id'].toString(),
//                                             snapshot.data!.docs[index]['productname'].toString(),
//                                             snapshot.data!.docs[index]['saleprice'].toString(),
//                                             snapshot.data!.docs[index]['productquantity'].toString(),
//                                             snapshot.data!.docs[index]['purchaseprice'].toString(),
//                                           );
//                                         }, icon: Icon(Icons.edit, color: Colors.green,))
//
//                                       ],
//                                     ),
//                                     const SizedBox(height: 10),
//                                     Row(
//                                       children: [
//                                         const Padding(
//                                           padding: EdgeInsets.only(left: 14),
//                                           child: Text(
//                                             "Delete Data",
//                                             style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 18),
//                                           ),
//                                         ),
//                                         const SizedBox(
//                                           width: 180,
//                                         ),
//                                         GestureDetector(
//                                             onTap: () {
//                                               showDialog(
//                                                   context: context,
//                                                   builder: (BuildContext context) {
//                                                     return AlertDialog(
//                                                       content: const Text(
//                                                           "Are you sure you want to delete, if yes then press delete"),
//                                                       actions: [
//                                                         const SizedBox(
//                                                           height: 4.0,
//                                                         ),
//                                                         Row(
//                                                           mainAxisAlignment:
//                                                           MainAxisAlignment.spaceEvenly,
//                                                           children: [
//                                                             MaterialButton(
//                                                               onPressed: () {
//                                                                 ref.doc (snapshot.data!.docs[index]['id'].toString()).delete();
//                                                                 // Ref.child(snapshot.child("id").value.toString()).remove();
//                                                                 setState(() {
//                                                                   Navigator.pop(context, MaterialPageRoute(builder: (context) => const ProductListFireScreen()));
//                                                                 });
//                                                               },
//                                                               color: Colors.redAccent,
//                                                               child: const Text(
//                                                                 "Delete",
//                                                                 style: TextStyle(
//                                                                     color: Colors.white),
//                                                               ),
//                                                             ),
//                                                             MaterialButton(
//                                                               height: 10.0,
//                                                               minWidth: double.infinity,
//                                                               color: Colors.green,
//                                                               onPressed: () {
//                                                                 Navigator.pop(context);
//                                                               },
//                                                               child: const Text(
//                                                                 "No",
//                                                                 style: TextStyle(
//                                                                     color: Colors.white),
//                                                               ),
//                                                             )
//                                                           ],
//                                                         )
//                                                       ],
//                                                     );
//                                                   });
//                                             },
//                                             child: const Icon(
//                                               Icons.delete,
//                                               color: Colors.red,
//                                               size: 25,
//                                             ))
//                                       ],
//                                     ),
//                                     const SizedBox(
//                                       height: 20,
//                                     ),
//
//                                   ],
//                                 );
//                               }else {
//                                 return Container();
//                               }
//                             }),
//                       );
//                   }
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   showMyDialog(String id ,String productName, String salePrice, String productQuantity, String purchasePrice) async {
//     // nameController.text = products;
//     nameController.text = productName;
//     priceController.text = salePrice.toString();
//     purchasepriceController.text = purchasePrice.toString();
//     quantityController.text = productQuantity.toString();
//
//     return showDialog(
//         context: context,
//         builder: (BuildContext context ) {
//           return AlertDialog(
//             title: const Text('Update'),
//             content: Container(
//               width: MediaQuery.of(context).size.width,
//               height: 250,
//               child: Column(
//                 children: [
//                   TextFormField(
//                     controller: nameController,
//                     decoration: const InputDecoration(
//                       hintText: "Product Name",
//                     ),
//                   ),
//                   const SizedBox(height: 10,),
//                   TextFormField(
//                     controller: priceController,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(
//                       hintText: "Sale Price",
//                     ),
//                   ),
//                   const SizedBox(height: 10,),
//                   TextFormField(
//                     controller: quantityController,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(
//                       hintText: "Product Quantity",
//                     ),
//                   ),
//                   const SizedBox(height: 10,),
//                   TextFormField(
//                     controller: purchasepriceController,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(
//                       hintText: "Purchase Price",
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             actions: [
//               TextButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: const Text('Cancel')),
//               TextButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                     ref.doc (id).update({
//                       "productname": nameController.text.toLowerCase(),
//                       "saleprice": priceController.text,
//                       "productquantity": quantityController.text,
//                       "purchaseprice": purchasepriceController.text,
//                     }).then((value) {
//                       Fluttertoast.showToast(msg: "Post Updated");
//                     }).onError((error, stackTrace) {
//                       Fluttertoast.showToast(msg: error.toString());
//                     });
//
//                   },
//                   child: const Text('Update')),
//             ],
//           );
//         });
//   }
//
//
// }
//
//
// // child: Form(
// //   key: _formKey,
// //   child: Row(
// //     children: [
// //       Expanded(
// //         child: TextFormField(
// //           controller: _titleController,
// //           decoration: const InputDecoration(
// //             hintText: 'Enter task title...',
// //           ),
// //           validator: (value){
// //             if(value!.isEmpty){
// //               Fluttertoast.showToast(backgroundColor: Colors.purple,msg: "please enter Task");
// //             }
// //             return null ;
// //           },
// //         ),
// //       ),
// //       IconButton(
// //         icon: const Icon(Icons.calendar_today),
// //         onPressed: () async {
// //        pickedDate = await showDatePicker(
// //             context: context,
// //             initialDate: _selectedDateTime,
// //             firstDate: DateTime(2010),
// //             lastDate: DateTime(2101),
// //           );
// //
// //           if (pickedDate != null && pickedDate != _selectedDateTime) {
// //             setState(() {
// //               _selectedDateTime = pickedDate!;
// //             });
// //           }
// //         },
// //       ),
// //       ElevatedButton(
// //         onPressed: () async {
// //           if(_formKey.currentState!.validate()){
// //             print("Hello $pickedDate");
// //             if(pickedDate != null){
// //               await _firebaseService.addTask(_titleController.text, DateTime.now(), _auth.currentUser?.uid);
// //               _titleController.clear();
// //               pickedDate = null;
// //             }else{
// //               Fluttertoast.showToast(backgroundColor: Colors.purple, msg: "Please Enter Task and Pick Date");
// //             }
// //
// //           }
// //           // if (_titleController.text.isNotEmpty) {
// //           //   await _firebaseService.addTask(_titleController.text, DateTime.now(), _auth.currentUser?.uid);
// //           //   _titleController.clear();
// //           // }else{
// //           //   Fluttertoast.showToast(backgroundColor: Colors.purple,msg: "please enter Task");
// //           // }
// //         },
// //         child: const Text('Add Task'),
// //       ),
// //     ],
// //   ),
// // ),