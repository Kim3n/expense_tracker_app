import 'package:expense_tracker_app/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker_app/models/expense.dart';
import 'package:expense_tracker_app/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker_app/widgets/chart/chart.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  //dummy expenses
  final List<Expense> _registeredExpenses = [
    Expense(
        title: "Flutter course",
        amount: 179.50,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: "Starfield Collectors Edition",
        amount: 3000.00,
        date: DateTime.now(),
        category: Category.leisure),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => NewExpense(onAddExpense: _addExpense));
  }

  void _addExpense(Expense expense) {
    //adds expense to the expense list
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    //the logic for removing an expense when swiped, also lets you undo within 5 seconds on removing the expense
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 5),
          content: const Text("Expense deleted"),
          action: SnackBarAction(
            label: "Undo",
            onPressed: () {
              setState(() {
                _registeredExpenses.insert(expenseIndex, expense);
              });
            },
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    Widget mainContent = const Center(
      //if empty tells you to add expenses
      child: Text("No Expenses found. Start adding some!"),
    );

    if (_registeredExpenses.isNotEmpty) {
      //if not empty shows the expenses
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Expense Tracker"),
        actions: [
          IconButton(
              onPressed: _openAddExpenseOverlay, icon: const Icon(Icons.add))
        ],
      ),
      body: width < 600 //if width less than 600 return column else return row
          ? Column(children: [
              Chart(expenses: _registeredExpenses),
              Text(
                  'Total Amount:  \$${Chart(expenses: _registeredExpenses).totalExpensesAll.toStringAsFixed(2)}'),
              Expanded(child: mainContent)
            ])
          : Row(
              children: [
                Expanded(child: Chart(expenses: _registeredExpenses)),
                Text(
                    'Total Amount:  \$${Chart(expenses: _registeredExpenses).totalExpensesAll.toStringAsFixed(2)}'),
                Expanded(child: mainContent)
              ],
            ),
    );
  }
}
