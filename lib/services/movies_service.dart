import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie_swiper/models/filter_list.dart';
import 'package:movie_swiper/models/movie.dart';
import 'package:movie_swiper/services/user_service.dart';

class MoviesService {

  UserService userService = UserService();

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

  Future<Map<String,dynamic>> getRecommendedMovies(List<Movie> movies, {page = 1}) async {
    List<Movie> allRecommendations = [];
    List<Movie> primaryRecommendations = [];
    List<Movie> secondaryRecommendations = [];
    List<Movie> tertiaryRecommendations = [];

    print(page);

    for (Movie movie in movies) {
      final url = Uri.parse(
          "https://api.themoviedb.org/3/movie/${movie.movieId}/recommendations"
          "?api_key=7b42befb557378d22a24fdd7011ef7d5"
          "&page=$page");
      final result = await http.get(url);
      if (result.statusCode == 200) {
        final jsonData = json.decode(result.body);
        final movieData = jsonData['results'];
        for (var data in movieData) {
          final newMovie = Movie.fromJson(data);
          if (movie.genreIds != null &&
              movie.genreIds!.isNotEmpty &&
              newMovie.genreIds != null &&
              newMovie.genreIds!.isNotEmpty) {
                if(movie.genreIds!
                      .toSet()
                      .intersection(newMovie.genreIds!.toSet())
                      .length >
                  1){
                  allRecommendations.add(newMovie);
                  primaryRecommendations.add(newMovie);
                }
                else if(movie.genreIds!
                      .toSet()
                      .intersection(newMovie.genreIds!.toSet()).isNotEmpty){
                  secondaryRecommendations.add(newMovie);
                }
                else{
                  tertiaryRecommendations.add(newMovie);
                }
          }
        }
      }
    }

    if(allRecommendations.length < 5){
      for (var movie in secondaryRecommendations) {
        if (allRecommendations.length >= 5) {
          break;
        }
        allRecommendations.add(movie);
      }
    }
    if(allRecommendations.length < 5){
      for (var movie in tertiaryRecommendations) {
        if (allRecommendations.length >= 5) {
          break;
        }
        allRecommendations.add(movie);
      }
    }
    if(allRecommendations.isEmpty && page != 1){
      page = 1;
      Map<String,dynamic> firstPage = await getRecommendedMovies(movies, page:page);
      if(firstPage.isNotEmpty){
        allRecommendations = firstPage['recommendations'];
      }
    }
    return {
      "page":page,
      "recommendations":allRecommendations,
    };
  }

  Future<FetchMovieResponse> fetchMovies(int page, FilterList? filters, String? userId,
      {bool resetPageIfEmpty = false}) async {
        List<Movie> watchlist = await userService.getWatchlist(userId);
        List<Movie> dislikelist = await userService.getDislikelist(userId);

    if (page > 500) {
      page = 1;
    }
    String urlString = "https://api.themoviedb.org/3/discover/movie"
        "?api_key=7b42befb557378d22a24fdd7011ef7d5"
        "&language=en-US"
        "&sort_by=popularity.desc"
        "&include_adult=false"
        "&include_video=false"
        "&page=$page";
    if (filters != null && filters.genres!.isNotEmpty) {
      urlString += "&with_genres=${filters.genres!.join(",")}";
    }
    final url = Uri.parse(urlString);
    final result = await http.get(url);
    final List<Movie> movies = [];
    if (json.decode(result.body)['results'] == null ||
        json.decode(result.body)['results'].length <= 0) {
      if (page <= 1) {
        return FetchMovieResponse(page: page, results: movies);
      }
      if (resetPageIfEmpty) {
        page = 1;
      } else {
        page = (page / 2).round();
      }
      return fetchMovies(page, filters, userId);
    }
    else{
      for (var data in json.decode(result.body)['results']) {
        final movie = Movie.fromJson(data);
        if (!watchlist.any((element) => element.movieId == movie.movieId) && 
        !dislikelist.any((element) => element.movieId == movie.movieId)) {
          movies.add(movie);
        }
      }
    }
    // print(result.body);
    // print('{"page":$page,"results": ${json.encode(movies)}}');
    // print('{"results": ${json.encode(movies)}}');
    return FetchMovieResponse(page: page, results: movies);
  }

  Future<List<Movie>> searchMovies(String searchTerm) async {
    final url = Uri.parse("https://api.themoviedb.org/3/search/movie"
        "?api_key=7b42befb557378d22a24fdd7011ef7d5"
        "&language=en-US"
        "&query=$searchTerm"
        "&page=1"
        "&include_adult=false");
    final result = await http.get(url);
    if (result.statusCode == 200) {
      final jsonData = json.decode(result.body);
      final movieData = jsonData['results'];
      List<Movie> movies = [];
      for (var data in movieData) {
        final movie = Movie.fromJson(data);
        movies.add(movie);
      }
      return movies;
    } else {
      throw Exception('Failed to search movies');
    }
  }
}
