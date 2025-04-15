class MenuObject {
  final int id;
  final String name;
  final String price;
  final String image;
  final bool state;
  int count;

  MenuObject( {
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.state,
    this.count = 0,
  });

  
   factory MenuObject.fromJson(Map<String, dynamic> json) {
    return MenuObject(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      image: json['image'],
      count: json['count'] ?? 0,
      state: json['AddedToCart'] ,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image': image,
      'count': count,
      'AddedToCart': state,
    };
  }
}

