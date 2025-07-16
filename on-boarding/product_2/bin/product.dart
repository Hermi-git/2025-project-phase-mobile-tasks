class Product {
  // Private fields
  String _name;
  String _description;
  double _price;

  // Constructor
  Product(this._name, this._description, this._price);

  // Getters
  String get name => _name;
  String get description => _description;
  double get price => _price;

  // Setters
  set name(String value) => _name = value;
  set description(String value) => _description = value;
  set price(double value) => _price = value;
}
