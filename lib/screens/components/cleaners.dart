import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CleanersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Find Cleaners")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'Freelancer') // Filter freelancers
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No Cleaners Available"));
          }

          return ListView(
            padding: const EdgeInsets.all(10),
            children: snapshot.data!.docs.map((doc) {
              return FreelancerCard(doc);
            }).toList(),
          );
        },
      ),
    );
  }
}

class FreelancerCard extends StatelessWidget {
  final QueryDocumentSnapshot doc;

  const FreelancerCard(this.doc, {super.key});

  @override
  Widget build(BuildContext context) {
    String name = doc['name'] ?? "Unknown";
    String profilePic = "https://www.example.com/default-profile-pic.jpg"; // Use default profile pic if none

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(profilePic),
          child: profilePic == "https://www.example.com/default-profile-pic.jpg" 
              ? const Icon(Icons.person)  // Show icon if default pic is used
              : null,
        ),
        title: Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        
      ),
    );
  }
}


