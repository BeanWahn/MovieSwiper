class FilterList {
  List<dynamic>? genres;

  FilterList({
    this.genres,
  });

  factory FilterList.fromJson(Map<String, dynamic> json) {
    return FilterList(
      genres: json['genres'],
    );
  }
}