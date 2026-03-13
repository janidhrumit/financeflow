import 'package:flutter/material.dart';

void main() {
  runApp(const FinanceFlowApp());
}

class FinanceFlowApp extends StatelessWidget {
  const FinanceFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Finance Flow",
      theme: ThemeData(primarySwatch: Colors.green),
      home: const HomeScreen(),
    );
  }
}

class Expense {
  final String title;
  final double amount;
  final String category;
  final DateTime date;

  Expense({
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Expense> expenses = [];

  double get totalExpense =>
      expenses.fold(0, (sum, item) => sum + item.amount);

  void addExpense(String title, double amount, String category) {
    setState(() {
      expenses.add(
        Expense(
          title: title,
          amount: amount,
          category: category,
          date: DateTime.now(),
        ),
      );
    });
  }

  void deleteExpense(int index) {
    setState(() {
      expenses.removeAt(index);
    });
  }

  void openAddDialog() {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    String selectedCategory = "Food";

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Expense"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Amount"),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              items: ["Food", "Travel", "Shopping", "Bills", "Other"]
                  .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ))
                  .toList(),
              onChanged: (val) {
                selectedCategory = val!;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty &&
                  amountController.text.isNotEmpty) {
                addExpense(
                  titleController.text,
                  double.parse(amountController.text),
                  selectedCategory,
                );
                Navigator.pop(context);
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Finance Flow"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openAddDialog,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Total Card
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text(
                  "Total Expenses",
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Text(
                  "₹ ${totalExpense.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Expense List
          Expanded(
            child: expenses.isEmpty
                ? const Center(child: Text("No expenses added yet"))
                : ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final expense = expenses[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(expense.category[0]),
                    ),
                    title: Text(expense.title),
                    subtitle: Text(
                      "${expense.category} • ${expense.date.day}/${expense.date.month}/${expense.date.year}",
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "₹${expense.amount}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete,
                              color: Colors.red),
                          onPressed: () => deleteExpense(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
