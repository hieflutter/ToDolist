import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todolist/db_helper.dart';
import 'package:todolist/Notification_Services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isDark = false;
  DateTime _datePicked = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> _allData = [];
  List<Map<String, dynamic>> _filteredData = [];
  bool isLoading = true;
  bool _isLoading = false;
  bool _isSearching = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  String? datePicked;
  String? pickedTime;

  @override
  void initState() {
    super.initState();
    _refreshData();
    _searchController.addListener(_filterData);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _refreshData() async {
    final data = await SQLHelper.getAllData();
    setState(() {
      _allData = data;
      _filteredData = data; // Initialize filtered data with all data
      isLoading = false;
    });
  }

  void _filterData() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredData = _allData.where((item) {
        final titleLower = item['title'].toLowerCase();
        final descLower = item['desc'].toLowerCase();
        return titleLower.contains(query) || descLower.contains(query);
      }).toList();
    });
  }

  Future<void> _addData() async {
    datePicked ??= DateFormat('dd-MM-yyyy').format(DateTime.now());
    await SQLHelper.createData(
      _titleController.text,
      _descController.text,
      datePicked!,
      pickedTime ?? '',
    );

    if (pickedTime != null) {
      final scheduledDateTime =
          DateFormat('dd-MM-yyyy HH:mm').parse('$datePicked $pickedTime');
    }

    _refreshData();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _updateData(int id) async {
    datePicked ??= DateFormat('dd-MM-yyyy').format(DateTime.now());
    await SQLHelper.updateData(
      id,
      _titleController.text,
      _descController.text,
      datePicked ?? '',
      pickedTime ?? '',
    );

    if (pickedTime != null) {
      final scheduledDateTime =
          DateFormat('dd-MM-yyyy HH:mm').parse('$datePicked $pickedTime');
    }

    _refreshData();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _deleteData(int id) async {
    await SQLHelper.deleteData(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text("Data Deleted"),
      ),
    );
    _refreshData();
  }

  void _selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _datePicked,
      firstDate: DateTime(2020),
      lastDate: DateTime(2040),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.indigo,
            hintColor: Colors.indigo,
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null && selectedDate != _datePicked) {
      setState(() {
        _datePicked = selectedDate;
        datePicked = DateFormat('dd-MM-yyyy').format(_datePicked);
      });
    }
  }

  void _selectTime() async {
    final pickedTimeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.input,
    );

    if (pickedTimeOfDay != null) {
      setState(() {
        pickedTime = pickedTimeOfDay.format(context);
      });
    }
  }

  void showBottomSheet(int? id) async {
    if (id != null) {
      final existingData =
          _allData.firstWhere((element) => element['id'] == id);
      _titleController.text = existingData['title'];
      _descController.text = existingData['desc'];
      datePicked = existingData['date'];
      pickedTime = existingData['time'];
    } else {
      _titleController.clear();
      _descController.clear();
      datePicked = null;
      pickedTime = null;
    }

    showModalBottomSheet(
      elevation: 5,
      isScrollControlled: true,
      context: context,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          top: 30,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 50,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Title",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _descController,
                maxLines: 4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Description",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Fill the details';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _selectDate,
                    icon: Icon(Icons.calendar_month_outlined),
                    color: Colors.indigo,
                  ),
                  IconButton(
                    onPressed: _selectTime,
                    icon: Icon(Icons.timer),
                    color: Colors.indigo,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.only(top: 5, left: 10),
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      setState(() {
                        _isLoading = true;
                      });

                      if (id == null) {
                        await _addData();
                      } else {
                        await _updateData(id);
                      }
                      _titleController.clear();
                      _descController.clear();
                      datePicked = null;
                      pickedTime = null;
                      Navigator.of(context).pop();
                      Future.delayed(
                        const Duration(seconds: 3),
                      );
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  },
                  child: isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Loading...'),
                            CircularProgressIndicator(
                              color: Colors.white,
                            )
                          ],
                        )
                      : Text(
                          id == null ? "Add Data" : "Update",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    padding:
                        EdgeInsets.symmetric(vertical: 14, horizontal: 100),
                    backgroundColor: Colors.indigo[700],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleSearchBar() {
    setState(() {
      _isSearching = !_isSearching;
      _searchController.clear();
      _filterData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 236, 196, 78),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search...........',
                  hintStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none,
                ),
                style: TextStyle(color: Colors.black, fontSize: 18.0),
              )
            : Text('Add Todo`s'),
        toolbarHeight: 90.2,
        toolbarOpacity: 0.8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(50),
            bottomLeft: Radius.circular(50),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.cancel : Icons.search),
            onPressed: _toggleSearchBar,
            color: Colors.white,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _filteredData.length,
              itemBuilder: (context, index) => Card(
                margin: EdgeInsets.all(15),
                child: ListTile(
                  title: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      _filteredData[index]['title'],
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_filteredData[index]['desc']),
                      Text(
                        'Date: ${_filteredData[index]['date']}',
                        style: TextStyle(color: Colors.black54),
                      ),
                      if (_filteredData[index]['time'].isNotEmpty)
                        Text(
                          'Time: ${_filteredData[index]['time']}',
                          style: TextStyle(color: Colors.black54),
                        ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          showBottomSheet(_filteredData[index]['id']);
                        },
                        icon: Icon(Icons.edit),
                        color: Colors.indigo,
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text("Alert"),
                              content: const Text(
                                  "Are you sure you want to delete this item?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("No"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _deleteData(_filteredData[index]['id']);
                                  },
                                  child: const Text("Yes"),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: Icon(Icons.delete),
                        color: Colors.redAccent,
                      ),
                    ],
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showBottomSheet(null),
        child: Icon(Icons.assignment_add),
      ),
    );
  }
}
