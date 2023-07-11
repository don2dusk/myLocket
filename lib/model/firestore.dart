import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';

final GetStorage userStorage = GetStorage();
final firestore = FirebaseFirestore.instance;

class Users {
  final String? name;
  final String? phoneNumber;
  final String? profileUrl;
  final List<String>? friends;

  const Users({
    this.name,
    this.phoneNumber,
    this.profileUrl,
    this.friends,
  });

  factory Users.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Users(
      name: data?['name'],
      phoneNumber: data?['phoneNumber'],
      profileUrl: data?['profileUrl'],
      friends:
          data?['friends'] is Iterable ? List.from(data?['friends']) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (phoneNumber != null) "phoneNumber": phoneNumber,
      if (profileUrl != null) "profileUrl": profileUrl,
      if (friends != null) "friends": friends,
    };
  }

  void updateInfo(Users data) async {
    String uid = userStorage.read('uid');
    if (uid.isNotEmpty) {
      final userRef = firestore
          .collection('users')
          .withConverter(
              fromFirestore: Users.fromFirestore,
              toFirestore: (Users user, options) => user.toFirestore())
          .doc(uid);
      await userRef.set(data, SetOptions(merge: true));
    }
  }
}

class Images {
  final String? dateCreated;
  final String? message;
  final String? url;
  final List<String>? visibility;

  const Images({this.dateCreated, this.message, this.url, this.visibility});

  factory Images.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return Images(
      dateCreated: data?['dateCreated'],
      message: data?['message'],
      url: data?['url'],
      visibility: data?['visibility'] is Iterable
          ? List.from(data?['visibility'])
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (dateCreated != null) "dateCreated": dateCreated,
      if (message != null) "message": message,
      if (url != null) "url": url,
      if (visibility != null) "visibility": visibility,
    };
  }
}

class FriendRequests {
  final String? senderId;
  final String? receiverId;
  final String? status;

  const FriendRequests({this.senderId, this.receiverId, this.status});

  factory FriendRequests.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return FriendRequests(
      senderId: data?['senderId'],
      receiverId: data?['receiverId'],
      status: data?['status'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (senderId != null) "senderId": senderId,
      if (receiverId != null) "receiverId": receiverId,
      if (status != null) "status": status,
    };
  }
}
