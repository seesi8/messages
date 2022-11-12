import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:messages/services/auth.dart';

class Create extends StatefulWidget {
  const Create({super.key});

  @override
  State<Create> createState() => _CreateState();
}

class _CreateState extends State<Create> {
  @override
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController displayNameTextController = TextEditingController();
  TextStyle defaultStyle = TextStyle(color: Colors.grey, fontSize: 8.0);
  TextStyle linkStyle = TextStyle(color: Colors.blue);
  XFile? image = null;
  File? imageFile;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: SingleChildScrollView(
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
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.grey[700])),
              onPressed: () async {
                final ImagePicker _picker = ImagePicker();
                // Pick an image
                image = await _picker.pickImage(source: ImageSource.gallery);
                setState(() {
                  imageFile = File(image!.path);
                });
              },
              child: SizedBox(
                width: 360,
                child: const Text('Pick Profile IMG'),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.greenAccent)),
              onPressed: () async {
                if (await AuthService().createAccountWithUsernameAndPassword(
                    context: context,
                    email: emailTextController.text,
                    password: passwordTextController.text,
                    displayName: displayNameTextController.text,
                    file: image)) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/', (route) => false);
                }
              },
              child: const Text('Sign Up'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('Already Have An Account?'),
            ),
            imageFile != null
                ? Image.file(
                    imageFile!,
                    width: 100,
                  )
                : Text("Select A Profile Image"),
            Center(
                child: RichText(
              text: TextSpan(
                style: defaultStyle,
                children: <TextSpan>[
                  TextSpan(text: 'By clicking Sign Up, you agree to our '),
                  TextSpan(
                      text: 'Terms of Service',
                      style: linkStyle,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, "/tos");
                        }),
                  TextSpan(text: ' and that you have read our '),
                  TextSpan(
                      text: 'Privacy Policy',
                      style: linkStyle,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, "/privacy");
                        }),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
