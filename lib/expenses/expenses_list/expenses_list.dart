import 'package:expense_tracker/expenses/expenses_list/expense_list_item.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({super.key, required this.expenseList, required this.onRemoveExpense});
  final void Function(Expense expense) onRemoveExpense;

  final List<Expense> expenseList;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
        itemCount: expenseList.length,
        itemBuilder: (ctx, index) => Dismissible(
            key: ValueKey(expenseList[index]),
            background: Container(color: Theme.of(context).colorScheme.error.withOpacity(0.75),
            margin: EdgeInsets.symmetric(
              horizontal: Theme.of(context).cardTheme.margin!.horizontal
            ),),
            child: ExpenseListIem(expense: expenseList[index]),
            onDismissed: (DismissDirection dismissDirection){
                onRemoveExpense(expenseList[index]);

            },));
  }
}
