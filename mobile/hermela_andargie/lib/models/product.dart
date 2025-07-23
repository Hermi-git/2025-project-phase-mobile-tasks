class Product {
  final String name;
  final String category;
  final double price;
  final double rating;
  final String image;

  Product({
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.image,
  });
}

final List<Product> products = [
  Product(
    name: "Derby Leather Shoes",
    category: "Men’s shoe",
    price: 120.0,
    rating: 4.0,
    image: "assets/images/derby_shoes.jpg",
  ),
  Product(
    name: "Elegant Heels",
    category: "Women’s shoe",
    price: 140.0,
    rating: 4.5,
    image: "assets/images/elegant_heels.jpg",
  ),
  Product(
    name: "Sport Running Shoes",
    category: "Unisex",
    price: 99.0,
    rating: 4.2,
    image: "assets/images/sport_running.jpg",
  ),
];
