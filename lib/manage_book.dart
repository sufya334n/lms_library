// ignore: file_names
import 'package:admin_dashboard_app/add_to_cart.dart';
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
      home: ManageBookPage(),
    );
  }
}

class ManageBookPage extends StatelessWidget {
  const ManageBookPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('SearchBook'),
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
                  const Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Classification Number',
                              border: OutlineInputBorder(),
                              filled: true,
                              suffixIcon: IconButton(
                                icon: Icon(Icons.search),
                                onPressed:
                                    null, // Add search functionality here
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Book Title',
                              border: OutlineInputBorder(),
                              filled: true,
                              suffixIcon: IconButton(
                                icon: Icon(Icons.search),
                                onPressed:
                                    null, // Add search functionality here
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Author Code',
                              border: OutlineInputBorder(),
                              filled: true,
                              suffixIcon: IconButton(
                                icon: Icon(Icons.search),
                                onPressed:
                                    null, // Add search functionality here
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(thickness: 4, height: 40),
                  // Table with data
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('ID')),
                            DataColumn(label: Text('Title')),
                            DataColumn(label: Text('Author')),
                            DataColumn(label: Text('Category')),
                            DataColumn(label: Text('Image')),
                          ],
                          rows: [
                            DataRow(cells: [
                              const DataCell(Text('1')),
                              const DataCell(Text('Book 1')),
                              const DataCell(Text('Author 1')),
                              const DataCell(Text('Category 1')),
                              DataCell(
                                GestureDetector(
                                  onTap: () {
                                    // Navigate to another screen when image is clicked
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AnotherScreen(
                                                imagePath: 'images/book1.png',
                                              )),
                                    );
                                  },
                                  child: Image.asset('images/book1.png',
                                      width: 20, height: 50),
                                ),
                              ),
                            ]),
                            DataRow(cells: [
                              const DataCell(Text('2')),
                              const DataCell(Text('Book 2')),
                              const DataCell(Text('Author 2')),
                              const DataCell(Text('Category 2')),
                              DataCell(
                                GestureDetector(
                                  onTap: () {
                                    // Navigate to another screen when image is clicked
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AnotherScreen(
                                                imagePath: 'images/book2.png',
                                              )),
                                    );
                                  },
                                  child: Image.asset('images/book2.png',
                                      width: 50, height: 50),
                                ),
                              ),
                            ]),
                          ],
                        ),
                      ),
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

class AnotherScreen extends StatelessWidget {
  final String imagePath;

  const AnotherScreen({super.key, required this.imagePath});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Book Description'),
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
            // Main content
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
                        height: 400,
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
                                  fontSize: 20, fontWeight: FontWeight.bold)),
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
                              builder: (context) => const AddtoCart()),
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
    );
  }
}
