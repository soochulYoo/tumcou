

class Movie {
  String title;
  String duration;
  double rate;
  int position;
  String releaseDate;
  String shortInfo;
  String plot;
  String posterPath;
  String backgroundColor;
  String backdropImage;


  Movie (this.title,
      this.duration,
      this.rate,
      this.position,
      this.releaseDate,
      this.shortInfo,
      this.plot,
      this.posterPath,
      this.backgroundColor,
      this.backdropImage);

  Movie.fromJson(Map<String, dynamic> eventsJson) {
    Movie (
      title = eventsJson['title'],
      duration = eventsJson['duration'],
      rate = eventsJson['rate'],
      position = eventsJson['position'],
      releaseDate = eventsJson['release-date'],
      shortInfo =eventsJson['short-info'],
      plot = eventsJson['plot'],
      posterPath = eventsJson['poster_path'],
      backgroundColor = eventsJson['backgroundColor'],
      backdropImage = eventsJson['backdrop_image'],
    );
  }
}