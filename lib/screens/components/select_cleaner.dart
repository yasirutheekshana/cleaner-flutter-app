import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../customer_screen.dart';

class SelectCleaner extends StatefulWidget {
  final String address;
  final DateTime dateTime;
  final double amount;

  const SelectCleaner({
    super.key,
    required this.address,
    required this.dateTime,
    required this.amount,
  });

  @override
  _SelectCleanerState createState() => _SelectCleanerState();
}

class _SelectCleanerState extends State<SelectCleaner> {
  String? _selectedCleaner;
  List<Map<String, dynamic>> _cleaners = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    fetchCleaners(); // Fetch cleaners from Firestore when the screen loads
  }

  Future<void> fetchCleaners() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'Freelancer') // Get only freelancers
          .get();

      List<Map<String, dynamic>> fetchedCleaners = querySnapshot.docs.map((doc) {
        return {
          "id": doc.id, // Store Firestore document ID
          "name": doc['name'] ?? 'Unknown',
          // Add other fields if available (e.g., rating, description, imageUrl)
          // Example: "rating": doc['rating'] ?? 0.0,
        };
      }).toList();

      setState(() {
        _cleaners = fetchedCleaners;
      });
    } catch (e) {
      print("Error fetching cleaners: $e");
    }
  }

  Future<void> saveOrder() async {
    try {
      if (_selectedCleaner != null) {
        // Get the current user's ID
        User? user = _auth.currentUser;
        if (user == null) {
          throw Exception("User not logged in");
        }
        final userId = user.uid;

        // Find the selected cleaner's ID
        final selectedCleanerDoc = _cleaners.firstWhere(
          (cleaner) => cleaner['name'] == _selectedCleaner,
        );
        final cleanerId = selectedCleanerDoc['id'];

        // Save to Firestore 'new_orders' collection with userId as document ID
        await FirebaseFirestore.instance.collection('new_orders').add({
          'orderedUserId': userId, // Add userId as a field
          'address': widget.address,
          'dateTime': widget.dateTime.toIso8601String(), // Store as ISO string
          'amount': widget.amount,
          'cleanerId': cleanerId,
          'status': 'pending', // Add order status
          'createdAt': FieldValue.serverTimestamp(), // Add timestamp
        });

        // Show confirmation modal
        showDialog(
          context: context,
          barrierDismissible: false, // Prevent closing by tapping outside
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 80,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Order confirmed",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "We have received your order and you can check your order.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CustomerScreen()),
                      ); // Navigate to NewOrder screen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Home"),
                  ),
                ],
              ),
            );
          },
        );
      }
    } catch (e) {
      print("Error saving order: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error saving order. Try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Select cleaner"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _cleaners.isEmpty
                  ? const Center(child: CircularProgressIndicator()) // Show loader while fetching
                  : ListView.builder(
                      itemCount: _cleaners.length,
                      itemBuilder: (context, index) {
                        final cleaner = _cleaners[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Card(
                            color: _selectedCleaner == cleaner['name']
                                ? Colors.purple[100]
                                : Colors.grey[100],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              title: Text(cleaner['name']),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                // Add rating or other details if available
                                // Example: Icon(Icons.star, color: Colors.yellow, size: 16),
                                // Text(cleaner['rating'].toString()),
                              ),
                              onTap: () {
                                setState(() {
                                  _selectedCleaner = cleaner['name'];
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _selectedCleaner != null
                    ? () {
                        saveOrder(); // Save the order to Firestore and show modal
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Add"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
