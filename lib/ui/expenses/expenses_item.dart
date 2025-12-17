import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:w9_challenge/model/expense_model.dart';

class ExpensesItem extends StatelessWidget {
  final int index;
  final Expense expense;
  const ExpensesItem({super.key, required this.expense, required this.index});
  IconData get expenseIcon {
    switch (expense.category) {
      case Category.food:
        return Icons.free_breakfast;
      case Category.travel:
        return Icons.travel_explore;
      case Category.leisure:
        return Icons.holiday_village;
      case Category.work:
        return Icons.work;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text("\$${expense.amount}"),
                ],
              ),
              Spacer(),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(expenseIcon),
                  ),
                  Text(DateFormat('dd/MM/yyyy').format(expense.date)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
