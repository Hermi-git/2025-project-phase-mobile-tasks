import 'product.dart';
class ProductManager{
  List<Product> _products = [];

  ProductManager();

  // Add a new product
  void addProduct(Product product) {
    _products.add(product);
  }

  // View All Products
  List<Product> viewAllProducts() {
    return _products;
  }

  // display all products
  void printAllProducts() {
    if (_products.isEmpty) {
      print("No products available.");
    } else {
      for (int i = 0; i < _products.length; i++) {
        var product = _products[i];
        print(
          "[$i] Product Name: ${product.name}, Description: ${product.description}, Price: \$${product.price}",
        );
      }
    }
  }

  // View a Single Product by Index
  void viewProduct(int index) {
    if (index >= 0 && index < _products.length) {
      var product = _products[index];
      print("Product Details:");
      print("Name: ${product.name}");
      print("Description: ${product.description}");
      print("Price: \$${product.price}");
    } else {
      print("Invalid product index!");
    }
  }

  //   Edit a Product by Index
  void editProduct(int index, String newName, String newDescription, double newPrice) {
      if (index >= 0 && index < _products.length) {
      var product = _products[index];
      product.name = newName;
      product.description = newDescription;
      product.price = newPrice;
       print("Product updated successfully.");
  }else {
      print("Invalid product index!");
    }
  }

  // Delete a Product by Index
  void deleteProduct(int index) {
    if (index >= 0 && index < _products.length) {
      var deletedProduct = _products.removeAt(index);
      print("Product '${deletedProduct.name}' deleted successfully.");
    } else {
      print("Invalid product index.");
    }
  }


}