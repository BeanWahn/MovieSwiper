import 'package:flutter/material.dart';
import 'package:movie_swiper/presentation/components/footer.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  List<String> _watchlist = ["Item 1", "Item 2", "Item 3", "Item 4"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Watchlist"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: _watchlist.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_watchlist[index]),
            );
          },
        ),
        Footer(),
      ]),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: WatchlistPage(),
  ));
}
