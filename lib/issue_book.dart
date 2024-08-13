import 'package:flutter/material.dart';

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
  // ignore: library_private_types_in_public_api
  _IssuePageState createState() => _IssuePageState();
}

class _IssuePageState extends State<IssuePage> {
  bool showBookDetails = false;

  void _showDetails() {
    setState(() {
      showBookDetails = true;
    });
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
                  color: Colors.grey[300],
                  child:
                      Image.asset('images/logolibrary.png', fit: BoxFit.cover),
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
                            decoration: InputDecoration(
                              labelText: 'Book Association ID',
                              border: const OutlineInputBorder(),
                              filled: true,
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.search),
                                onPressed: _showDetails,
                              ),
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _showDetails,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.deepPurple.shade900, // background color
                          foregroundColor: Colors.white, // text color
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
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
                              Container(
                                width: 300,
                                height: 300,
                                color: Colors.grey[300],
                                child: Image.asset('mnt/data/booktoselect.jpg',
                                    fit: BoxFit.cover),
                              ),
                              const SizedBox(width: 20),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Book Page',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 10),
                                  Text('Title: C++'),
                                  Text('Author: Author Name'),
                                  Text('Edition: 1st'),
                                  Text('Quantity: 10'),
                                  SizedBox(height: 20),
                                  Text('Description:'),
                                  Text('this is description\n'
                                      'this is description\n'
                                      'this is description'),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Issue button
                          Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigate to the next screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const AddtoCart(),
                                  ),
                                );
                              },
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
