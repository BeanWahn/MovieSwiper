import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_swiper/presentation/components/footer.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _logOut() async {
    await _auth.signOut();
    context.go('/login');
    // Add any additional logic you need after logging out
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SafeArea(child:ListView(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            title: Text(
              style: const TextStyle(fontSize: 13),
              'Signed in as ${_auth.currentUser?.email}'),
          ),
          ListTile(
            title: const Text('Account'),
            onTap: () {
              context.go('/account');
            },
          ),
          ListTile(
            title: const Text('Log Out'),
            onTap: _logOut,
          ),
        ],
      )),
      bottomNavigationBar: Footer(),
    );
  }
}