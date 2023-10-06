import 'package:flutter/material.dart';
import 'package:expense_tracker_app/models/expense.dart';

//Widget for adding new expense

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpense();
  }
}

class _NewExpense extends State<NewExpense> {
  final _titleController = TextEditingController(); //title for new expense
  final _priceController = TextEditingController(); //price for new expense
  DateTime? _selectedDate; //date for new expense
  Category _selectedCategory = Category.leisure; //category for new expense

  void _presentDatePicker() async {
    //date picker
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData() {
    //submitting new expense
    final enteredAmount = double.tryParse(_priceController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;

    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      //check if title, date or amount are invalid or empty
      showDialog(
          //if invalid or empty show error message
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text("Invalid input"),
                content: const Text(
                    "Please make sure a valid title, amount and date was entered."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: const Text("Okay"),
                  )
                ],
              ));
      return;
    }

    widget.onAddExpense(Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory));
    Navigator.pop(
        context); //if inputs are valid make new expense and close the window
  }

  @override
  void dispose() {
    //empties the title and price controller
    _titleController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //building the new expense widget
    final keyBoardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;

      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, keyBoardSpace + 16),
            child: Column(children: [
              if (width >=
                  600) //if width is more than or equal 600 we get a row else it's a column this is to change depending on phone being horizontal or vertical
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextField(
                        //title controller, text input for the title, has max length 50
                        controller: _titleController,
                        maxLength: 50,
                        decoration: const InputDecoration(label: Text("Title")),
                      ),
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                    Expanded(
                      child: TextField(
                        //price controller, text input for price, NOK is added at the end of the input
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            suffix: Text("NOK"), label: Text("Amount")),
                      ),
                    ),
                  ],
                )
              else
                TextField(
                  controller: _titleController,
                  maxLength: 50,
                  decoration: const InputDecoration(label: Text("Title")),
                ),
              if (width >=
                  600) //if width is more than or equal 600 we get one row else we get a different row
                Row(children: [
                  DropdownButton(
                      //category selector, lets you pick from a list of categories, they are changed to uppercase in the list
                      value: _selectedCategory,
                      items: Category.values
                          .map(
                            (category) => DropdownMenuItem(
                              value: category,
                              child: Text(
                                category.name.toUpperCase(),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() {
                          _selectedCategory = value;
                        });
                      }),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //date selector
                        Text(_selectedDate == null
                            ? "No date selected"
                            : formatter.format(_selectedDate!)),
                        IconButton(
                            onPressed: _presentDatePicker,
                            icon: const Icon(Icons.calendar_month_outlined)),
                      ],
                    ),
                  )
                ])
              else
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            suffix: Text("NOK"), label: Text("Amount")),
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
                        Text(_selectedDate == null
                            ? "No date selected"
                            : formatter.format(_selectedDate!)),
                        IconButton(
                            onPressed: _presentDatePicker,
                            icon: const Icon(Icons.calendar_month_outlined)),
                      ],
                    ))
                  ],
                ),
              const SizedBox(
                height: 16,
              ),
              if (width >= 600)
                Row(
                  children: [
                    const Spacer(),
                    ElevatedButton(
                        onPressed: () {
                          _submitExpenseData();
                        },
                        child: const Text("Save Expense")),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel")),
                  ],
                )
              else
                Row(
                  children: [
                    DropdownButton(
                        value: _selectedCategory,
                        items: Category.values
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(
                                  category.name.toUpperCase(),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            _selectedCategory = value;
                          });
                        }),
                    const Spacer(),
                    ElevatedButton(
                        onPressed: () {
                          _submitExpenseData();
                        },
                        child: const Text("Save Expense")),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel")),
                  ],
                )
            ]),
          ),
        ),
      );
    });
  }
}
