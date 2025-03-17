import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_auth_service.dart';
import 'components/orders.dart';
import 'components/cleaners.dart';
import 'components/profile.dart';
import 'components/newOrder.dart';
import 'package:intl/intl.dart';

class FreelancerScreen extends StatefulWidget {
  @override
  _FreelancerScreenState createState() => _FreelancerScreenState();
}

class _FreelancerScreenState extends State<FreelancerScreen> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    OrdersScreen(),
    CleanersScreen(),
    ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Orders"),
          BottomNavigationBarItem(
            icon: Icon(Icons.feedback),
            label: "Feedback",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _userName;
  List<Map<String, dynamic>> _upcomingOrders = [];
  List<Map<String, dynamic>> _completeOrders = [];
  List<Map<String, dynamic>> _acceptedOrders = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Fetch user name and orders when the screen loads
  }

  Future<void> _fetchUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        final userId = user.uid;

        // Fetch user name from 'users' collection
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(userId).get();
        if (userDoc.exists) {
          setState(() {
            _userName = userDoc['name'] ?? 'User';
          });
        }

        // Fetch orders from 'new_orders' collection
        QuerySnapshot orderSnapshot = await _firestore
            .collection('new_orders')
            .where('cleanerId', isEqualTo: userId)
            .get();

        List<Map<String, dynamic>> upcoming = [];
        List<Map<String, dynamic>> complete = [];
        List<Map<String, dynamic>> accepted = [];

        for (var doc in orderSnapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;
          final dateTime = DateTime.parse(data['dateTime']);
          final orderStatus = data['status'] ?? 'pending';

          final orderData = {
            "id": doc.id,
            "date": DateFormat('MM/dd/yyyy').format(dateTime),
            "time": DateFormat('hh:mm a').format(dateTime),
            "status": orderStatus,
          };

          if (orderStatus == 'pending') {
            upcoming.add(orderData);
          } else if (orderStatus == 'completed') {
            complete.add(orderData);
          } else if (orderStatus == 'accepted') {
            accepted.add(orderData);
          }
        }

        setState(() {
          _upcomingOrders = upcoming;
          _completeOrders = complete;
          _acceptedOrders = accepted;
        });
      }
    } catch (e) {
      print("Error fetching user data or orders: $e");
    }
  }

  Future<void> _updateOrderStatus(String orderId, String status) async {
    try {
      await _firestore.collection('new_orders').doc(orderId).update({
        'status': status,
      });

      // Refresh orders after updating the status
      _fetchUserData();
    } catch (e) {
      print("Error updating order status: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error updating order status. Try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "Hello, ${_userName ?? 'User'}", // Display dynamic username or fallback
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "New Orders",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 100,
                child: _upcomingOrders.isEmpty
                    ? const Center(
                        child: Text(
                          "Empty",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _upcomingOrders.length,
                        itemBuilder: (context, index) {
                          final order = _upcomingOrders[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Container(
                              width: 180, // Increased width to fit the buttons
                              decoration: BoxDecoration(
                                color: Colors.purple[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      order["date"]!,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      order["time"]!,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                          ),
                                          onPressed: () {
                                            _updateOrderStatus(
                                              order["id"],
                                              "accepted",
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.cancel,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            _updateOrderStatus(
                                              order["id"],
                                              "declined",
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 16),

              // Accepted Orders Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Accept orders",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 100,
                child: _acceptedOrders.isEmpty
                    ? const Center(
                        child: Text(
                          "Empty",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _acceptedOrders.length,
                        itemBuilder: (context, index) {
                          final order = _acceptedOrders[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Container(
                              width: 180, // Increased width to fit the button
                              decoration: BoxDecoration(
                                color: Colors.purple[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      order["date"]!,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      order["time"]!,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    const SizedBox(height: 5),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.done_all,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () {
                                        _updateOrderStatus(
                                          order["id"],
                                          "completed",
                                        );
                                      },
                                      tooltip: "Mark as Completed",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 16),

              // Complete Orders Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Complete orders",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 100,
                child: _completeOrders.isEmpty
                    ? const Center(
                        child: Text(
                          "Empty",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _completeOrders.length,
                        itemBuilder: (context, index) {
                          final order = _completeOrders[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Container(
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.purple[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      order["date"]!,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      order["time"]!,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
