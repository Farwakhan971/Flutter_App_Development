import 'package:flutter/material.dart';
import 'Add_customer.dart';
import 'Customer_Detail_Screen.dart';
import 'database.dart';
import 'models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class CustomerListScreen extends StatefulWidget {
  @override
  _CustomerListScreenState createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  final DatabaseHelper _db = DatabaseHelper();
  List<Customer> _customers = [];

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    final customers = await _db.getAllCustomers();
    setState(() {
      _customers = customers;
    });
  }


  Future<void> exportToCSV() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      String filePath = '${directory.path}/exported_data.csv';

      print('About to export data to CSV. File Path: $filePath');

      await _db.exportCustomerData(filePath);

      // Share the file using the share_plus package
      await Share.shareFiles([filePath], text: 'Sharing CSV file');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data exported and shared successfully')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error exporting data: $error')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Udhaar Book'),
        actions: [
          IconButton(
            iconSize: 22,
            icon: const Icon(Icons.file_copy),
            onPressed: () {
              exportToCSV();
            },
          ),
        ],
      ),
      body:ListView.builder(
        itemCount: _customers.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              title: Text(
                _customers[index].name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                _customers[index].phone ?? 'No phone number',
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
              leading: CircleAvatar(
                backgroundColor: Colors.purple,
                child: Icon(Icons.person, color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomerDetailsScreen(_customers[index]),
                  ),
                );
              },
            ),
          );
        },
      ),

      floatingActionButton: Container(
        margin: EdgeInsets.only(left: 28),
        child: ElevatedButton(
          onPressed: () async {
            // Navigate to the AddCustomerScreen when the button is pressed
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddCustomerScreen(),
              ),
            );
            // Reload customers after adding a new one
            await _loadCustomers();
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 5,
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.lightGreen, Colors.green],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: Colors.white),
                SizedBox(width: 6),
                Text(
                  'ADD CUSTOMER',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
