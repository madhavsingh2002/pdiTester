import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pditester/Pages/ReportBugScreen.dart';
import 'package:pditester/Pages/TestScreen.dart';
import 'Pages/Login.dart';
import 'Pages/Home.dart';
import 'Pages/NewReportBug.dart';
import 'Pages/NewRequestBand.dart';
import 'Pages/New_Test.dart';
import 'Pages/PreviousReportBug.dart';
import 'Pages/PreviousRequestDevice.dart';
import 'Pages/PreviousTests.dart';
import 'Pages/RequestBandScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthCheck(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        // TESTS
        '/testScreen': (context) => TestScreen(),
        '/newTest': (context) => NewTestScreen(),
        '/previousTest': (context) => Previoustests(),
        // REQUEST BAND
        '/requestBandScreen': (context) => RequestDeviceScreen(),
        '/newRequestBand': (context) => NewRequestDevice(),
        '/previousRequestBand': (context) => PreviousRequestDevice(),
        // Report BUG
        '/reportBugScreen': (context) => ReportBugScreen(),
        '/NewReportBug': (context) => NewReportBug(),
        '/PreviousReportBug': (context) => PreviousReportBug(),
      },
    );
  }
}
class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator())); // Show loading screen
        }
        if (snapshot.hasData) {
          return HomeScreen(); // User is logged in, go to Home
        }
        return LoginScreen(); // User not logged in, go to Login
      },
    );
  }
}
