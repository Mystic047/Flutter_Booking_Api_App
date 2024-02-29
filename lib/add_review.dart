import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For using json.encode
import 'package:logger/logger.dart';

class Addreview extends StatefulWidget {
  const Addreview({Key? key}) : super(key: key);

  @override
  State<Addreview> createState() => _AddreviewState();
}

class _AddreviewState extends State<Addreview> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  String? _emailError;
  String? _passwordError;
  String? _firstnameError;
  String? _lastnameError;
  String? _phoneNumberError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  bool _validateEmail(String email) {
    if (email.isEmpty) {
      setState(() => _emailError = "Email cannot be empty");
      return false;
    } else if (!email.contains('@')) {
      setState(() => _emailError = "Enter a valid email address");
      return false;
    } else {
      setState(() => _emailError = null);
      return true;
    }
  }

  bool _validatePassword(String password) {
    if (password.isEmpty) {
      setState(() => _passwordError = "Password cannot be empty");
      return false;
    } else if (password.length < 6) {
      setState(() => _passwordError = "Password must be at least 6 characters");
      return false;
    } else {
      setState(() => _passwordError = null);
      return true;
    }
  }

  bool _validateFirstname(String firstname) {
    if (firstname.isEmpty) {
      setState(() => _firstnameError = "First name cannot be empty");
      return false;
    } else {
      setState(() => _firstnameError = null);
      return true;
    }
  }

  bool _validateLastname(String lastname) {
    if (lastname.isEmpty) {
      setState(() => _lastnameError = "Last name cannot be empty");
      return false;
    } else {
      setState(() => _lastnameError = null);
      return true;
    }
  }

  bool _validatePhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty) {
      setState(() => _phoneNumberError = "Phone number cannot be empty");
      return false;
      // Update the regular expression to ensure the phoneNumber contains only digits
    } else if (!RegExp(r'^\d+$').hasMatch(phoneNumber)) {
      setState(
          () => _phoneNumberError = "Phone number can only contain digits");
      return false;
    } else {
      setState(() => _phoneNumberError = null);
      return true;
    }
  }

  Future<void> submitUserData() async {
    var logger = Logger();
    var url = Uri.parse(
        'http://localhost:3000/api_add/save'); // Adjust the URL as needed
    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': _emailController.text,
          'password': _passwordController.text,
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'phoneNumber': _phoneNumberController.text,
        }),
      );

      if (response.statusCode == 200) {
        logger.d('User data submitted successfully'); // Debug log

        // Check for a specific success response if necessary, for now assuming statusCode 200 is success
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful')),
        );

        // Pop the context here after showing a success message
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      } else {
        logger.w('Failed to submit user data: ${response.body}');
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to register. Please try again.')),
        );
      }
    } catch (e) {
      logger.e('Error submitting user data: $e');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'User Add - Register';

    return MaterialApp(
      title: appTitle,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      errorText: _emailError,
                    ),
                    onChanged: (value) => _validateEmail(value),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      errorText: _passwordError,
                    ),
                    onChanged: (value) => _validatePassword(value),
                  ),
                  TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      errorText: _firstnameError,
                    ),
                    onChanged: (value) => _validateFirstname(value),
                  ),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      errorText: _lastnameError,
                    ),
                    onChanged: (value) => _validateLastname(value),
                  ),
                  TextFormField(
                    controller: _phoneNumberController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      errorText: _phoneNumberError,
                    ),
                    keyboardType: TextInputType.phone,
                    onChanged: (value) => _validatePhoneNumber(value),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          submitUserData();
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
