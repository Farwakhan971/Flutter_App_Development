import 'package:flutter/material.dart';
import 'package:udhaar_app_withfirebase_andsqlflite/database_class.dart';
import 'package:firebase_database/firebase_database.dart';

import 'model.dart';
class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}
class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isButtonDisabled = true;
  late DatabaseReference _customerRef;
  final Databasehelper _db = Databasehelper();
  @override
  void initState(){
    super.initState();
    _customerRef = FirebaseDatabase.instance.reference().child('customers');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Customer',
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              onChanged: (_) => _enableButton(),
              decoration: const InputDecoration(
                labelText: 'Customer name',
                hintText: 'Enter Customer Name',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16,),
            TextField(
              controller: _phoneController,
              onChanged: (_) => _enableButton(),
              keyboardType: TextInputType.phone,
              maxLength: 11,
              decoration: const InputDecoration(
                labelText: 'Phone Number (optional)',
                hintText: 'Enter Phone number (optional)',
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 7,),
            Container(
              margin: const EdgeInsets.all(50),
              child: ElevatedButton(
                onPressed: _isButtonDisabled ? null : () async{
                  if(_nameController.text.isEmpty)
                    {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please Enter a name'),),);
                      return;
                    }
                  Customer newCustomer = Customer(
                    name: _nameController.text,
                    phone: _phoneController.text.isNotEmpty?_phoneController.text : null,
                  );
                  await _db.insertCustomer(newCustomer);
                  await _customerRef.push().set(newCustomer.toJson());
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: _isButtonDisabled ? Colors.grey : Colors.red[105],
                  elevation: 9,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  fixedSize: const Size(200, 65),
                ),
                child: const Text(
                  'Save Customer',
                  style: TextStyle(fontSize: 20 ),
                ),
              ),
            )
          ],

        ),
      ),
    );
  }
  void _enableButton()
  {
    setState(() {
      _isButtonDisabled = _nameController.text.isEmpty && _phoneController.text.isEmpty;
    });
  }
@override
  void dispose()
{
  _nameController.dispose();
  _phoneController.dispose();
  super.dispose();
}
}
