import 'package:flutter/material.dart';
import 'database.dart';
import 'models.dart';

class EditCustomerScreen extends StatefulWidget {
  final Customer customer;
  final DatabaseHelper _db = DatabaseHelper();
  final Function(Customer) onUpdate;
  final Function(Customer) onDelete; // Add the onDelete callback
  EditCustomerScreen(this.customer, this.onUpdate, this.onDelete);

  @override
  _EditCustomerScreenState createState() => _EditCustomerScreenState();
}

class _EditCustomerScreenState extends State<EditCustomerScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.customer.name;
    _phoneController.text = widget.customer.phone ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Customer'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () async {
              bool confirmDelete = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Confirm Delete'),
                  content: Text('Are you sure you want to delete this customer?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text('Delete'),
                    ),
                  ],
                ),
              );

              if (confirmDelete == true) {
                await widget._db.deleteCustomer(widget.customer.id!);

                widget.onDelete(widget.customer);

                Navigator.pop(context);
              }
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Customer name',
                hintText: 'Enter Customer Name',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              maxLength: 11,
              decoration: InputDecoration(
                labelText: 'Phone number (optional)',
                hintText: 'Enter Phone Number (optional)',
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 7),
            ElevatedButton(
              onPressed: () async {
                // Validate the form fields
                if (_nameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a name')),
                  );
                  return;
                }

                Customer updatedCustomer = Customer(
                  id: widget.customer.id,
                  name: _nameController.text,
                  phone: _phoneController.text.isNotEmpty ? _phoneController.text : null,
                );

                await widget._db.updateCustomer(updatedCustomer);

                widget.onUpdate(updatedCustomer);

                Navigator.pop(context, updatedCustomer);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green[105],
                elevation: 9,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                fixedSize: const Size(200, 65),
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
