import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:admin_dashboard_app/src/database/data.dart';
import 'package:mysql1/mysql1.dart';
import 'cart_manager.dart';
import 'add_to_cart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IssuePage(),
    );
  }
}

class IssuePage extends StatefulWidget {
  const IssuePage({super.key});

  @override
  _IssuePageState createState() => _IssuePageState();
}

class _IssuePageState extends State<IssuePage> {
  bool showBookDetails = false;
  final CartManager cartManager = CartManager();
  final db = Mysql();
  final TextEditingController bookAssociationIdController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController editionController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  File? _image;
  void _showDetails() {
    setState(() {
      showBookDetails = true;
    });
  }

  // Future<void> fetchBookDetails() async {
  //   if (bookAssociationIdController.text.isEmpty || !RegExp(r'^\d+$').hasMatch(bookAssociationIdController.text)) {
  //     showAlert("Please enter a valid numeric Book Association ID.");
  //     return;
  //   }
  //
  //   try {
  //     var conn = await db.getConnection();
  //
  //     String sqlQuery = '''
  //     SELECT
  //       bt.book_title,
  //       ba.Book_author_name,
  //       et.Book_Eddition,
  //       bv.Quantity,
  //       et.Description
  //     FROM book_association_table bat
  //     JOIN book_title bt ON bat.Book_title_id = bt.Book_title_id
  //     JOIN book_author ba ON bat.Book_author_id = ba.Book_author_id
  //     JOIN eddition_table et ON bat.Eddition_id = et.Eddition_id
  //     JOIN book_volume bv ON et.Eddition_id = bv.Eddition_id
  //     WHERE bat.Book_Association_id = ?
  //   ''';
  //
  //     var results = await conn.query(sqlQuery, [int.parse(bookAssociationIdController.text)]);
  //
  //     if (results.isNotEmpty) {
  //       var row = results.first;
  //       _showDetails();
  //
  //       titleController.text = row['book_title'].toString();
  //       authorController.text = row['Book_author_name'].toString();
  //       editionController.text = row['Book_Eddition'].toString();
  //       quantityController.text = row['Quantity'].toString();
  //       descriptionController.text = row['Description'].toString();
  //
  //       setState(() {});
  //     } else {
  //       showAlert("No book found with the given Book Association ID.");
  //     }
  //   } catch (e) {
  //     showAlert("An error occurred: $e");
  //   }
  // }
  Future<void> fetchBookDetails() async {
    if (bookAssociationIdController.text.isEmpty || !RegExp(r'^\d+$').hasMatch(bookAssociationIdController.text)) {
      if (mounted) showAlert("Please enter a valid numeric Book Association ID.");
      return;
    }

    try {
      var conn = await db.getConnection();

      String sqlQuery = '''
    SELECT b.title AS book_title, 
           a.author_name AS Book_author_name, 
           b.edition AS Book_Eddition, 
           b.quantity AS Quantity, 
           b.description AS Description,
           b.image AS book_image
    FROM associations AS ba
    JOIN books AS b ON ba.book_id = b.book_id
    JOIN authors AS a ON b.author_id = a.author_id
    WHERE ba.copy_number = ?
    ''';

      var results = await conn.query(sqlQuery, [int.parse(bookAssociationIdController.text)]);

      if (results.isNotEmpty) {
        var row = results.first;
        if (mounted) {
          _showDetails();
          titleController.text = row['book_title'].toString();
          authorController.text = row['Book_author_name'].toString();
          editionController.text = row['Book_Eddition'].toString();
          quantityController.text = row['Quantity'].toString();
          descriptionController.text = row['Description'].toString();

          // Convert the image Blob to an image file
          if (row['image'] != null) {
            Blob blob = row['image'];
            List<int> imageBytes = blob.toBytes();

            setState(() {
              _image = File.fromRawPath(Uint8List.fromList(imageBytes));
            });
          } else {
            setState(() {
              _image = null; // No image found
            });
          }
        }
      } else {
        if (mounted) showAlert("No book found with the given Book Association ID.");
      }
    } catch (e) {
      if (mounted) showAlert("An error occurred: $e");
    }
  }


  void showAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Alert"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void addToCart() {
    // Check if the cart already has 3 items
    if (cartManager.cartItems.length >= 3) {
      showAlert("You can only add up to 3 books to the cart.");
      return;
    }

    // Create a book map from the current book details
    final newBook = {
      'title': titleController.text,
      'author': authorController.text,
      'edition': editionController.text,
      'quantity': quantityController.text,
      'description': descriptionController.text,
    };

    // Check if the book is already in the cart
    bool isDuplicate = cartManager.cartItems.any((item) =>
    item['title'] == newBook['title'] &&
        item['author'] == newBook['author'] &&
        item['edition'] == newBook['edition']
    );

    if (isDuplicate) {
      showAlert("This book is already in the cart.");
    } else {
      // Add the current book details to the cart
      cartManager.cartItems.add(newBook);

      // Navigate to the AddtoCart page only after adding to cart
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddtoCart(
            bookTitle: titleController.text,
            author: authorController.text,
            edition: editionController.text,
            quantity: quantityController.text,
            description: descriptionController.text,
          ),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Issue Book'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sidebar with image and buttons
            Column(
              children: [
                // Clickable Image container
                Container(
                  width: 200,
                  height: 200,
                  color: Colors.white10,
                  child: Image.asset('images/issue.png', fit: BoxFit.cover),
                ),
                const SizedBox(height: 20),
                // Buttons below the image
                ElevatedButton(
                  onPressed: () {

                    // Navigate to Cart Page if needed

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddtoCart(bookTitle: '', author: '', edition: '', quantity: '', description: '',)),
                      );

                  },

                  style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple.shade900,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                  child: const Text('Cart Page'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade900,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('Update Book'),
                ),
              ],
            ),
            const SizedBox(width: 20),
            // Vertical divider
            const VerticalDivider(thickness: 4, width: 1),
            const SizedBox(width: 20),
            // Main content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Labels and text fields
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: TextField(
                            controller: bookAssociationIdController,
                            decoration: InputDecoration(
                              labelText: 'Book Association ID',
                              border: const OutlineInputBorder(),
                              filled: true,
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.search),
                                onPressed: fetchBookDetails,
                              ),
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: fetchBookDetails,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple.shade900,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text('Search'),
                      ),
                    ],
                  ),
                  const Divider(thickness: 4, height: 20),
                  // Conditionally show book details
                  if (showBookDetails)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image, title, author, edition, quantity, and description
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            // Declare a variable to hold the image

                              Container(
                                width: 200,
                                height: 200,
                                color: Colors.grey[300],
                                child: Image.asset('images/issue.png', fit: BoxFit.cover),
                              ),

                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Book Details',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 10),
                                    TextField(
                                      controller: titleController,
                                      decoration: const InputDecoration(
                                        labelText: 'Title',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    TextField(
                                      controller: authorController,
                                      decoration: const InputDecoration(
                                        labelText: 'Author',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    TextField(
                                      controller: editionController,
                                      decoration: const InputDecoration(
                                        labelText: 'Edition',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    TextField(
                                      controller: quantityController,
                                      decoration: const InputDecoration(
                                        labelText: 'Quantity',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    TextField(
                                      controller: descriptionController,
                                      decoration: const InputDecoration(
                                        labelText: 'Description',
                                        border: OutlineInputBorder(),
                                      ),
                                      maxLines: 3,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Issue button
                          Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              onPressed:(){ addToCart();
                              print('issue book.');
                              },
                                // Call the addToCart method
                              child: const Text('Add To Cart'),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
