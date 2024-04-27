import 'package:app/functions.dart';
import 'package:flutter/material.dart';
import 'package:app/settings/settings.dart';
import '../objects/userprofile.dart';
import '../services/connectivity_checker.dart';
import '../services/reconnection_popup.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  late PopupManager popupManager;
  late ConnectivityChecker connectivityChecker;

  @override
  void initState() {
    super.initState();
    popupManager = PopupManager();
    connectivityChecker = ConnectivityChecker(
      onStatusChanged: onConnectivityChanged,
    );
    // If needed, start listening for connectivity changes here
  }

  void onConnectivityChanged(bool isConnected) {
    if (isConnected) {
      popupManager.dismissConnectivityPopup();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        popupManager.showConnectivityPopup(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProfile user = UserProfile(username: "username", location: "location");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () {
              newRoute(context, SettingsPage());
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20.0), // Add space at the top
            const CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('lib/assets/Default_pfp.svg.png'),
            ),
            const SizedBox(height: 20.0),
            Text(
              '${user.username}',
              style: const TextStyle(
                fontSize: 24.0, // Increase font size for username
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10.0),
            Text(
              '${user.location}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 10.0),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Text(
                '${user.bio}',
                style: const TextStyle(fontSize: 16.0),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly, // Adjust alignment
              children: [
                _buildStatisticColumn(user.friends, 'Friends'),
                _buildStatisticColumn(user.eventsAttended, 'Events Attended'),
                _buildStatisticColumn(user.eventsHosted, 'Events Hosted'),
              ],
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    connectivityChecker.dispose();
    super.dispose();
  }

  Widget _buildStatisticColumn(int value, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$value',
          style: const TextStyle(
            fontSize: 18.0,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 5.0),
        Text(
          label,
          style: const TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }
}
