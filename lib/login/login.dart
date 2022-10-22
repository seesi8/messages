import 'package:flutter/material.dart';
import 'package:messages/services/auth.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailTextController = TextEditingController();
    TextEditingController passwordTextController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Column(
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
            ElevatedButton(
              onPressed: () async {
                try {
                  await AuthService().signInWithPassword(
                      emailAddress: emailTextController.text,
                      password: passwordTextController.text);
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/', (route) => false);
                } catch (identifier) {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Error"),
                      content:
                          const Text("You have entered some information wrong"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: const Text("okay"),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: const Text('Sign In'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/create');
              },
              child: const Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}
