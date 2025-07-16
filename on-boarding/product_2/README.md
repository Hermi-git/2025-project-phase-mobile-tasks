# Dart CLI Product Manager

This is a simple command-line product manager built with Dart.  
It allows users to **add**, **view**, **edit**, and **delete** products interactively via the terminal.

## Features

- Add new products with name, description, and price
- View all products in a list
- View details of a single product by index
- Edit product information
- Delete products by index
- Input validation for safe interaction

## Getting Started

### Requirements

- [Dart SDK](https://dart.dev/get-dart) (2.17 or higher)

### Run the App

```bash
dart run

## Example input 
==== Product Manager ====
1. Add Product
2. View All Products
3. View Single Product
4. Edit Product
5. Delete Product
6. Exit

### File structure
bin/
├── product.dart            # Product class (model)
├── product_manager.dart    # Business logic for managing products
└── product_2.dart          # Main entry point with CLI interface
