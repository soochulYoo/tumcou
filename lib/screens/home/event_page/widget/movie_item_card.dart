import 'package:flutter/cupertino.dart';
import 'package:tumcou1/screens/home/event_page/models/movie.dart';
import 'package:tumcou1/screens/home/event_page/widget/floating_card.dart';


class MovieItemCard extends StatelessWidget {
  const MovieItemCard(
      {Key key,
      @required this.cardSize,
      @required this.movie,
      @required this.index})
      : super(key: key);

  final double cardSize;
  final int index;
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return FloatingCard(
      child: Stack(
        children: <Widget>[
          Positioned.fill(

             // tag: movie.title,
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
              ),
          ),
        ],
      ),
    );
  }
}
