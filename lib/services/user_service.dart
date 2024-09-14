import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_swiper/models/movie.dart';
import 'package:http/http.dart' as http;

class UserService {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> addUser(String? name, String? email, String? uuid) {
    if (email != null && uuid != null) {
      return usersCollection
          .doc(uuid)
          .set({
            'name': name,
            'email': email,
            'uuid': uuid,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          })
          .then((value) => print('User added successfully'))
          .catchError((error) => print('Failed to add user: $error'));
    } else if (email == null) {
      return Future.error('Email is required');
    } else if (uuid == null) {
      return Future.error('UUID is required');
    }

    return Future.error('Invalid parameters');
  }

  Future<void> addMovieToWatchlist(Movie? movie, String? userId) {
    if (movie != null && userId != null) {
      final db = FirebaseFirestore.instance;
      DocumentReference ref = db.collection('users').doc(userId).collection('watchlist').doc(movie.movieId.toString());

      return ref.set({
        ...movie.toJson(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp()
      }, SetOptions(merge: true))
      .then((value) => print('Movie added to watchlist successfully'))
      .catchError(
          (error) => print('Failed to add movie to watchlist: $error'));
    } else if (movie == null) {
      return Future.error('Movie is required');
    } else if (userId == null) {
      return Future.error('User ID is required');
    }

    return Future.error('Invalid parameters');
  }

  Future<void> addMovieToDislikelist(Movie? movie, String? userId) {
    if (movie != null && userId != null) {
       final db = FirebaseFirestore.instance;
      DocumentReference ref = db.collection('users').doc(userId).collection('dislikelist').doc(movie.movieId.toString());

      return ref.set({
        ...movie.toJson(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp()
      }, SetOptions(merge: true))
      .then((value) => print('Movie added to dislike list successfully'))
      .catchError(
          (error) => print('Failed to add movie to dislike list: $error'));
    } else if (movie == null) {
      return Future.error('Movie ID is required');
    } else if (userId == null) {
      return Future.error('User ID is required');
    }

    return Future.error('Invalid parameters');
  }

  Future<List<Movie>> getWatchlist(String? userId) async {
    List<Movie> watchlist = [];
    if (userId != null) {
      await usersCollection
          .doc(userId)
          .collection('watchlist')
          .get()
          .then((QuerySnapshot querySnapshot) async {
        for (var doc in querySnapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;
          if (data['id'] != null) {
            final movie = Movie.fromJson(doc.data() as Map<String, dynamic>);
            watchlist.add(movie);
            // final url = Uri.parse(
            //     "https://api.themoviedb.org/3/movie/${data['movieId']}?api_key=7b42befb557378d22a24fdd7011ef7d5");
            // final result = await http.get(url);
            // if (result.statusCode == 200) {
            //   final jsonResponse = json.decode(result.body);
            //   if (jsonResponse != null) {
            //     watchlist.add(Movie.fromJson(jsonResponse));
            //   }
            // }
          }
        }
      });
    } else {
      return Future.error('User ID is required');
    }
    return watchlist;
  }

  Future<List<Movie>> getDislikelist(String? userId) async {
    List<Movie> dislikelist = [];
    if (userId != null) {
      await usersCollection
          .doc(userId)
          .collection('dislikelist')
          .get()
          .then((QuerySnapshot querySnapshot) async {
        for (var doc in querySnapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;
          if (data['id'] != null) {
            final movie = Movie.fromJson(doc.data() as Map<String, dynamic>);
            dislikelist.add(movie);
            // final url = Uri.parse("https://api.themoviedb.org/3/movie/${data['movieId']}?api_key=7b42befb557378d22a24fdd7011ef7d5");
            // final result = await http.get(url);
            // if (result.statusCode == 200) {
            //   final jsonResponse = json.decode(result.body);
            //   if(jsonResponse != null) {
            //     dislikelist.add(Movie.fromJson(jsonResponse));
            //   }
            // }
          }
        }
      });
    } else {
      return Future.error('User ID is required');
    }
    return dislikelist;
  }

  AuthException getAuthException(String errorCode) {
    switch (errorCode) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        return AuthException(
            "The account already exists for that email.", "email");
      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
        return AuthException("Wrong email/password combination.", "password");
      case "INVALID_LOGIN_CREDENTIALS":
      case "invalid-login-credentials":
        return AuthException("Invalid login credentials.", "password");
      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        return AuthException("No user found with this email.", "email");
      case "ERROR_USER_DISABLED":
      case "user-disabled":
        return AuthException("User disabled.", "general");
      case "ERROR_TOO_MANY_REQUESTS":
      case "too-many-requests":
        return AuthException(
            "Too many requests to log into this account.", "general");
      case "ERROR_OPERATION_NOT_ALLOWED":
      case "operation-not-allowed":
        return AuthException(
            "Server error, please try again later.", "general");
      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
        return AuthException("Email address is invalid.", "email");
      default:
        return AuthException("Login failed. Please try again.", "general");
    }
  }
}

class AuthException {
  final String message;
  final String errorType;
  AuthException(this.message, this.errorType);
}
