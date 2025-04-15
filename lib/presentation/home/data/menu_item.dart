class MenuObject {
  final int id;
  final String name;
  final String price;
  final String image;
  int count;

  MenuObject({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    this.count = 0,
  });
}
