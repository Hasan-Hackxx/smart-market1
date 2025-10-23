class Food {
  final String name;
  final String description;
  final String imagePath;
  final double price;
  final FoodGategory foodgategory;
  List<Addons> selectedaddon;

  Food({
    required this.name,
    required this.description,
    required this.imagePath,
    required this.price,
    required this.foodgategory,
    required this.selectedaddon,
  });
}

enum FoodGategory { burgers, salads, drinks }

class Addons {
  final String name;
  final double price;

  Addons({required this.name, required this.price});
}
