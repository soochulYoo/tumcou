import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tumcou1/screens/home/event_page/background_color_transition.dart';
import 'package:tumcou1/screens/home/event_page/offset_transition.dart';
import 'package:tumcou1/screens/home/event_page/widget/movie_item_card.dart';
import 'dart:convert' show json;
import 'package:tumcou1/screens/home/event_page/models/movie.dart';
import 'package:google_fonts/google_fonts.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key key}) : super(key: key);
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> with TickerProviderStateMixin {
  int currentIndex = 0;

  AnimationController _opacityAnimationController;
  AnimationController _animationController;
  Animation<Offset> _offsetAnimation;
  Animation<Color> _backgroundColorAnimation;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _opacityAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1))
          ..forward();
    _offsetAnimation = OffsetTransition(begin: Offset(0, -1), end: Offset.zero)
        .animate(CurvedAnimation(
            curve: Curves.bounceOut, parent: _opacityAnimationController));
  }

  Widget build(BuildContext context) {
    var cardSize = (MediaQuery.of(context).size.height / 7) * 4;
    return Scaffold(
        appBar: AppBar(
          title: Text('EVENTS',
              style: GoogleFonts.cambay(
                  textStyle: TextStyle(
                color: Colors.blueGrey[700],
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ))),
          backgroundColor: Colors.green[50],
        ),
        body: FutureBuilder(
          future: _getMovies(),
          builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: Text('Loading...'),
              );
            } else
              if (_backgroundColorAnimation == null) {
                _backgroundColorAnimation = ColorTween(
                  begin: getColorFromHex(
                      snapshot.data[currentIndex].backgroundColor),
                  end: getColorFromHex(
                      snapshot.data[currentIndex].backgroundColor),
                ).animate(_animationController);
              }
              return BackgroundColorTransition(
                color: _backgroundColorAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '${currentIndex + 1} from ${snapshot.data.length} of movies',
                      style: TextStyle(color: Color(0xFFFFFFFF)),
                    ),
                    SlideTransition(
                      position: _offsetAnimation,
                      child: FadeTransition(
                        opacity: _opacityAnimationController,
                        child: Container(
                          height: cardSize,
                          child: PageView.builder(
                            controller: PageController(viewportFraction: 0.8),
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, 'detailPage',
                                      arguments: snapshot.data[index]);
                                },
                                onDoubleTap: () {
                                  if (_opacityAnimationController.status ==
                                      AnimationStatus.completed) {
                                    _opacityAnimationController.reverse();
                                  } else {
                                    _opacityAnimationController.forward();
                                  }
                                },
                                child: MovieItemCard(
                                    cardSize: cardSize,
                                    movie: snapshot.data[index],
                                    index: index),
                              );
                            },
                            onPageChanged: (int newIndex) {
                              setState(() {
                                _backgroundColorAnimation = ColorTween(
                                        begin: getColorFromHex(snapshot
                                            .data[currentIndex]
                                            .backgroundColor),
                                        end: getColorFromHex(snapshot
                                            .data[newIndex].backgroundColor))
                                    .animate(_animationController);
                                _animationController.reset();
                                _animationController.forward();
                                currentIndex = newIndex;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );

          },
        ));
  }

  Future<List<Movie>> _getMovies() async {
    String data =
        await DefaultAssetBundle.of(context).loadString("assets/movies.json");
    List<dynamic> movies = json.decode(data);
    List<Movie> myMovies = [];
    movies.forEach((movie) {
      Movie movieElement = Movie.fromJson(movie);
      myMovies.add(movieElement);
    });
    return myMovies;
  }
}

Color getColorFromHex(String hexColorCode) =>
    Color(int.parse('0xFF$hexColorCode'));
