import 'package:flutter/material.dart';
import 'package:messages/services/auth.dart';

class Create extends StatelessWidget {
  const Create({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailTextController = TextEditingController();
    TextEditingController passwordTextController = TextEditingController();
    TextEditingController displayNameTextController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: emailTextController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
                hintText: 'Enter Email',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: passwordTextController,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
                hintText: 'Enter Password',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: displayNameTextController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Display Name',
                hintText: 'Enter Display Name',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await AuthService().signInWithPassword(
                  emailAddress: emailTextController.text,
                  password: passwordTextController.text);
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            child: const Text('Sign In'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            child: const Text('Already Have An Account?'),
          ),
        ],
      ),
    );
  }
}
