import 'package:flutter/material.dart';
import 'package:movie_swiper/models/movie.dart';
import 'package:movie_swiper/presentation/components/footer.dart';
import 'package:movie_swiper/presentation/components/search_form.dart';
import 'package:movie_swiper/presentation/components/search_results.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Movie> movies = [];

  callback(List<Movie> newMovies) {
    print(newMovies);
    setState((){
      movies = newMovies;
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [SearchForm(callback: callback,),const SizedBox(height: 12),SearchResults(movies: movies,)],
          )),
          bottomNavigationBar: Footer(),
    );
  }
}
