import 'dart:io';

import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  final void Function(Expense expense) onAddExpense;


  const NewExpense({super.key, required this.onAddExpense});


  @override
  State<NewExpense> createState() {
    return NewExpenseState();
  }
}

class NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _pickedDate = null;
  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);
    setState(() {
      _pickedDate = pickedDate;
    });
  }

  void _showDialog(){
    if(Platform.isIOS){
      showCupertinoDialog(context: context, builder: (ctx) =>
          CupertinoAlertDialog(
            title: const Text('Invalid Input'),
            content: const Text(
                'Please make sure a valid title, amount, date and category was entered'),
            actions: [ TextButton(onPressed: () {
              Navigator.pop(ctx);
            }, child: const Text('Okay'),
            )
            ],
          ));
    }
    else{
      showDialog(context: context, builder: (ctx) =>
          AlertDialog(
            title: const Text('Invalid Input'),
            content: const Text(
                'Please make sure a valid title, amount, date and category was entered'),
            actions: [ TextButton(onPressed: () {
              Navigator.pop(ctx);
            }, child: const Text('Okay'),
            )
            ],
          ));
    }
  }

  void _submitExpense() {
    final enteredAmount = double.tryParse(_amountController.text);
    final isAmountInValid = enteredAmount == null || enteredAmount < 0;
    if (_titleController.text
        .trim()
        .isEmpty || isAmountInValid || _pickedDate == null) {
      // show error
      _showDialog();
      return;
    }
    widget.onAddExpense(Expense(title: _titleController.text, amount: enteredAmount, date: _pickedDate!, category: _selectedCategory));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.fromLTRB(16,48,16,keyboardSpace + 16),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                maxLength: 50,
                decoration: const InputDecoration(label: Text('Title')),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        label: Text('Amount'),
                        prefixText: '\$ ',
                      ),
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      controller: _amountController,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(_pickedDate == null
                            ? "No date selected"
                            : dateFormatter.format(_pickedDate!)),
                        IconButton(
                            onPressed: _presentDatePicker,
                            icon: const Icon(Icons.calendar_today))
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16,),
              Row(
                children: [
                  DropdownButton(
                      value: _selectedCategory,
                      items: Category.values
                          .map((category) =>
                          DropdownMenuItem(
                            value: category,
                            child: Text(category.name.toUpperCase()),
                          ))
                          .toList(),
                      onChanged: (item) {
                        if (item != null) {
                          setState(() {
                            _selectedCategory = item;
                          });
                        }
                        print(item);
                      }),
                  const Spacer(),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel')),
                  const Spacer(),
                  ElevatedButton(
                      onPressed: () {
                        _submitExpense();
                      },
                      child: const Text('Save')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
