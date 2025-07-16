import 'dart:io';
import 'product.dart';
import 'product_manager.dart';

void main() {
  var manager = ProductManager();

  while (true) {
    print("\n==== Product Manager ====");
    print("1. Add Product");
    print("2. View All Products");
    print("3. View Single Product");
    print("4. Edit Product");
    print("5. Delete Product");
    print("6. Exit");
    stdout.write("Choose an option (1-6): ");
    var choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        stdout.write("Enter product name: ");
        String? name = stdin.readLineSync();

        stdout.write("Enter product description: ");
        String? description = stdin.readLineSync();

        stdout.write("Enter product price: ");
        double? price = double.tryParse(stdin.readLineSync()!);

        if (name != null && description != null && price != null) {
          manager.addProduct(Product(name, description, price));
          print("Product added successfully.");
        } else {
          print("Invalid input. Failed to add product.");
        }

        break;
      case '2':
        manager.printAllProducts();
        break;
      case '3':
        stdout.write("Enter the index of the product to view: ");
        int? index = int.tryParse(stdin.readLineSync()!);

        if (index != null) {
          manager.viewProduct(index);
        } else {
          print("Invalid input. Please enter a valid index.");
        }
        break;
      case '4':
        stdout.write("Enter the index of the product to edit: ");
        int? index = int.tryParse(stdin.readLineSync()!);

        if (index != null) {
          stdout.write("Enter new product name: ");
          String name = stdin.readLineSync()!;

          stdout.write("Enter new product description: ");
          String description = stdin.readLineSync()!;

          stdout.write("Enter new product price: ");
          double? price = double.tryParse(stdin.readLineSync()!);

          if (price != null) {
            manager.editProduct(index, name, description, price);
          } else {
            print("Invalid price entered.");
          }
        } else {
          print("Invalid index entered.");
        }

        break;
      case '5':
        stdout.write("Enter the index of the product to delete: ");
        int? index = int.tryParse(stdin.readLineSync()!);

        if (index != null) {
          manager.deleteProduct(index);
        } else {
          print("Invalid index entered.");
        }

        break;
      case '6':
        print("Goodbye!");
        return;
      default:
        print("Invalid option. Try again.");
    }
  }
}
