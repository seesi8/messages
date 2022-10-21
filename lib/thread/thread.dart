import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:messages/services/auth.dart';
import 'package:messages/services/models.dart';
import 'package:messages/services/firestore.dart';
import 'package:provider/provider.dart';

class ThreadScreen extends StatelessWidget {
  final Thread thread;
  const ThreadScreen({super.key, required this.thread});

  @override
  Widget build(BuildContext context) {
    var controller = ScrollController();
    var report = Provider.of<UserData>(context);
    bool needScroll = false;
    List<Message>? previousData;
    if (needScroll) {
      scrollDown(controller);
      needScroll = false;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(thread.groupName),
      ),
      body: StreamBuilder<List<Message>>(
          stream: FirestoreService().streamMessages(id: thread.id),
          builder: (context, snapshot) {
            List<Message> data = snapshot.data ?? previousData ?? [];
            if (snapshot.data != null) {
              previousData = snapshot.data;
            }
            TextEditingController messageController = TextEditingController();
            return SizedBox(
              width: 500,
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 330,
                          child: DecoratedBox(
                            decoration: const BoxDecoration(color: Colors.teal),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: TextField(
                                controller: messageController,
                                style: const TextStyle(),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          width: 81,
                          child: ElevatedButton(
                              onPressed: () {
                                FirestoreService().sendMessage(
                                  threadID: thread.id,
                                  message: Message(
                                    message: messageController.text,
                                    sentBy: {
                                      "profileIMG": report.profileIMG,
                                      "user": AuthService().user!.uid,
                                      "username": report.username,
                                    },
                                  ),
                                );
                                messageController.text = "";
                                needScroll = true;
                              },
                              child: const Text('Send')),
                        ),
                      ],
                    ),
                  ),
                  FutureBuilder<Map<String, UserData>>(
                      future:
                          FirestoreService().getUsersFromThread(thread: thread),
                      builder: (context, users) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 100),
                          child: Stack(children: [
                            SingleChildScrollView(
                              controller: controller,
                              child: Column(
                                  children: (users.data != null
                                      ? data
                                          .map((e) => MessageWidget(
                                                message: e,
                                                user: users
                                                    .data![e.sentBy["user"]],
                                              ))
                                          .toList()
                                      : [Text("Begin Your Conversation")])),
                            ),
                          ]),
                        );
                      })
                ],
              ),
            );
          }),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40.0),
        child: FloatingActionButton(
            onPressed: () {
              scrollDown(controller);
            },
            child: Icon(FontAwesomeIcons.arrowDown)),
      ),
    );
  }

  Future<void> scrollDown(ScrollController _controller) {
    return _controller.animateTo(_controller.position.maxScrollExtent,
        duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
  }
}

class MessageWidget extends StatelessWidget {
  final Message message;
  final UserData? user;

  const MessageWidget({
    Key? key,
    required this.message,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserData userNotNull = user ?? UserData();
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DecoratedBox(
          decoration: BoxDecoration(color: Colors.grey[800]),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 4.0,
              bottom: 4.0,
              left: 4.0,
              right: 4.0,
            ),
            child: Row(
              children: [
                Stack(
                  children: [
                    Image.network(
                      userNotNull.profileIMG,
                      width: 50,
                    ),
                    Positioned(
                      bottom: -1,
                      left: 1,
                      child: Text(
                        userNotNull.displayName,
                        style: const TextStyle(
                          fontSize: 10.0,
                          backgroundColor: Color.fromARGB(97, 0, 0, 0),
                        ),
                      ),
                    )
                  ],
                ),
                Text(': ${message.message}')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
