// lib/cart_manager.dart

class CartManager {
  static final CartManager _instance = CartManager._internal();

  factory CartManager() {
    return _instance;
  }

  CartManager._internal();

  final List<Map<String, String>> cartItems = [];

  void addBookToCart(Map<String, String> book) {
    if (book['title']!.isNotEmpty && cartItems.length < 3) {
      print('cart manager.');

      cartItems.add(book);
    }
  }

  void removeBookFromCart(int index) {
    if (index >= 0 && index < cartItems.length) {
      cartItems.removeAt(index);
    }
  }
}
