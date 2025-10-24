import 'package:smartmarket1/models/food.dart';
import 'package:smartmarket1/models/product.dart';

class Bigstroe {
  // food items

  final List<Food> menu1 = [
    // burgers
    Food(
      name: 'Burger1',
      description:
          'a juucy beef party with metled chedder, letture, tomato, and a hint pf onion and pickle',
      imagePath: 'image/burger1.jpg',
      price: 2.00,
      foodgategory: FoodGategory.burgers,
      selectedaddon: [
        Addons(name: ' double cheese and alote of catchab', price: 1.50),
      ],
    ),
    Food(
      name: 'Burger2',
      description:
          'a juucy beef party with metled chedder, letture, tomato, and a hint pf onion and pickle',
      imagePath: 'images/food/b3.jpg',
      price: 2.00,
      foodgategory: FoodGategory.burgers,
      selectedaddon: [
        Addons(name: ' double cheese and alote of catchab', price: 1.50),
      ],
    ),
    // salads
    Food(
      name: 'Salad1',
      description: 'cut tommato, onion, lemons, banana',
      imagePath: 'images/food/s1.jpg',
      price: 1.00,
      foodgategory: FoodGategory.salads,
      selectedaddon: [Addons(name: 'fruits with salad and drink', price: 2.00)],
    ),
    Food(
      name: 'Salad2',
      description: 'cut tommato, onion, lemons, banana',
      imagePath: 'images/food/s2.jpg',
      price: 1.00,
      foodgategory: FoodGategory.salads,
      selectedaddon: [Addons(name: 'fruits with salad and drink', price: 2.00)],
    ),
    Food(
      name: 'Salad3',
      description: 'cut tommato, onion, lemons, banana',
      imagePath: 'images/food/s3.jpg',
      price: 1.00,
      foodgategory: FoodGategory.salads,
      selectedaddon: [Addons(name: 'fruits with salad and drink', price: 2.00)],
    ),
    // drinks
    Food(
      name: 'drink1',
      description: 'drink juice, ice cream, hot water',
      imagePath: 'images/food/d1.jpg',
      price: 1.20,
      foodgategory: FoodGategory.drinks,
      selectedaddon: [Addons(name: 'surprise with the order', price: 5.00)],
    ),
    Food(
      name: 'drink2',
      description: 'drink juice, ice cream, hot water',
      imagePath: 'images/food/d2.jpg',
      price: 1.20,
      foodgategory: FoodGategory.drinks,
      selectedaddon: [Addons(name: 'surprise with the order', price: 5.00)],
    ),
    Food(
      name: 'drink2',
      description: 'drink juice, ice cream, hot water',
      imagePath: 'images/food/d3.jpg',
      price: 1.20,
      foodgategory: FoodGategory.drinks,
      selectedaddon: [Addons(name: 'surprise with the order', price: 5.00)],
    ),
  ];

  final List<Product> menu2 = [
    //products items
    //watches
    Product(
      name: 'Watch1',
      description: 'black watch and brigting',
      imagePath: 'image/watch.jpg',
      price: 45000.0,
      productGategory: ProductGategory.watches,
      types: Types.products,
    ),
    Product(
      name: 'Watch2',
      description: 'black watch and brigting',
      imagePath: 'images/products/w2.jpg',
      price: 45000.0,
      productGategory: ProductGategory.watches,
      types: Types.products,
    ),
    Product(
      name: 'Watch3',
      description: 'black watch and brigting',
      imagePath: 'images/products/w3.jpg',
      price: 45000.0,
      productGategory: ProductGategory.watches,
      types: Types.products,
    ),
    //shoes
    Product(
      name: 'Shoes1',
      description: 'balck shoes and size 40',
      imagePath: 'images/products/shoes.jpg',
      price: 25.0,
      productGategory: ProductGategory.shoes,
      types: Types.products,
    ),
    Product(
      name: 'Shoes2',
      description: 'balck shoes and size 40',
      imagePath: 'images/products/sho2.jpg',
      price: 25.0,
      productGategory: ProductGategory.shoes,
      types: Types.products,
    ),
    Product(
      name: 'Shoes3',
      description: 'balck shoes and size 40',
      imagePath: 'images/products/sho3.jpg',
      price: 25.0,
      productGategory: ProductGategory.shoes,
      types: Types.products,
    ),
    //shirts
    Product(
      name: 'shirt1',
      description: 'black shirt, size 35, for men',
      imagePath: 'image/shirt.jpg',
      price: 10.0,
      productGategory: ProductGategory.shirts,
      types: Types.products,
    ),
    Product(
      name: 'shirt2',
      description: 'black shirt, size 35, for men',
      imagePath: 'images/products/sh2.jpg',
      price: 10.0,
      productGategory: ProductGategory.shirts,
      types: Types.products,
    ),
    Product(
      name: 'shirt3',
      description: 'black shirt, size 35, for men',
      imagePath: 'images/products/sh3.jpg',
      price: 10.0,
      productGategory: ProductGategory.shirts,
      types: Types.products,
    ),
  ];

  // Generaters

  // add to cart

  //remove from cart

  //total price

  //total quaintity
}
