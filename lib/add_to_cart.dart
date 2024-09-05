import 'package:flutter/material.dart';
import 'package:admin_dashboard_app/home_page.dart' show HomePage;
import 'package:admin_dashboard_app/cart_manager.dart'; // Import CartManager
import 'package:admin_dashboard_app/issue_book.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AddtoCart(bookTitle: '', author: '', edition: '', quantity: '', description: ''),
    );
  }
}

class AddtoCart extends StatefulWidget {
  final String bookTitle;
  final String author;
  final String edition;
  final String quantity;
  final String description;

  const AddtoCart({
    super.key,
    required this.bookTitle,
    required this.author,
    required this.edition,
    required this.quantity,
    required this.description,
  });

  @override
  _AddtoCartState createState() => _AddtoCartState();
}

class _AddtoCartState extends State<AddtoCart> {
  final CartManager cartManager = CartManager(); // Use CartManager

  @override
  void initState() {
    super.initState();
  }

  void _addBookToCart() {
    if ( cartManager.cartItems.length < 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => IssuePage()),
      );
        print('add cart.');

    } else if (cartManager.cartItems.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You can only add up to 3 books to the cart.')),
      );
    }
  }

  void _removeItem(int index) {
    setState(() {
      cartManager.removeBookFromCart(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Book Cart')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                GestureDetector(
                  child: Container(
                    width: 200,
                    height: 200,
                    color: Colors.grey[300],
                    child: Image.asset('images/logolibrary.png', fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to IssuePage without adding book automatically
                    _addBookToCart();

                  },
                  child: const Text('Add Book'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Add your logic here to navigate to Update Book page
                  },
                  child: const Text('Update Book'),
                ),
              ],
            ),
            const SizedBox(width: 20),
            const VerticalDivider(thickness: 4, width: 1),
            const SizedBox(width: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text('Cart', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartManager.cartItems.length,
                        itemBuilder: (context, index) {
                          return CartItem(
                            number: (index + 1).toString(),
                            author: cartManager.cartItems[index]['author']!,
                            title: cartManager.cartItems[index]['title']!,
                            edition: cartManager.cartItems[index]['edition']!,
                            quantity: cartManager.cartItems[index]['quantity']!,
                            description: cartManager.cartItems[index]['description']!,
                            onDelete: () => _removeItem(index),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const VerticalDivider(thickness: 4, width: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text('Student info', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 10),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'CNIC',
                        border: OutlineInputBorder(),
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Mobile',
                        border: OutlineInputBorder(),
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const HomePage()),
                          );
                        },
                        child: const Text('Issue'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartItem extends StatelessWidget {
  final String number;
  final String author;
  final String title;
  final String edition;
  final String quantity;
  final String description;
  final VoidCallback onDelete;

  const CartItem({
    super.key,
    required this.number,
    required this.author,
    required this.title,
    required this.edition,
    required this.quantity,
    required this.description,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Expanded(child: Text(number)),
          Expanded(child: Text(author)),
          Expanded(child: Text(title)),
          Expanded(child: Text(edition)),
          Expanded(child: Text(quantity)),
          Expanded(child: Text(description)),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
