import 'package:flutter/material.dart';
// ignore: unused_import
import 'register.dart';
import 'login.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Login(),
      debugShowCheckedModeBanner:
          false, // Add this line to hide the debug banner
    ),
  );
}
