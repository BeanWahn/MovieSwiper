import 'package:flutter/material.dart';
import 'package:movie_swiper/models/movie.dart';
import 'package:movie_swiper/services/movies_service.dart';

class SearchForm extends StatefulWidget {
  Function(List<Movie>) callback;

  SearchForm({super.key, required this.callback});

  @override
  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  final moviesService = MoviesService();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: TextFormField(
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        decoration: const InputDecoration(
          labelText: 'Search',
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          moviesService.searchMovies(value).then((movies) {
            widget.callback(movies);
          });
        },
      ),
    );
  }
}
