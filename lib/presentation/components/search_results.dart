import 'package:flutter/material.dart';
import 'package:movie_swiper/models/movie.dart';
import 'package:movie_swiper/presentation/components/search_result_card.dart';

class SearchResults extends StatefulWidget {
  final List<Movie> movies;

  SearchResults({required this.movies});

  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: widget.movies.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (BuildContext context, int index) {
        Movie movie = widget.movies[index];
        return Card(
          child: Column(
            children: [
              Expanded(
                child: SearchResultCard(movie: movie),
              ),
            ],
          ),
        );
      },
    ));
  }
}
