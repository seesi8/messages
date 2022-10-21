import 'package:flutter/material.dart';
import 'package:messages/services/auth.dart';
import 'package:messages/services/firestore.dart';
import 'package:messages/services/models.dart';
import 'package:messages/shared/friendSuggestion.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});
  @override
  Widget build(BuildContext context) {
    var report = Provider.of<UserData>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Column(
        children: [
          Center(
            child: SizedBox(
              width: 200,
              height: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.white70),
                  child: Image.network(
                    report.profileIMG,
                    width: 300,
                  ),
                ),
              ),
            ),
          ),
          Text(
            report.friends.isNotEmpty ? "Friends" : "",
            style: const TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          StreamBuilder<Future<List<UserData>>>(
            stream: FirestoreService().streamInterations(userData: report),
            builder: (context, snapshot) {
              return FutureBuilder<List<UserData>>(
                  future: snapshot.data,
                  builder: (context, snapshot) {
                    List<UserData> data = snapshot.data ?? [];
                    return Column(
                      children: data
                          .map((e) => FriendsSuggestionButton(user: e))
                          .toList(),
                    );
                  });
            },
          ),
          ElevatedButton(
            onPressed: () {
              AuthService().signOut();
              Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
            },
            child: Text("Sign Out"),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red)),
          )
        ],
      ),
    );
  }
}
