import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:developer';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:messages/services/auth.dart';
import 'package:messages/services/firestore.dart';
import 'package:messages/services/models.dart';
import 'package:messages/shared/friendSuggestion.dart';
import 'package:messages/thread/thread.dart';
import 'package:provider/provider.dart';

class ThreadsScreen extends StatelessWidget {
  const ThreadsScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var report = Provider.of<UserData>(context);
    // Query ref = FirebaseFirestore.instance
    //     .collection('threadsId')
    var thing = (FirestoreService().streamThreads().last);

    return StreamBuilder<List<Future<Thread>>>(
        stream: FirestoreService().streamThreads(),
        builder: (context, snapshot) {
          var threads = snapshot.data ?? [Future<Thread>.value(Thread())];
          var thing;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: const Text(
                "Threads",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                InkWell(
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      FontAwesomeIcons.house,
                      color: Colors.black,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).popAndPushNamed("/");
                  },
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext builder) {
                        return const Dialog(
                          child: Popup(),
                        );
                      },
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      FontAwesomeIcons.arrowUpRightFromSquare,
                      color: Colors.black,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext builder) {
                        return const Dialog(
                          child: Add(),
                        );
                      },
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      FontAwesomeIcons.plus,
                      color: Colors.black,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed("/profile");
                  },
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Image.network(report.profileIMG)),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                  children:
                      (threads.map((e) => ThreadItemButton(data: e))).toList()),
            ),
          );
        });
  }
}

class Popup extends StatefulWidget {
  const Popup({
    Key? key,
  }) : super(key: key);

  @override
  State<Popup> createState() => _PopupState();
}

class _PopupState extends State<Popup> {
  List<UserData> suggestions = [];
  List<UserData> members = [];
  TextEditingController groupNameController = TextEditingController();
  TextEditingController membersController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var report = Provider.of<UserData>(context);
    addToMembers(user) {
      if (!members.contains(user)) {
        setState(() {
          members.add(user);
        });
      }
    }

    addToMembers(report);

    return FutureBuilder<List<UserData>>(
        future: FirestoreService().getUsersFromFriends(friends: report.friends),
        builder: (context, snapshot) {
          List<UserData> data = snapshot.data ?? [];
          return Column(
            children: [
              TextField(
                controller: groupNameController,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(3),
                    border: InputBorder.none,
                    hintText: 'Group Name:'),
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    suggestions = [];
                  });
                  if (value == "") {
                    return;
                  }
                  for (var element in data) {
                    if (element.username.contains(value) ||
                        element.displayName.contains(value)) {
                      setState(() {
                        suggestions.add(element);
                      });
                    }
                  }
                  debugPrint(suggestions.toString());
                },
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(3),
                    border: InputBorder.none,
                    hintText: 'Members:'),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: members
                      .map((user) => Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  child: Image.network(
                                    user.profileIMG,
                                    width: 40,
                                    height: 40,
                                  ),
                                  // child: SizedBox(
                                  //   width: 40,
                                  //   height: 40,
                                  // ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  child: Text(
                                    user.displayName,
                                    style: const TextStyle(
                                        fontSize: 10,
                                        backgroundColor:
                                            Color.fromARGB(112, 0, 0, 0)),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        members.remove(user);
                                      });
                                    },
                                    child: const DecoratedBox(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        color: Color.fromARGB(190, 243, 16, 0),
                                      ),
                                      child: Icon(
                                        size: 20.0,
                                        FontAwesomeIcons.xmark,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
              Column(
                children: suggestions
                    .map((user) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SuggestionButton(
                              user: user, addToMembers: addToMembers),
                        ))
                    .toList(),
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (members == [] || groupNameController.text == '') {
                      return;
                    }
                    FirestoreService().newThread(
                        thread: new Thread(
                            members: members.map((e) => e.id).toList(),
                            groupName: groupNameController.text));
                    setState(() {
                      members = [];
                      groupNameController.text = "";
                      membersController.text = "";
                    });
                  },
                  child: Text("submit"))
            ],
          );
        });
  }
}

class SuggestionButton extends StatelessWidget {
  final UserData user;
  final Function addToMembers;
  const SuggestionButton({
    Key? key,
    required this.user,
    required this.addToMembers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.grey[700])),
      onPressed: () {
        addToMembers(user);
      },
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Image.network(
              user.profileIMG,
              height: 30,
            ),
          ),
          Text(user.displayName),
        ],
      ),
    );
  }
}

class ThreadItemButton extends StatelessWidget {
  final Future<Thread> data;
  const ThreadItemButton({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Thread>(
        future: data,
        builder: (context, item) {
          Thread thread = item.data ?? Thread();
          return (Center(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => ThreadScreen(
                              thread: (thread),
                            )));
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.grey[800])),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        '${item.data?.groupName}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )),
          ));
        });
  }
}

class Add extends StatefulWidget {
  const Add({
    Key? key,
  }) : super(key: key);

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  List<UserData> suggestions = [];
  TextEditingController groupNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var report = Provider.of<UserData>(context);

    return StreamBuilder<List<UserData>>(
        stream: FirestoreService().getUsersStream(),
        builder: (context, snapshot) {
          List<UserData> data = snapshot.data ?? [];
          return Column(
            children: [
              const Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Manage Friends"),
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    suggestions = [];
                  });
                  if (value == "") {
                    return;
                  }
                  for (var element in data) {
                    if (element.username.contains(value) ||
                        element.displayName.contains(value)) {
                      setState(() {
                        suggestions.add(element);
                      });
                    }
                  }
                  debugPrint(suggestions.toString());
                },
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(3),
                    border: InputBorder.none,
                    hintText: 'Search:'),
              ),
              Column(
                children: suggestions
                    .map((user) {
                      if (user.id != report.id) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FriendsSuggestionButton(user: user),
                        );
                      }
                    })
                    .toList()
                    .whereType<Padding>()
                    .toList(),
              ),
            ],
          );
        });
  }
}
