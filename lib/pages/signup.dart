import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app/pages/login.dart';
import 'package:app/global.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _reEnterPasswordController =
      TextEditingController();

  SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF133068), Color(0xFF0B1425)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildLogo(),
                  buildVenueTitle(),
                  _buildSignUpForm(context),
                  const SizedBox(height: 20.0),
                  _buildLoginOption(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpForm(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF020C1B),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
              color: Colors.black26,
              spreadRadius: 1,
              blurRadius: 15,
              offset: Offset(0, 5)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            const Text('Create An Account',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 30.0)),
            const SizedBox(height: 20),
            buildTextField(_firstNameController, 'First Name'),
            const SizedBox(height: 20),
            buildTextField(_lastNameController, 'Last Name'),
            const SizedBox(height: 20),
            buildTextField(_usernameController, 'Username'),
            const SizedBox(height: 20),
            buildTextField(_emailController, 'Email'),
            const SizedBox(height: 20),
            buildTextField(_passwordController, 'Password', obscureText: true),
            const SizedBox(height: 20),
            buildTextField(_reEnterPasswordController, 'Re-Enter Password',
                obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _handleSignUp(context),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 7, 24, 60),
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  minimumSize: const Size(double.infinity, 55)),
              child: const Text('Create Account',
                  style: TextStyle(fontSize: 15, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSignUp(BuildContext context) async {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _usernameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _reEnterPasswordController.text.isEmpty) {
      showTopSnackBar(context, 'Please fill in all fields');
      return;
    }
    if (_passwordController.text != _reEnterPasswordController.text) {
      showTopSnackBar(context, 'Passwords do not match');
      return;
    }
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: _usernameController.text)
        .limit(1)
        .get();

    if (result.docs.isNotEmpty) {
      showTopSnackBar(context, 'Username is already taken');
      return;
    }
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      User? user = userCredential.user;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': _emailController.text,
          'username': _usernameController.text,
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'friends': [],
          'bio': 'No bio.',
          'profilePicturePath':
              'https://cdn.discordapp.com/attachments/1204502528222302298/1240418949049483364/image.png?ex=66467dab&is=66452c2b&hm=75c4128119235994b56fdfa2bc72d12db77e706210ff0a383c78ac3a7e0b5e89&',
        });

        await user.sendEmailVerification();
        await FirebaseAuth.instance.signOut();
        showVerificationDialog(context, user);
      }
    } catch (e) {
      showTopSnackBar(
          context, 'The email is already in use by another account.');
    }
  }

  Widget _buildLoginOption(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF020C1B),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Have an account? ',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16.0,
            ),
          ),
          GestureDetector(
            onTap: () {
              newRoute(context, LoginPage());
            },
            child: const Text(
              'Login',
              style: TextStyle(
                color: Color(0xFF007AFF),
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showVerificationDialog(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Verify Your Email'),
        content: Text(
            'A verification email has been sent to ${user.email}. Please verify your account before logging in.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => LoginPage()));
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
