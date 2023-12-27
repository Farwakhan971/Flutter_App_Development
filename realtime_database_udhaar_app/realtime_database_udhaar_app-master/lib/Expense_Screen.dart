import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'database.dart';
import 'models.dart';
import 'package:intl/intl.dart';

class AddExpenseScreen extends StatefulWidget {
  final Customer customer;
  final DatabaseHelper _db = DatabaseHelper();

  AddExpenseScreen(this.customer);

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final TextEditingController _amountController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  late final DatabaseReference _expenseRef;
  late Future<List<Expense>> _expenses;
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
    _expenseRef =   FirebaseDatabase.instance.reference().child('expense');
    _expenses = widget._db.getExpensesForCustomer(widget.customer.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                  ),
                ),
                SizedBox(height: 60),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: Text(
                          _selectedDate == null
                              ? 'Select Date'
                              : 'Date: ${_selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : 'Select Date'}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.purple,
                          ),
                        ),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );

                          if (pickedDate != null && pickedDate != _selectedDate) {
                            setState(() {
                              _selectedDate = pickedDate;
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ListTile(
                        title: Text(
                          _selectedTime == null
                              ? 'Select Time'
                              : 'Time: \n${_selectedTime != null ? _selectedTime!.format(context) : 'Select Time'}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.purple,
                          ),
                        ),
                        onTap: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );

                          if (pickedTime != null && pickedTime != _selectedTime) {
                            setState(() {
                              _selectedTime = pickedTime;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 70),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_amountController.text.isEmpty || _selectedDate == null || _selectedTime == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please fill in all fields')),
                        );
                        return;
                      }

                      double amount = double.parse(_amountController.text);

                      Expense expense = Expense(
                        customerId: widget.customer.id!,
                        amount: amount,
                        expenseDate: _selectedDate!,
                        expenseTime: _selectedTime!,
                      );

                      await widget._db.insertExpense(expense);
                      try {
                        await _expenseRef.push().set(expense.toJson());
                      } catch (e, stackTrace) {
                        print('Error updating data: $e');
                        print('StackTrace: $stackTrace');
                      }
                      // Navigate back to the Customer Details screen
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.purple,
                      onPrimary: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 13, horizontal: 20),
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                      elevation: 5,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.purple, Colors.white10],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                      child: Text('Save Expense'),
                    ),
                  ),

                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}
