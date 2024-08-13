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
      home: ReturnBookPage(),
    );
  }
}

class ReturnBookPage extends StatefulWidget {
  const ReturnBookPage({super.key});

  @override
  State<ReturnBookPage> createState() => _ReturnBookPageState();
}

class _ReturnBookPageState extends State<ReturnBookPage> {
  final TextEditingController _cnicController = TextEditingController();
  bool _showDetails = false;

  // List of issued books
  List<Map<String, String>> issuedBooks = [
    {
      'Book ID': '1',
      'Title': 'Flutter for Beginners',
      'Author': 'John Doe',
      'Issue Date': '2023-01-01'
    },
    {
      'Book ID': '2',
      'Title': 'Advanced Dart',
      'Author': 'Jane Doe',
      'Issue Date': '2023-01-15'
    },
    {
      'Book ID': '3',
      'Title': 'Learning Dart',
      'Author': 'Jane Doe',
      'Issue Date': '2023-01-15'
    },
  ];

  // Function to show the return dialog
  void _showReturnDialog(Map<String, String> book) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Return Book'),
          content: Text('Are you sure you want to return "${book['Title']}"?'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  issuedBooks.remove(book);
                });
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Return Book'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Centered CNIC Search Bar

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: SizedBox(
                width: 300,
                child: Center(
                  child: TextField(
                    controller: _cnicController,
                    decoration: InputDecoration(
                      labelText: 'CNIC',
                      border: const OutlineInputBorder(),
                      filled: true,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          setState(() {
                            _showDetails = true;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Divider(thickness: 2, height: 20),
            if (_showDetails)
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection:
                      Axis.horizontal, // Handle horizontal overflow
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const VerticalDivider(
                          thickness: 4, width: 1, color: Colors.black),
                      const SizedBox(width: 20),
                      // CNIC Details Column
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'CNIC Details',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                                height:
                                    8.0), // Spacing between heading and table
                            SizedBox(
                              width: 400, // Adjust width as necessary
                              child: DataTable(
                                columns: const [
                                  DataColumn(label: Text('CNIC')),
                                  DataColumn(label: Text('Name')),
                                  DataColumn(label: Text('Mobile Number')),
                                ],
                                rows: [
                                  DataRow(
                                    cells: [
                                      DataCell(Text(_cnicController.text)),
                                      const DataCell(Text('John Doe')),
                                      const DataCell(Text('123-456-7890')),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const VerticalDivider(
                        thickness: 4,
                        width: 40, // Divider width
                      ),
                      // Issued Books Column
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Issued Books',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                                height:
                                    8.0), // Spacing between heading and table
                            SizedBox(
                              width: 600, // Adjust width as necessary
                              child: DataTable(
                                columns: const [
                                  DataColumn(label: Text('BooK_Id')),
                                  DataColumn(label: Text('Title')),
                                  DataColumn(label: Text('Author')),
                                  DataColumn(label: Text('Issue Date')),
                                  DataColumn(label: Text('Action')),
                                ],
                                // Generating rows for issued books
                                rows: issuedBooks.map((book) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(book['Book ID']!)),
                                      DataCell(Text(book['Title']!)),
                                      DataCell(Text(book['Author']!)),
                                      DataCell(Text(book['Issue Date']!)),
                                      DataCell(
                                        ElevatedButton(
                                          onPressed: () {
                                            _showReturnDialog(book);
                                          },
                                          child: const Text('Return'),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
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
