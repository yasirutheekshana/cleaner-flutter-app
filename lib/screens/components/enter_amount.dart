import 'package:flutter/material.dart';

class EnterAmount extends StatefulWidget {
  final String address;
  final DateTime dateTime;

  const EnterAmount({super.key, required this.address, required this.dateTime});

  @override
  _EnterAmountState createState() => _EnterAmountState();
}

class _EnterAmountState extends State<EnterAmount> {
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Enter Amount"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount Input
            const Text(
              "Enter Amount (USD)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: "Enter amount",
                prefixText: "\$",
              ),
            ),
            const SizedBox(height: 32),

            // Continue Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_amountController.text.isNotEmpty) {
                    final amount = double.tryParse(_amountController.text);
                    if (amount != null && amount > 0) {
                      // Navigate to the next screen or save the order
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderConfirmation(
                            address: widget.address,
                            dateTime: widget.dateTime,
                            amount: amount,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please enter a valid amount")),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Continue"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder for OrderConfirmation screen
class OrderConfirmation extends StatelessWidget {
  final String address;
  final DateTime dateTime;
  final double amount;

  const OrderConfirmation({
    super.key,
    required this.address,
    required this.dateTime,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Confirmation"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Address: $address"),
            Text("Date & Time: ${dateTime.toLocal().toString().split('.')[0]}"),
            Text("Amount: \$${amount.toStringAsFixed(2)}"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save order to Firestore and navigate back
                Navigator.popUntil(context, ModalRoute.withName('/home'));
              },
              child: const Text("Confirm Order"),
            ),
          ],
        ),
      ),
    );
  }
}
