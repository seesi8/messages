import "package:flutter/material.dart";
import 'package:messages/services/firestore.dart';
import 'package:messages/services/models.dart';
import 'package:provider/provider.dart';

class FriendsSuggestionButton extends StatelessWidget {
  final UserData user;
  const FriendsSuggestionButton({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var report = Provider.of<UserData>(context);
    return StreamBuilder<String>(
        stream: FirestoreService()
            .requestsStream(id: user.id, friends: report.friends),
        builder: (context, snapshot) {
          return ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(snapshot.data == "incoming"
                        ? Colors.pink[200]
                        : snapshot.data == "disabled"
                            ? Colors.amber
                            : snapshot.data == "outgoing"
                                ? Colors.lightBlue[200]
                                : Colors.grey[700])),
            onPressed: () {
              if (snapshot.requireData == "disabled") {
                FirestoreService().removeFriend(
                  userId: report.id,
                  friendId: user.id,
                );
              } else if (snapshot.requireData == "enabled") {
                FirestoreService().requestFriend(
                  userId: report.id,
                  friendId: user.id,
                  friends: report.friends,
                );
              } else if (snapshot.requireData == "outgoing") {
                FirestoreService().removeRequest(
                  userId: report.id,
                  friendId: user.id,
                );
              } else if (snapshot.requireData == "incoming") {
                FirestoreService().acceptFriend(
                  userId: report.id,
                  friendId: user.id,
                );
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Image.network(
                        user.profileIMG,
                        height: 30,
                      ),
                    ),
                    Text(user.username),
                  ],
                ),
                Text(snapshot.data == "disabled"
                    ? "Remove"
                    : snapshot.data == "enabled"
                        ? "Add"
                        : snapshot.data == "incoming"
                            ? "Accept"
                            : "Stop Friend Requst")
              ],
            ),
          );
        });
  }
}
