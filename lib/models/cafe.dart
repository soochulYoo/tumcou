class CafeData {
  final int id;
  final bool isFeatured;
  final String name;
  final String introduction;
  final int price;
  final String location;
  final String openingHours;

  CafeData({
    this.id,
    this.name,
    this.introduction,
    this.isFeatured,
    this.price,
    this.location,
    this.openingHours,
  });
}

class ReviewData {
  final double rating;
  final String text;
  final double ratingMean;
  var dateTime;

  ReviewData({this.rating, this.text, this.ratingMean, this.dateTime});
}

class CafeUrl {
  final String cafeImageUrl;
  final String cafeLogoUrl;

  CafeUrl({this.cafeImageUrl, this.cafeLogoUrl});
}
