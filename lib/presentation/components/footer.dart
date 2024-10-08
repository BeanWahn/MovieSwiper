import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Footer extends StatefulWidget {
  @override
  _FooterState createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      padding: const EdgeInsets.all(0),
      height: 60,
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            context.go('/');
          },
        ),
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            context.go('/search');
          },
        ),
        IconButton(
          icon: Icon(Icons.favorite),
          onPressed: () {
            context.go('/watchlist');
          },
        ),
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            context.go('/settings');
          },
        ),
      ],
    ));
  }
}
