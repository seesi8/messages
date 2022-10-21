import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messages/services/auth.dart';
import 'package:messages/services/models.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<dynamic> getUsers(String user) async {
    var ref = _db.collection('users').doc(user);
    var snapshot = await ref.get();
    var data = snapshot.data() as Map<String, dynamic>;
    return data;
  }

  Stream<UserData> streamUserData() {
    return AuthService().userStream.switchMap((user) {
      if (user != null) {
        var ref = _db.collection('users').doc(user.uid);
        print('WHY: ${user.uid}');
        return ref
            .snapshots()
            .map((doc) => UserData.fromJson(doc.data()!, user.uid));
      } else {
        return Stream.fromIterable([UserData()]);
      }
    });
  }

  Stream<List<Future<Thread>>> streamThreads() {
    return AuthService().userStream.switchMap((user) {
      if (user != null) {
        var ref = _db
            .collection('threadsId')
            .where("members", arrayContains: user.uid);

        var iter = ref.snapshots().map((event) => event.docs.map((doc) async {
              DocumentSnapshot<Map<String, dynamic>> snapshot = (await _db
                  .collection('threads')
                  .doc((ThreadId.fromJson(doc.data())).id)
                  .get());
              return (Thread.fromJson(snapshot.data()!, snapshot.id));
            }).toList());
        return iter;
      } else {
        return Stream.fromIterable([
          [Future<Thread>.value(Thread())]
        ]);
      }
    });
  }

  Stream<List<Message>> streamMessages({required String id}) {
    var ref = _db
        .collection('threads')
        .doc(id)
        .collection('messages')
        .orderBy('timeSent');
    var docs = ref.snapshots().map(
        (event) => event.docs.map((e) => Message.fromJson(e.data())).toList());
    return docs;
  }

  Future<Map<String, UserData>> getUsersFromThread(
      {required Thread thread}) async {
    Map<String, UserData> thing = {};
    // thread.members.forEach((id) async {
    //   var ref = _db.collection('users').doc(id);
    //   var snapshot = await ref.get();
    //   var data = UserData.fromJson(snapshot.data()!);
    //   thing[snapshot.id] = data;
    // });

    await Future.forEach(thread.members, (String id) async {
      var ref = _db.collection('users').doc(id);
      var snapshot = await ref.get();
      var data = UserData.fromJson(snapshot.data()!, snapshot.id);
      thing[snapshot.id] = data;
    });

    return thing;
  }

  Future<List<UserData>> getUsersFromFriends(
      {required List<String> friends}) async {
    List<UserData> friendsData = [];
    await Future.forEach(friends, (String id) async {
      var ref = _db.collection('users').doc(id);
      var snapshot = await ref.get();
      var data = UserData.fromJson(snapshot.data()!, snapshot.id);
      friendsData.add(data);
    });
    return friendsData;
  }

  Stream<List<UserData>> getUsersStream() {
    List<UserData> friendsData = [];
    var snapshots = _db.collection('users');
    var data = snapshots.snapshots().map((event) =>
        event.docs.map((e) => UserData.fromJson(e.data(), e.id)).toList());
    return data;
  }

  void sendMessage({required String threadID, required Message message}) async {
    final batch = _db.batch();
    batch.set(
        _db
            .collection('threads')
            .doc(threadID)
            .collection('messages')
            .doc(Uuid().v4()),
        {
          "message": message.message,
          "sentBy": message.sentBy,
          "timeSent": FieldValue.serverTimestamp()
        });
    batch.update(_db.collection("threads").doc(threadID), {
      "latestMessage": FieldValue.serverTimestamp(),
    });
    await batch.commit();
  }

  void newThread({required Thread thread}) async {
    final batch = _db.batch();
    print(thread.groupName);
    String groupId = Uuid().v4();
    batch.set(_db.collection('threads').doc(groupId), {
      "createdAt": FieldValue.serverTimestamp(),
      "groupName": thread.groupName,
      "latestMessage": FieldValue.serverTimestamp(),
      "members": thread.members
    });
    batch.set(_db.collection("threadsId").doc(groupId), {
      "id": groupId,
      "members": thread.members,
    });
    await batch.commit();
  }

  Stream<Future<List<UserData>>> streamInterations({
    required UserData userData,
  }) {
    return AuthService().userStream.switchMap((user) {
      if (user != null) {
        return _db
            .collection("requests")
            .where("members", arrayContains: user.uid)
            .snapshots()
            .map((event) async {
          List<UserData> interactibles = [];

          for (var doc in event.docs) {
            var docData = Request.fromJson(doc.data());
            if (docData.from == user.uid) {
              var snapshot =
                  await _db.collection("users").doc(docData.to).get();
              interactibles
                  .add(UserData.fromJson(snapshot.data()!, snapshot.id));
            }
            if (docData.to == user.uid) {
              var snapshot =
                  await _db.collection("users").doc(docData.from).get();
              interactibles
                  .add(UserData.fromJson(snapshot.data()!, snapshot.id));
            }
          }
          for (var friend in userData.friends) {
            var snapshot = await _db.collection("users").doc(friend).get();
            var data = UserData.fromJson(snapshot.data()!, snapshot.id);
            interactibles.add(data);
          }
          return interactibles;
        });
      } else {
        return Stream.value(Future.value([UserData()]));
      }
    });
  }

  Stream<String> requestsStream({
    required String id,
    required List<String> friends,
  }) {
    return AuthService().userStream.switchMap((user) {
      if (user != null) {
        var thing = Stream.empty();
        var query =
            _db.collection('requests').where("from", whereIn: [user.uid, id]);
        return query.snapshots().map(
          (event) {
            String result = "enabled";
            event.docs.forEach((element) {
              if (friends.contains(id)) {
                result = "disabled";
              } else if (Request.fromJson(element.data()).to == id &&
                  Request.fromJson(element.data()).from == user.uid) {
                result = "outgoing";
              } else if (Request.fromJson(element.data()).from == id &&
                  Request.fromJson(element.data()).to == user.uid) {
                result = "incoming";
              }
            });
            return result;
          },
        );
      } else {
        print("cool");
        return Stream.value("disabled");
      }
    });
  }

  void removeFriend({required String userId, required String friendId}) {
    final userRef = _db.collection("users").doc(userId);
    final batch = _db.batch();
    final otherFriend = _db.collection("users").doc(friendId);

    batch.update(userRef, {
      "friends": FieldValue.arrayRemove([friendId])
    });
    batch.update(otherFriend, {
      "friends": FieldValue.arrayRemove([userId])
    });
    batch.commit();
  }

  void acceptFriend({required String userId, required String friendId}) {
    final batch = _db.batch();

    batch.delete(_db.collection("requests").doc('from${friendId}to${userId}'));
    batch.update(_db.collection("users").doc(userId), {
      "friends": FieldValue.arrayUnion([friendId]),
    });
    batch.update(_db.collection("users").doc(friendId), {
      "friends": FieldValue.arrayUnion([userId]),
    });
    batch.commit();
  }

  void requestFriend(
      {required String userId,
      required String friendId,
      required List<String> friends}) async {
    final batch = _db.batch();
    bool exists = false;
    var query =
        _db.collection('requests').where("from", whereIn: [userId, friendId]);
    await Future.forEach((await query.get()).docs,
        (QueryDocumentSnapshot<Map<String, dynamic>> element) {
      if (Request.fromJson(element.data()).to == friendId &&
          Request.fromJson(element.data()).from == userId) {
        exists = true;
      } else if (Request.fromJson(element.data()).from == friendId &&
          Request.fromJson(element.data()).to == userId) {
        exists = true;
      }
    });
    if (!exists && friends.contains(friendId) == false) {
      _db.collection("requests").doc("from${userId}to$friendId").set({
        "from": userId,
        "to": friendId,
        "members": [userId, friendId]
      });
    }
  }

  void removeRequest({required String userId, required String friendId}) {
    _db.collection("requests").doc('from${userId}to${friendId}').delete();
  }
}
