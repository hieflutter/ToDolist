// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:todolist/db_helper.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   DateTime _datePicked = DateTime.now();
//   final _formKey = GlobalKey<FormState>();
//   List<Map<String, dynamic>> _allData = [];
//   bool isLoading = true;

//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _descController = TextEditingController();
//   String? datePicked;
//   String? pickedTime;

//   @override
//   void initState() {
//     super.initState();
//     _refreshData();
//   }

//   void _refreshData() async {
//     final data = await SQLHelper.getAllData();
//     setState(() {
//       _allData = data;
//       isLoading = false;
//     });
//   }

//   Future<void> _addData() async {
//     await SQLHelper.createData(
//       _titleController.text,
//       _descController.text,
//       datePicked.toString(),
//       pickedTime.toString(),
//     );
//     _refreshData();
//   }

//   Future<void> _updateData(int id) async {
//     await SQLHelper.updateData(
//       id,
//       _titleController.text,
//       _descController.text,
//       datePicked.toString(),
//       pickedTime.toString(),
//     );
//     _refreshData();
//   }

//   Future<void> _deleteData(int id) async {
//     await SQLHelper.deleteData(id);
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         backgroundColor: Colors.redAccent,
//         content: Text("Data Deleted"),
//       ),
//     );
//     _refreshData();
//   }

//   void _selectDate() async {
//     final selectedDate = await showDialog<DateTime>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Calendar'),
//         content: SizedBox(
//           height: 250,
//           child: Column(
//             children: [
//               Expanded(
//                 child: CalendarDatePicker(
//                   initialDate: _datePicked,
//                   firstDate: DateTime(2020),
//                   lastDate: DateTime(2030),
//                   onDateChanged: (date) {
//                     Navigator.of(context).pop(date);
//                   },
//                 ),
//               ),
//               SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.of(context).pop(_datePicked);
//                 },
//                 child: Text('OK'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );

//     if (selectedDate != null) {
//       setState(() {
//         _datePicked = selectedDate;
//         datePicked = DateFormat('yyyy-MM-dd').format(_datePicked);
//       });
//     }
//   }

//   void _selectTime() async {
//     final pickedTimeOfDay = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//       initialEntryMode: TimePickerEntryMode.input,
//     );

//     if (pickedTimeOfDay != null) {
//       setState(() {
//         pickedTime = pickedTimeOfDay.format(context);
//       });
//     }
//   }

//   void showBottomSheet(int? id) async {
//     if (id != null) {
//       final existingData =
//           _allData.firstWhere((element) => element['id'] == id);
//       _titleController.text = existingData['title'];
//       _descController.text = existingData['desc'];
//       datePicked = existingData['date'];
//       pickedTime = existingData['time'];
//     } else {
//       _titleController.clear();
//       _descController.clear();
//       datePicked = null;
//       pickedTime = null;
//     }

//     showModalBottomSheet(
//       elevation: 5,
//       isScrollControlled: true,
//       context: context,
//       builder: (_) => Padding(
//         padding: EdgeInsets.only(
//           top: 30,
//           left: 15,
//           right: 15,
//           bottom: MediaQuery.of(context).viewInsets.bottom + 50,
//         ),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               TextFormField(
//                 controller: _titleController,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                   hintText: "Title",
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a title';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 10),
//               TextFormField(
//                 controller: _descController,
//                 maxLines: 4,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                   hintText: "Description",
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Fill the details';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   IconButton(
//                     onPressed: _selectDate,
//                     icon: Icon(Icons.calendar_month_outlined),
//                     color: Colors.indigo,
//                   ),
//                   IconButton(
//                     onPressed: _selectTime,
//                     icon: Icon(Icons.timer),
//                     color: Colors.indigo,
//                   ),
//                 ],
//               ),
//               if (datePicked != null)
//                 Padding(
//                   padding: EdgeInsets.symmetric(vertical: 5),
//                   child: Text(
//                     'Selected Date: $datePicked',
//                     style: TextStyle(fontSize: 16, color: Colors.black54),
//                   ),
//                 ),
//               if (pickedTime != null)
//                 Padding(
//                   padding: EdgeInsets.symmetric(vertical: 5),
//                   child: Text(
//                     'Selected Time: $pickedTime',
//                     style: TextStyle(fontSize: 16, color: Colors.black54),
//                   ),
//                 ),
//               SizedBox(height: 10),
//               Container(
//                 padding: EdgeInsets.only(top: 5, left: 10),
//                 width: MediaQuery.of(context).size.width,
//                 child: ElevatedButton(
//                   onPressed: () async {
//                     if (_formKey.currentState?.validate() ?? false) {
//                       if (id == null) {
//                         await _addData();
//                       } else {
//                         await _updateData(id);
//                       }
//                       _titleController.clear();
//                       _descController.clear();
//                       datePicked = null;
//                       pickedTime = null;
//                       Navigator.of(context).pop();
//                     }
//                   },
//                   child: Text(
//                     id == null ? "Add Data" : "Update",
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                       fontSize: 16,
//                     ),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     shape: StadiumBorder(),
//                     padding:
//                         EdgeInsets.symmetric(vertical: 14, horizontal: 100),
//                     backgroundColor: Colors.indigo[700],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 236, 196, 78),
//         title: Text('Home Page'),
//         toolbarHeight: 90.2,
//         toolbarOpacity: 0.8,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//             bottomRight: Radius.circular(50),
//             bottomLeft: Radius.circular(50),
//           ),
//         ),
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: _allData.length,
//               itemBuilder: (context, index) => Card(
//                 margin: EdgeInsets.all(15),
//                 child: ListTile(
//                   title: Padding(
//                     padding: EdgeInsets.symmetric(vertical: 5),
//                     child: Text(
//                       _allData[index]['title'],
//                       style: TextStyle(fontSize: 20),
//                     ),
//                   ),
//                   subtitle: Text(_allData[index]['desc']),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       IconButton(
//                         onPressed: () {
//                           showBottomSheet(_allData[index]['id']);
//                         },
//                         icon: Icon(Icons.edit),
//                         color: Colors.indigo,
//                       ),
//                       IconButton(
//                         onPressed: () {
//                           showDialog(
//                             context: context,
//                             builder: (BuildContext context) => AlertDialog(
//                               title: const Text("Alert"),
//                               content: const Text(
//                                   "Are you sure you want to delete this item?"),
//                               actions: [
//                                 TextButton(
//                                   onPressed: () {
//                                     Navigator.of(context).pop();
//                                   },
//                                   child: const Text("No"),
//                                 ),
//                                 TextButton(
//                                   onPressed: () {
//                                     Navigator.of(context).pop();
//                                     _deleteData(_allData[index]['id']);
//                                   },
//                                   child: const Text("Yes"),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                         icon: Icon(Icons.delete),
//                         color: Colors.redAccent,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => showBottomSheet(null),
//         child: Icon(Icons.assignment_add),
//       ),
//     );
//   }
// }
