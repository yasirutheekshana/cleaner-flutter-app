import 'package:flutter/material.dart';
import '../services/firebase_auth_service.dart';

class FreelancerScreen extends StatelessWidget {
  final FirebaseAuthService _authService = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              Navigator.pushReplacementNamed(context, "/login");
            },
          ),
        ],
      ),
      body: const Center(
        child: Text("Welcome to freelancer Home Screen!", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}