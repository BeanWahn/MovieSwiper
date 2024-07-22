import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_swiper/models/movie.dart';
import 'package:http/http.dart' as http;

class UserService {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> addUser(String? name, String? email, String? uuid) {
    if(email != null && uuid != null) {
      return usersCollection
          .doc(uuid)
          .set(
            {'name': name, 
            'email': email, 
            'uuid': uuid, 
            'createdAt': FieldValue.serverTimestamp(), 
            'updatedAt': FieldValue.serverTimestamp(),
            })
          .then((value) => print('User added successfully'))
          .catchError((error) => print('Failed to add user: $error'));
    }else if(email == null) {
      return Future.error('Email is required');
    }else if(uuid == null) {
      return Future.error('UUID is required');
    }
    
    return Future.error('Invalid parameters');
  }

  Future<void> addMovieToWatchlist(String? movieId, String? userId) {
    if(movieId != null && userId != null) {
      return usersCollection
          .doc(userId)
          .collection('watchlist')
          .add({'movieId': movieId, 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()})
          .then((value) => print('Movie added to watchlist successfully'))
          .catchError((error) => print('Failed to add movie to watchlist: $error'));
    }else if(movieId == null) {
      return Future.error('Movie ID is required');
    }else if(userId == null) {
      return Future.error('User ID is required');
    }
    
    return Future.error('Invalid parameters');
  }

  Future<void> addMovieToDislikelist(String? movieId, String? userId) {
    if(movieId != null && userId != null) {
      return usersCollection
          .doc(userId)
          .collection('dislikelist')
          .add({'movieId': movieId, 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()})
          .then((value) => print('Movie added to dislikelist successfully'))
          .catchError((error) => print('Failed to add movie to dislikelist: $error'));
    }else if(movieId == null) {
      return Future.error('Movie ID is required');
    }else if(userId == null) {
      return Future.error('User ID is required');
    }
    
    return Future.error('Invalid parameters');
  }

  Future<List<Movie>> getWatchlist(String? userId) async {
    List<Movie> watchlist = [];
    if(userId != null) {
      await usersCollection
          .doc(userId)
          .collection('watchlist')
          .get()
          .then((QuerySnapshot querySnapshot) async {
            for (var doc in querySnapshot.docs) {
              final data = doc.data() as Map<String, dynamic>;
              if(data['movieId'] != null) {
                final url = Uri.parse("https://api.themoviedb.org/3/movie/${data['movieId']}?api_key=7b42befb557378d22a24fdd7011ef7d5");
                final result = await http.get(url);
                if (result.statusCode == 200) {
                  final jsonResponse = json.decode(result.body);
                  if(jsonResponse != null) {
                    watchlist.add(Movie.fromJson(jsonResponse));
                  }
                }
              }
            }
          });
    }else {
      return Future.error('User ID is required');
    }
    return watchlist;
  }

  Future<List<Movie>> getDislikelist(String? userId) async {
    List<Movie> dislikelist = [];
    if(userId != null) {
      await usersCollection
          .doc(userId)
          .collection('dislikelist')
          .get()
          .then((QuerySnapshot querySnapshot) async {
            for (var doc in querySnapshot.docs) {
              final data = doc.data() as Map<String, dynamic>;
              if(data['movieId'] != null) {
                final url = Uri.parse("https://api.themoviedb.org/3/movie/${data['movieId']}?api_key=7b42befb557378d22a24fdd7011ef7d5");
                final result = await http.get(url);
                if (result.statusCode == 200) {
                  final jsonResponse = json.decode(result.body);
                  if(jsonResponse != null) {
                    dislikelist.add(Movie.fromJson(jsonResponse));
                  }
                }
              }
            }
          });
    }else {
      return Future.error('User ID is required');
    }
    return dislikelist;
  }

  String getLoginErrorMessage(String errorCode) {
    switch (errorCode) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        return "Email already used. Go to login page.";
      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
        return "Wrong email/password combination.";
      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        return "No user found with this email.";
      case "ERROR_USER_DISABLED":
      case "user-disabled":
        return "User disabled.";
      case "ERROR_TOO_MANY_REQUESTS":
      case "error-too-many-requests":
        return "Too many requests to log into this account.";
      case "ERROR_OPERATION_NOT_ALLOWED":
      case "operation-not-allowed":
        return "Server error, please try again later.";
      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
        return "Email address is invalid.";
      default:
        return "Login failed. Please try again.";
    }
  }
}