// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Load JSON from Assets',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Load JSON from Assets'),
//         ),
//         body: JsonDataScreen(),
//       ),
//     );
//   }
// }

// class JsonDataScreen extends StatefulWidget {
//   @override
//   _JsonDataScreenState createState() => _JsonDataScreenState();
// }

// class _JsonDataScreenState extends State<JsonDataScreen> {
//   Future<Map<String, dynamic>> loadJsonFromAssets(String filePath) async {
//     String jsonString = await rootBundle.loadString(filePath);
//     return jsonDecode(jsonString);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<Map<String, dynamic>>(
//       future: loadJsonFromAssets('assets/data.json'),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Center(child: Text('Error loading JSON'));
//         } else if (snapshot.hasData) {
//           Map<String, dynamic>? jsonData = snapshot.data;
//           String name = jsonData?['name'] ?? 'Unknown';
//           int age = jsonData?['age'] ?? 0;
//           String email = jsonData?['email'] ?? 'No email';

//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text('Name: $name'),
//                 Text('Age: $age'),
//                 Text('Email: $email'),
//               ],
//             ),
//           );
//         } else {
//           return Center(child: Text('No data found'));
//         }
//       },
//     );
//   }
// }
