class CafeData {
  final int id;
  final bool isFeatured;
  final String name;
  final String introduction;
  final int price;
  final String location;
  final String openingHours;

  CafeData(
      {this.id,
        this.name,
        this.introduction,
        this.isFeatured,
        this.price,
        this.location,
        this.openingHours});
}