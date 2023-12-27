import 'package:flutter/material.dart';
import 'package:udhaar_app_withfirebase_andsqlflite/database_class.dart';

import 'add_customer_screen.dart';
import 'model.dart';
class customerlistscreen extends StatefulWidget {
  const customerlistscreen({super.key});

  @override
  State<customerlistscreen> createState() => _customerlistscreenState();
}

class _customerlistscreenState extends State<customerlistscreen> {
  List<Customer> _customers = [];
  final Databasehelper _db = Databasehelper();
  Future<void> _loadCustomers() async{
    final customers = await _db.getAllCustomers();
    setState(() {
      _customers = customers;
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer List'),

      ),
      body: ListView.builder(itemCount: _customers.length,
          itemBuilder: (context, index){
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
              _customers[index].phone ?? 'No Phone Number',
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),

            ),
            leading: CircleAvatar(
              backgroundColor: Colors.purple,
              child: Icon(Icons.person, color: Colors.white),
            ),
            onTap: ()
            {

            },
          ),
        );
          }
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(left: 28),
        child: ElevatedButton(
          onPressed: ()
          async {
            await Navigator.push(context, MaterialPageRoute(builder: (context) => AddCustomerScreen()
              ,),);
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
