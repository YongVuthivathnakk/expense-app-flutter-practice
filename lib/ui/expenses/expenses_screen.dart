import 'package:flutter/material.dart';
import 'package:w9_challenge/model/expense_model.dart';
import 'package:w9_challenge/ui/expenses/expense_form.dart';
import 'package:w9_challenge/ui/expenses/expenses_item.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final List<Expense> _expenses = [];
  double workPrice = 0;
  double foodPrice = 0;
  double travelPrice = 0;
  double lesiurePrice = 0;

  void _recalculateTotal() {
    double food = 0;
    double work = 0;
    double travel = 0;
    double lesiure = 0;

    for (var expense in _expenses) {
      switch (expense.category) {
        case Category.food:
          food += expense.amount;
          break;
        case Category.travel:
          travel += expense.amount;
          break;
        case Category.work:
          work += expense.amount;
          break;
        case Category.leisure:
          lesiure += expense.amount;
          break;
      }
    }

    setState(() {
      workPrice = work;
      foodPrice = food;
      travelPrice = travel;
      lesiurePrice = lesiure;
    });
  }

  void onAddClicked(BuildContext context) async {
    Expense? newExpense = await showModalBottomSheet<Expense>(
      isScrollControlled: false,
      context: context,
      builder: (c) => Center(child: ExpenseForm()),
    );
    if (newExpense != null) {
      setState(() {
        _expenses.add(newExpense);
      });
    }
    _recalculateTotal();
  }

  void onDelete(int index) {
    setState(() {
      _expenses.removeAt(index);
    });
    _recalculateTotal();
  }

  bool _isItemEmpty() {
    if (_expenses.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "RONAN THE BEST!",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () {
              onAddClicked(context);
            },
            icon: Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ExpenseCostItem(cost: workPrice, icon: Icons.work),
                    ExpenseCostItem(
                      cost: foodPrice,
                      icon: Icons.free_breakfast,
                    ),
                    ExpenseCostItem(
                      cost: travelPrice,
                      icon: Icons.travel_explore,
                    ),
                    ExpenseCostItem(
                      cost: lesiurePrice,
                      icon: Icons.holiday_village,
                    ),
                  ],
                ),
              ),
            ),
          ),
          _isItemEmpty()
              ? EmptyExpense()
              : ListView.builder(
                  itemCount: _expenses.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final removeIndex = _expenses[index];
                    return Dismissible(
                      key: Key(_expenses[index].id),
                      child: ExpensesItem(
                        expense: _expenses[index],
                        index: index,
                      ),
                      onDismissed: (direction) {
                        setState(() {
                          _expenses.removeAt(index);
                        });
                        _recalculateTotal();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Expense Deleted"),
                            duration: Duration(seconds: 5),
                            action: SnackBarAction(
                              label: "UNDO",
                              onPressed: () {
                                setState(() {
                                  _expenses.insert(index, removeIndex);
                                });
                                _recalculateTotal();
                              },
                            ),
                          ),
                        );
                      },
                      // Scaffold.of(context).
                    );
                  },
                ),
        ],
      ),
    );
  }
}

class ExpenseCostItem extends StatelessWidget {
  final double cost;
  final IconData icon;
  const ExpenseCostItem({super.key, required this.cost, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      children: [
        Text("$cost\$", style: TextStyle(fontSize: 16)),
        Icon(icon),
      ],
    );
  }
}

class EmptyExpense extends StatelessWidget {
  const EmptyExpense({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 40),
      child: Text(
        "No expenses found. Start adding now!",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
