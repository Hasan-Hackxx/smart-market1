class Userinfo {
  final String productName;
  final String productdisc;
  final String productprice;
  final String imageUrl;
  final bool clothes;
  final bool food;
  final String email;
  final String id;

  Userinfo({
    required this.productName,
    required this.productdisc,
    required this.productprice,
    required this.imageUrl,
    required this.clothes,
    required this.food,
    required this.email,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'productdisc': productdisc,
      'productprice': productprice,
      'imageUrl': imageUrl,
      'clothes': clothes,
      'food': food,
      'email': email,
      'id': id,
    };
  }
}
