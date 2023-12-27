import 'package:flutter/material.dart';

class Customer {
  late String key;
  final int? id;
  final String name;
  final String? phone;
  final String? photo;

  Customer({
    this.id,
    required this.name,
    this.phone,
    this.photo,
  });
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'photo': photo,
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      photo: map['photo'],
    );
  }
}

class Sale {
  int? id;
  int customerId;
  double amount;
  DateTime saleDate;
  TimeOfDay saleTime;

  Sale({
    this.id,
    required this.customerId,
    required this.amount,
    required this.saleDate,
    required this.saleTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer_id': customerId,
      'amount': amount,
      'sale_date': saleDate.toIso8601String(),
      'sale_time': '${saleTime.hour}:${saleTime.minute}',
    };
  }

  Sale.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        customerId = map['customer_id'],
        amount = map['amount'],
        saleDate = DateTime.parse(map['sale_date']),
        saleTime = TimeOfDay(
          hour: int.parse(map['sale_time'].split(':')[0]),
          minute: int.parse(map['sale_time'].split(':')[1]),
        );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'amount': amount,
      'sale_date': saleDate.toIso8601String(),
      'sale_time': '${saleTime.hour}:${saleTime.minute}',
    };
  }

  Sale.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        customerId = json['customer_id'],
        amount = json['amount'],
        saleDate = DateTime.parse(json['sale_date']),
        saleTime = TimeOfDay(
          hour: int.parse(json['sale_time'].split(':')[0]),
          minute: int.parse(json['sale_time'].split(':')[1]),
        );
}


class Expense {
  int? id;
  int customerId;
  double amount;
  DateTime expenseDate;
  TimeOfDay expenseTime;

  Expense({
    this.id,
    required this.customerId,
    required this.amount,
    required this.expenseDate,
    required this.expenseTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer_id': customerId,
      'amount': amount,
      'expense_date': expenseDate.toIso8601String(),
      'expense_time': '${expenseTime.hour}:${expenseTime.minute}',
    };
  }

  Expense.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        customerId = map['customer_id'],
        amount = map['amount'],
        expenseDate = DateTime.parse(map['expense_date']),
        expenseTime = TimeOfDay(
          hour: int.parse(map['expense_time'].split(':')[0]),
          minute: int.parse(map['expense_time'].split(':')[1]),
        );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'amount': amount,
      'expense_date': expenseDate.toIso8601String(),
      'expense_time': '${expenseTime.hour}:${expenseTime.minute}',
    };
  }

  Expense.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        customerId = json['customer_id'],
        amount = json['amount'],
        expenseDate = DateTime.parse(json['expense_date']),
        expenseTime = TimeOfDay(
          hour: int.parse(json['expense_time'].split(':')[0]),
          minute: int.parse(json['expense_time'].split(':')[1]),
        );
}
