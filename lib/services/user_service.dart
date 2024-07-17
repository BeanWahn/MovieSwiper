import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('User');

  Future<void> addUser(String name, String email) {
    return usersCollection
        .add({'name': name, 'email': email})
        .then((value) => print('User added successfully'))
        .catchError((error) => print('Failed to add user: $error'));
  }
}