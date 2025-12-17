import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:w9_challenge/model/expense_model.dart';
import 'package:w9_challenge/model/input_type.dart';

List<String> categories = ["Work", "Food", "Leisure", "Travel"];

class ExpenseForm extends StatefulWidget {
  const ExpenseForm({super.key});

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  DateTime selectedDate = DateTime.now();
  final _textController = TextEditingController();
  final _priceController = TextEditingController();
  get getCategory {
    switch (dropdownValue) {
      case "Work":
        return Category.work;
      case "Food":
        return Category.food;
      case "Travel":
        return Category.travel;
      case "Leisure":
        return Category.leisure;
    }
  }

  String dropdownValue = categories.first;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _handleCancel() {
    Navigator.pop(context);
  }

  void onCreate() {
    if (_textController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) => WrongPriceDialog(),
      );
      return;
    }

    if (double.parse(_priceController.text) < 0) {
      showDialog(
        context: context,
        builder: (BuildContext context) => EmptyTextDialog(),
      );
      return;
    }

    Expense newExpense = Expense(
      title: _textController.text,
      amount: double.parse(_priceController.text),
      date: selectedDate,
      category: getCategory,
    );

    Navigator.pop<Expense>(context, newExpense);
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
    _priceController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            Text("Expense Form", style: TextStyle(fontSize: 24)),
            Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InputTextWidget(
                    label: "Title",
                    maxLength: 20,
                    inputController: _textController,
                  ),
                  Row(
                    spacing: 30,

                    children: [
                      Expanded(
                        flex: 2,
                        child: InputTextWidget(
                          label: "Amount",
                          maxLength: 20,
                          inputType: InputType.PRICE,
                          inputController: _priceController,
                        ),
                      ),

                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: () => _selectDate(context),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormat('dd/MM/yyyy').format(selectedDate),
                              ),
                              Icon(Icons.calendar_today),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownButton<String>(
                        value: dropdownValue,
                        elevation: 16,
                        items: categories.map<DropdownMenuItem<String>>((
                          String value,
                        ) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            dropdownValue = value!;
                          });
                        },
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: _handleCancel,
                            child: Text(
                              "Cancel",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: onCreate,
                            child: Text(
                              "Create",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyTextDialog extends StatelessWidget {
  const EmptyTextDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 350,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            Text("Invalid Input!", style: TextStyle(fontSize: 28)),
            Text(
              "The price must not be negative",
              style: TextStyle(fontSize: 16),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Okay"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WrongPriceDialog extends StatelessWidget {
  const WrongPriceDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 350,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            Text("Invalid Input!", style: TextStyle(fontSize: 28)),
            Text("The title must not be empty", style: TextStyle(fontSize: 16)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Okay"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class InputTextWidget extends StatelessWidget {
  final String label;
  final int maxLength;
  final InputType inputType;
  final TextEditingController inputController;

  const InputTextWidget({
    super.key,
    required this.label,
    required this.maxLength,
    this.inputType = InputType.TEXT,
    required this.inputController,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        label: Text(label),
        prefixText: inputType == InputType.PRICE ? "\$" : null,
      ),
      maxLength: maxLength,
      controller: inputController,
      keyboardType: inputType == InputType.PRICE
          ? TextInputType.number
          : TextInputType.text,
    );
  }
}
