import 'package:flutter/material.dart';
import 'database.dart';
import 'models.dart';
import 'package:firebase_database/firebase_database.dart';

class AddCustomerScreen extends StatefulWidget {
  @override
  _AddCustomerScreenState createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  late DatabaseReference _customersRef;
  final DatabaseHelper _db = DatabaseHelper();
  bool _isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    _customersRef = FirebaseDatabase.instance.reference().child('customers');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Customer'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              onChanged: (_) => _enableButton(),
              keyboardType: TextInputType.phone,
              maxLength: 11,
              decoration: const InputDecoration(
                labelText: 'Phone number (optional)',
                hintText: 'Enter Phone Number (optional)',
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 7),
            Container(
              margin: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: _isButtonDisabled ? null : () async {
                  if (_nameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter a name')),
                    );
                    return;
                  }

                  Customer newCustomer = Customer(
                    name: _nameController.text,
                    phone: _phoneController.text.isNotEmpty
                        ? _phoneController.text
                        : null,
                  );

                  await _db.insertCustomer(newCustomer);

                  await _customersRef.push().set(newCustomer.toJson());

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: _isButtonDisabled ? Colors.grey : Colors.green[105],
                  elevation: 9,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  fixedSize: const Size(200, 65),
                ),
                child: const Text(
                  'Save Customer',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _enableButton() {
    setState(() {
      _isButtonDisabled = _nameController.text.isEmpty && _phoneController.text.isEmpty;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
