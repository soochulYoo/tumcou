

class Movie {

  String posterPath;
  String backgroundColor;
  String backdropImage;


  Movie (
      this.posterPath,
      this.backgroundColor,
      this.backdropImage);

  Movie.fromJson(Map<String, dynamic> eventsJson) {
    Movie (

      posterPath = eventsJson['poster_path'],
      backgroundColor = eventsJson['backgroundColor'],
      backdropImage = eventsJson['backdrop_image'],
    );
  }
}