import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? userData;

  Future<void> fetchUserData() async {
    try {
      String? userEmail = FirebaseAuth.instance.currentUser?.email;
      if (userEmail == null) {
        return;
      }
      QuerySnapshot querySnapshot = await _firestore
          .collection('userRole')
          .where('email', isEqualTo: userEmail)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        });
      } else {
        print("No user found.");
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> items = [
      {
        "title": "Test Band",
        "description": "New Band up for Delivery? Test Now",
        "route": "/testScreen"
      },
      {
        "title": "Report Bug",
        "description": "Found any Bug? Report now.",
        "route": "/reportBugScreen"
      },
      {
        "title": "Request a Band",
        "description": "Need a Band? Ask Now.",
        "route": "/requestBandScreen"
      }
    ];

    return Scaffold(
      appBar: AppBar(title: Text("Welcome, ${userData?['name'] ?? ""}")),
      body: Center(
        child: userData == null
            ? CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
        )
            : CarouselSlider(
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height * 0.625, // 80% of screen height
            enlargeCenterPage: true,
            autoPlay: true,
            aspectRatio: 16 / 9,
            autoPlayInterval: Duration(seconds: 6),
            viewportFraction: 0.65, // Shows some part of left & right items
            enableInfiniteScroll: true, // Enables infinite scrolling
            pageSnapping: true, // Ensures proper snapping behavior
          ),
          items: items.map((item) {
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, item["route"]);
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 5,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          item["title"],
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          item["description"],
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
