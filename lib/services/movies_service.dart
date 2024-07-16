import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie_swiper/models/movie.dart';

class MoviesService {
  Widget buildRatingStars(double rating, bool isOnWhite) {
    final roundedRating = (rating * 4).round() / 4;
    final fullStars = roundedRating.floor();
    final halfStars = (roundedRating - fullStars) >= 0.25 ? 1 : 0;
    final emptyStars = 10 - fullStars - halfStars;
    final color = isOnWhite ? Colors.yellow.shade700 : Colors.yellow.shade600;

    return Row(
      children: [
        for (int i = 0; i < fullStars; i++)
          Icon(Icons.star, color: color, size: 20),
        for (int i = 0; i < halfStars; i++)
          Icon(Icons.star_half, color: color, size: 20),
        for (int i = 0; i < emptyStars; i++)
          Icon(Icons.star_border, color: color, size: 20),
      ],
    );
  }

  Future<List<Movie>> getRecommendedMovies(List<Movie> movies) async {
    List<Movie> recommendations = [];
    for (Movie movie in movies) {
      final url = Uri.parse("https://api.themoviedb.org/3/movie/${movie.movieId}/recommendations"
      "?api_key=7b42befb557378d22a24fdd7011ef7d5"
      "&page=1");
      final result = await http.get(url);
      if (result.statusCode == 200) {
        final jsonData = json.decode(result.body);
        final movieData = jsonData['results'];
        for (var data in movieData) {
          final movie = Movie.fromJson(data);
          recommendations.add(movie);
        }
      }
    }
    return recommendations;
  }

  Future<http.Response> fetchMovies(int page) async {
    final url = Uri.parse("https://api.themoviedb.org/3/discover/movie"
    "?api_key=7b42befb557378d22a24fdd7011ef7d5"
    "&language=en-US"
    "&sort_by=popularity.desc"
    "&include_adult=false"
    "&include_video=false"
    "&page=$page");
    final result = await http.get(url);
    return result;
  }
}