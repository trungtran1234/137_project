import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              alignment: Alignment.center,
              child: Text(
                'Venue',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Create An Account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  SignUpForm(),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              color: Colors.white,
              alignment: Alignment.center,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  'Need an account? ',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Handle navigation to sign-up page here
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ]),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Handle sign-up logic here
              },
              child: Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _reEnterPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        SizedBox(height: 20.0),
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            labelText: 'Username',
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        SizedBox(height: 20.0),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: 'Password',
            filled: true,
            fillColor: Colors.white,
          ),
          obscureText: true,
        ),
        SizedBox(height: 20.0),
        TextField(
          controller: _reEnterPasswordController,
          decoration: InputDecoration(
            labelText: 'Re-enter Password',
            filled: true,
            fillColor: Colors.white,
          ),
          obscureText: true,
        ),
      ],
    );
  }
}