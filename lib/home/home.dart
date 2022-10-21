import 'package:flutter/material.dart';
import 'package:messages/login/login.dart';
import 'package:messages/services/auth.dart';
import 'package:messages/threads/threadsScreen.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('loading');
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('error'),
          );
        } else if (snapshot.hasData) {
          return const ThreadsScreen();
        } else {
          return const Login();
        }
      },
    );
  }
}
