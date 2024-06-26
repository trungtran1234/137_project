import 'package:app/pages/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app/global.dart';

class ChangePasswordPage extends StatelessWidget {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: _currentPasswordController,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                hintText: 'Enter your current password',
                prefixIcon: Icon(Icons.lock_outline),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _newPasswordController,
              decoration: const InputDecoration(
                labelText: 'New Password',
                hintText: 'Enter a new password',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => changePassword(
                  context, _currentPasswordController, _newPasswordController),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: const Text('Update Password'),
            ),
          ],
        ),
      ),
    );
  }

  void changePassword(
      BuildContext context,
      TextEditingController currentPasswordController,
      TextEditingController newPasswordController) async {
    final currentPassword = currentPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();

    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: FirebaseAuth.instance.currentUser!.email!,
        password: currentPassword,
      );
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(credential);
      await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
      showTopSnackBar(context, "Password updated successfully!",
          backgroundColor: Colors.green);
    } on FirebaseAuthException catch (e) {
      showTopSnackBar(context, 'Incorrect password provided!',
          backgroundColor: Colors.red);
    }
  }
}

void confirmDeleteAccount(BuildContext context, User? user) {
  TextEditingController passwordController = TextEditingController();
  if (user != null) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Account"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                  "Are you sure you want to delete your account and all associated data? This action cannot be undone."),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                ),
                obscureText: true,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
              onPressed: () => _verifyPasswordAndDelete(
                  user, passwordController.text, context),
            ),
          ],
        );
      },
    );
  } else {
    showTopSnackBar(context, "No user logged in");
  }
}

void _verifyPasswordAndDelete(
    User user, String password, BuildContext context) async {
  if (password.isEmpty) {
    showTopSnackBar(context, "Please enter your password to confirm deletion.");
    return;
  }

  try {
    AuthCredential credential = EmailAuthProvider.credential(
      email: user.email!,
      password: password,
    );

    await user.reauthenticateWithCredential(credential);

    _deleteUserAndData(user, context);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'wrong-password') {
      showTopSnackBar(
          context, "The password you entered is incorrect. Please try again.");
    } else {
      showTopSnackBar(context, "Failed to verify your password: ${e.message}");
    }
  }
}

Future<void> _deleteUserAndData(User user, BuildContext context) async {
  try {
    await FirebaseFirestore.instance
        .collection('posts')
        .where('username', isEqualTo: user.displayName)
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });

    await FirebaseFirestore.instance
        .collection('events')
        .where('userEmail', isEqualTo: user.email)
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });

    await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();

    await user.delete();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => LoginPage()),
      (Route<dynamic> route) => false,
    );

    showTopSnackBar(context, "Account deleted successfully.",
        backgroundColor: Colors.green);
  } on FirebaseAuthException catch (e) {
    showTopSnackBar(context, "Failed to delete account: ${e.message}");
  } catch (e) {
    showTopSnackBar(context, "An unexpected error occurred: ${e.toString()}");
  }
}
