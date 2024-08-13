import 'package:admin_dashboard_app/home_page.dart' show HomePage;
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AddtoCart(),
    );
  }
}

class AddtoCart extends StatelessWidget {
  const AddtoCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Book Cart'),
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
                GestureDetector(
                  // onTap: () {
                  //   // Navigate to another screen when image is clicked
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const AnotherScreen(
                  //               imagePath: 'images/logolibrary.png',
                  //             )),
                  //   );
                  // },
                  child: Container(
                    width: 200,
                    height: 200,
                    color: Colors.grey[300],
                    child: Image.asset('images/logolibrary.png',
                        fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 20),
                // Buttons below the image
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Add Book'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Update Book'),
                ),
              ],
            ),
            const SizedBox(width: 20),
            // Vertical divider
            const VerticalDivider(thickness: 4, width: 1),
            const SizedBox(width: 20),

            // Cart and Student Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cart title
                    const Center(
                      child: Text('Cart',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 10),
                    // Cart details

                    Expanded(
                      child: ListView(
                        children: const [
                          CartItem(
                              number: '1',
                              author: 'Author 1',
                              title: 'Title 1',
                              category: 'Category 1'),
                          CartItem(
                              number: '2',
                              author: 'Author 2',
                              title: 'Title 2',
                              category: 'Category 2'),
                          CartItem(
                              number: '3',
                              author: 'Author 3',
                              title: 'Title 3',
                              category: 'Category 3'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const VerticalDivider(thickness: 4, width: 20),
            // Student info

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text('Student info',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
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
                          // Navigate to the next screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()),
                          );
                        },
                        child: Text('Issue'),
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15)),
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
  final String category;

  const CartItem({
    super.key,
    required this.number,
    required this.author,
    required this.title,
    required this.category,
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
          Expanded(child: Text(category)),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
