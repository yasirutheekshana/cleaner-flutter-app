import 'package:flutter/material.dart';
import '../services/firebase_auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'components/orders.dart';
import 'components/cleaners.dart';
import 'components/profile.dart';
import 'components/newOrder.dart';

class CustomerScreen extends StatefulWidget {
  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
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
            icon: Icon(Icons.cleaning_services),
            label: "Cleaners",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data for demonstration
    final String userName = "John";
    final List<Map<String, String>> upcomingOrders = [
      {"date": "August 21", "time": "3:00 PM"},
      {"date": "April 24", "time": "4:00 PM"},
    ];
    final List<Map<String, String>> completeOrders = [
      {"date": "August 21", "time": "3:00 PM"},
      {"date": "August 21", "time": "3:00 PM"},
    ];
    final List<Map<String, dynamic>> cleaners = [
      {
        "name": "Afrah Rufaydah",
        "rating": 5.0,
        "description": "It is a long establi...",
        "imageUrl": "https://via.placeholder.com/50",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "Hello, $userName",
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
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.purple[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Glad to see you again!\nWe work to keep your homes clean.",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(width: double.infinity),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to New Order screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NewOrder()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.purple,
                      ),
                      child: const Text("New Order"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Upcoming Orders Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Upcoming orders",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(onPressed: () {}, child: const Text("View all")),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: upcomingOrders.length,
                  itemBuilder: (context, index) {
                    final order = upcomingOrders[index];
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

              // Complete Orders Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Complete orders",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(onPressed: () {}, child: const Text("View all")),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: completeOrders.length,
                  itemBuilder: (context, index) {
                    final order = completeOrders[index];
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

              // Cleaners for You Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Cleaners for you",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(onPressed: () {}, child: const Text("View all")),
                ],
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: cleaners.length,
                itemBuilder: (context, index) {
                  final cleaner = cleaners[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(cleaner["imageUrl"]!),
                    ),
                    title: Text(cleaner["name"]!),
                    subtitle: Text(cleaner["description"]!),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.yellow, size: 16),
                        Text(
                          "${cleaner["rating"]}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
