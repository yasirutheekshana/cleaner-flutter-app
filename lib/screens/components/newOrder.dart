import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'select_date_time.dart';

class NewOrder extends StatefulWidget {
  @override
  _NewOrderState createState() => _NewOrderState();
}

class _NewOrderState extends State<NewOrder> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? selectedAddress;
  String? userAddress;

  @override
  void initState() {
    super.initState();
    fetchUserAddress();
  }

  Future<void> fetchUserAddress() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          userAddress = userDoc['address']; // Fetch address from Firestore
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Address')),
      body: userAddress == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: selectedAddress == userAddress
                            ? Colors.purple
                            : Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    child: ListTile(
                      title: Text(userAddress!),
                      trailing: selectedAddress == userAddress
                          ? Icon(Icons.check_circle, color: Colors.purple)
                          : null,
                      onTap: () {
                        setState(() {
                          selectedAddress = userAddress;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: selectedAddress != null
                        ? () async {
                            // Navigate to SelectDateTime and pass selectedAddress
                            final selectedDateTime = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SelectDateTime(
                                  address: selectedAddress!,
                                ),
                              ),
                            );

                            if (selectedDateTime != null) {
                              print("Selected DateTime: $selectedDateTime");
                              // Handle selected date and time
                            }
                          }
                        : null, // Disable if no address is selected
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Continue"),
                  ),
                ],
              ),
            ),
    );
  }
}
