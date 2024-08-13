import 'package:admin_dashboard_app/manage_book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'addbook.dart';
import 'issue_book.dart';
import 'record_book.dart';
import 'return_book.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const DashboardPage(),
    );
  }
}

enum DashboardItem {
  issueBook(value: 'Issue Book', iconData: Icons.book, body: IssuePage()),
  returnBook(
      value: 'Return Book', iconData: Icons.business, body: ReturnBookPage()),
  recordBook(
      value: 'Record Book', iconData: Icons.library_books, body: RecordPage()),
  //detailBook(
  //  value: 'Book Detail', iconData: Icons.book_online, body: Bookdetail()),
  addBook(value: 'Search Books', iconData: Icons.add, body: ManageBookPage()),
  settings(value: 'Add Books', iconData: Icons.settings, body: AddBook());

  const DashboardItem(
      {required this.value, required this.iconData, required this.body});
  final String value;
  final IconData iconData;
  final Widget body;
}

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Dashboard'),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6, // Number of squares per row
                childAspectRatio: 1, // Aspect ratio of the squares
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              padding: const EdgeInsets.only(
                  right: 50, top: 50, left: 50, bottom: 50),
              itemCount: DashboardItem.values.length,
              itemBuilder: (context, index) {
                final item = DashboardItem.values[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => item.body),
                    );
                  },
                  child: HoverContainer(
                    iconData: item.iconData,
                    label: item.value,
                    backgroundColor:
                        Colors.deepPurple.shade100, // Background color
                  ),
                );
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 11, // Number of squares per row
                childAspectRatio: 1, // Aspect ratio of the squares
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              padding: const EdgeInsets.only(
                  right: 50, top: 50, left: 50, bottom: 50),

              itemCount:
                  45, // Placeholder count for images, replace with actual count
              itemBuilder: (context, index) {
                // Replace with image fetching logic
                return HoverContainer(
                  iconData: Icons.image,
                  label: 'Image $index',
                  backgroundColor: Colors.grey[300]!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class HoverContainer extends StatefulWidget {
  final IconData iconData;
  final String label;
  final Color backgroundColor;

  const HoverContainer({
    required this.iconData,
    required this.label,
    required this.backgroundColor,
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HoverContainerState createState() => _HoverContainerState();
}

class _HoverContainerState extends State<HoverContainer> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                      color: Colors.deepPurple.shade800.withOpacity(.4),
                      blurRadius: 10)
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.iconData, size: 50, color: Colors.deepPurple),
            const SizedBox(height: 10),
            Text(
              widget.label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
