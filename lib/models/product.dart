class Product {
  final String name;
  final String description;
  final String imagePath;
  final double price;
  final ProductGategory productGategory;
  final Types types;

  Product({
    required this.name,
    required this.description,
    required this.imagePath,
    required this.price,
    required this.productGategory,
    required this.types,
  });
}

enum ProductGategory { watches, shirts, shoes }

enum Types { food, products }
