import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'Edit_customer_Details.dart';
import 'database.dart';
import 'models.dart';
import 'package:realtime_database_udhaar_app/Sale_Screen.dart';
import 'package:realtime_database_udhaar_app/Expense_Screen.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
class CustomerDetailsScreen extends StatefulWidget {
  late final Customer customer;
  final DatabaseHelper _db = DatabaseHelper();

  CustomerDetailsScreen(this.customer);

  @override
  _CustomerDetailsScreenState createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen>with SingleTickerProviderStateMixin {
  late Future<double> _totalBalance;
  late Future<List<Sale>> _sales;
  late Future<List<Expense>> _expenses;
  late Customer _customer;
  late AnimationController _controller;
  late Animation<double> _animation;


  @override
  void initState() {
    super.initState();
    // Initialize the Future variables with empty lists
    _totalBalance = Future.value(0.0);
    _sales = Future.value([]);
    _expenses = Future.value([]);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = Tween<double>(begin: 0, end: 50).animate(_controller);

    _controller.repeat(reverse: true);
    _customer = widget.customer; // Change this line
    // _updateData(); // Remove this line
  }
  @override
  void dispose() {
    // Dispose of the AnimationController
    _controller.dispose();
    super.dispose();
  }
  Future<void> _handleCustomerUpdate(Customer updatedCustomer) async {
    try {
      // Update the UI with the new customer data
      setState(() {
        _customer = updatedCustomer;
        _totalBalance = Future.value(_totalBalance);
        _sales = Future.value(_sales);
        _expenses = Future.value(_expenses);
      });
    } catch (error) {
      print("Error updating data: $error");
    }
  }




  Future<void> generateCustomerPDF(
      Customer customer,
      double totalBalance,
      List<Sale> sales,
      List<Expense> expenses,
      ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text('Customer Details'),
          ),
          pw.Text('Customer Name: ${customer.name}'),
          pw.Text('Total Balance: $totalBalance'),
          pw.Header(
            level: 1,
            child: pw.Text('Sales'),
          ),
          for (final sale in sales)
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Amount: ${sale.amount}'),
                pw.Text('Date: ${DateFormat('yyyy-MM-dd').format(sale.saleDate)}'),
                pw.Text('Time: ${DateFormat('HH:mm').format(DateTime(2020, 1, 1, sale.saleTime.hour,  sale.saleTime.minute))}'),

              ],
            ),
          pw.Header(
            level: 1,
            child: pw.Text('Expenses'),
          ),
          for (final expense in expenses)
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Amount: ${expense.amount}'),
                pw.Text('Date: ${DateFormat('yyyy-MM-dd').format(expense.expenseDate)}'),
                pw.Text('Time: ${DateFormat('HH:mm').format(DateTime(2020, 1, 1, expense.expenseTime.hour, expense.expenseTime.minute))}'),

              ],
            ),
        ],
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/customer_details_${customer.id}.pdf');
    await file.writeAsBytes(await pdf.save());

    // Use share_plus to share the PDF file
    await Share.shareFiles([file.path], text: 'Customer Details PDF');
  }

  Future<void> _updateData() async {
    try {
      Customer? updatedCustomer = await widget._db.getCustomer(widget.customer.id!);
      double totalBalance = await widget._db.getBalanceForCustomer(widget.customer.id!);
      List<Sale> sales = await widget._db.getSalesForCustomer(widget.customer.id!);
      List<Expense> expenses = await widget._db.getExpensesForCustomer(widget.customer.id!);

      if (updatedCustomer != null) {
        setState(() {
          _customer = updatedCustomer;
          _totalBalance = Future.value(totalBalance);
          _sales = Future.value(sales);
          _expenses = Future.value(expenses);
        });
      }
    } catch (error) {
      print("Error updating data: $error");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                widget.customer.name[0].toUpperCase(),
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(width: 8),
            Text(widget.customer.name),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: () async {
              final totalBalance = await widget._db.getBalanceForCustomer(widget.customer.id!);
              final sales = await widget._db.getSalesForCustomer(widget.customer.id!);
              final expenses = await widget._db.getExpensesForCustomer(widget.customer.id!);
              late AnimationController _controller;
              late Animation<double> _animation;

              await generateCustomerPDF(widget.customer, totalBalance, sales, expenses);
            },
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              // Navigate to the EditCustomerScreen and wait for the result
              Customer? updatedCustomer = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditCustomerScreen(widget.customer, _handleCustomerUpdate, (customer) {}),
                ),
              );

              // Check if the customer was updated
              if (updatedCustomer != null) {
                // Existing code for handling customer update
              }
            },
          ),








        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FutureBuilder(
                    future: _totalBalance,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final totalBalance =
                        (snapshot.data ?? 0).clamp(0.0, double.infinity);
                        return Text(
                          totalBalance == 0
                              ? 'Transaction clear'
                              : 'Total Balance: $totalBalance',
                          style: TextStyle(
                            fontSize: 16,
                            color: totalBalance == 0 ? Colors.red : null,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sales',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        FutureBuilder(
                          future: _sales,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              final sales = snapshot.data as List<Sale>;
                              return sales.isEmpty
                                  ? Text('No sales yet.')
                                  : Column(
                                children: sales.map((sale) {
                                  return ListTile(
                                    title: Text(
                                      'Amount: ${sale.amount}',
                                    ),
                                    subtitle: Text(
                                      'Date: ${DateFormat('yyyy-MM-dd').format(sale.saleDate)}\nTime: ${sale.saleTime.format(context)}',
                                    ),
                                  );
                                }).toList(),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              // Display expenses in the form of cards
              Container(
                width: double.infinity,
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Expenses',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        FutureBuilder(
                          future: _expenses,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              final expenses = snapshot.data as List<Expense>;
                              return expenses.isEmpty
                                  ? Text('No expenses yet.')
                                  : Column(
                                children: expenses.map((expense) {
                                  return ListTile(
                                    title: Text(
                                      'Amount: ${expense.amount}',
                                    ),
                                    subtitle: Text(
                                      'Date: ${DateFormat('yyyy-MM-dd').format(expense.expenseDate)}\nTime: ${expense.expenseTime.format(context)}',
                                    ),
                                  );
                                }).toList(),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _animation.value),
                      child: const Icon(
                          Icons.arrow_downward, size: 24, color: Colors.black),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 100,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AddSaleScreen(widget.customer),
                        ),
                      );
                      _updateData();
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
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_upward, color: Colors.white),
                          SizedBox(width: 6),
                          Text(
                            'Maine Liye',
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
                  ElevatedButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AddExpenseScreen(widget.customer),
                        ),
                      );
                      _updateData();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange, // Change the color to orange
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 5,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.orangeAccent, Colors.orange],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_downward, color: Colors.white),
                          SizedBox(width: 6),
                          Text(
                            'Maine Diye',
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
                ],
              ),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}




