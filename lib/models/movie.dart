class Movie {
  int movieId;
  bool adult;
  String? backdropPath;
  String? posterPath;
  List<dynamic>? genreIds;
  String? originalLanguage;
  String? originalTitle;
  double popularity;
  String title;
  String overview;
  double voteAverage;
  int voteCount;
  bool video;
  String releaseDate;

  Movie({
    required this.movieId,
    required this.adult,
    this.backdropPath,
    this.posterPath,
    this.genreIds,
    this.originalLanguage,
    this.originalTitle,
    required this.popularity,
    required this.title,
    required this.overview,
    required this.voteAverage,
    required this.voteCount,
    required this.video,
    required this.releaseDate,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      movieId: json['id'],
      adult: json['adult'],
      backdropPath: json['backdrop_path'],
      posterPath: json['poster_path'],
      genreIds: json['genre_ids'],
      originalLanguage: json['original_language'],
      originalTitle: json['original_title'],
      popularity: json['popularity'],
      title: json['title'],
      overview: json['overview'],
      voteAverage: json['vote_average'],
      voteCount: json['vote_count'],
      video: json['video'],
      releaseDate: json['release_date'],
    );
  }
}