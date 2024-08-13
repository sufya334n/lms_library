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
      home: RecordPage(),
    );
  }
}

class RecordPage extends StatefulWidget {
  const RecordPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  final PageController _pageController = PageController();
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, String>> _students = [
    {'cnic': '1234567890', 'name': 'John Doe'},
    {'cnic': '0987654321', 'name': 'Jane Smith'},
    {'cnic': '111122223333', 'name': 'Alice Johnson'},
    {'cnic': '444455556666', 'name': 'Bob Brown'},
    {'cnic': '777788889999', 'name': 'Charlie Davis'},
    {'cnic': '000011112222', 'name': 'Diana Evans'},
    {'cnic': '333344445555', 'name': 'Evan Frank'},
    {'cnic': '666677778888', 'name': 'Fiona Green'},
    {'cnic': '999900001111', 'name': 'George Harris'},
    {'cnic': '222233334444', 'name': 'Hannah Ivy'},
  ];

  final List<Map<String, String>> _books = [
    {
      'bookId': '1',
      'title': 'Flutter for Beginners',
      'author': 'John Doe',
      'issueDate': '2023-01-01',
      'returnDate': '2023-02-01',
      'studentCnic': '1234567890'
    },
    {
      'bookId': '2',
      'title': 'Flutter for Beginners',
      'author': 'Jane Doe',
      'issueDate': '2023-01-15',
      'returnDate': '2023-03-01',
      'studentCnic': '1234567890'
    },
    {
      'bookId': '3',
      'title': 'Effective Java',
      'author': 'Joshua Bloch',
      'issueDate': '2023-02-01',
      'returnDate': '2023-04-01',
      'studentCnic': '111122223333'
    },
    {
      'bookId': '4',
      'title': 'Clean Code',
      'author': 'Robert C. Martin',
      'issueDate': '2023-02-15',
      'returnDate': '2023-05-01',
      'studentCnic': '444455556666'
    },
    {
      'bookId': '5',
      'title': 'Design Patterns',
      'author': 'Erich Gamma',
      'issueDate': '2023-03-01',
      'returnDate': '2023-05-15',
      'studentCnic': '777788889999'
    },
    {
      'bookId': '6',
      'title': 'Refactoring',
      'author': 'Martin Fowler',
      'issueDate': '2023-03-15',
      'returnDate': '2023-06-01',
      'studentCnic': '000011112222'
    },
    {
      'bookId': '7',
      'title': 'The Pragmatic Programmer',
      'author': 'Andrew Hunt',
      'issueDate': '2023-04-01',
      'returnDate': '2023-06-15',
      'studentCnic': '333344445555'
    },
    {
      'bookId': '8',
      'title': 'Introduction to Algorithms',
      'author': 'Thomas H. Cormen',
      'issueDate': '2023-04-15',
      'returnDate': '2023-07-01',
      'studentCnic': '666677778888'
    },
    {
      'bookId': '9',
      'title': 'Artificial Intelligence',
      'author': 'Stuart Russell',
      'issueDate': '2023-05-01',
      'returnDate': '2023-07-15',
      'studentCnic': '999900001111'
    },
    {
      'bookId': '10',
      'title': 'Computer Networks',
      'author': 'Andrew S. Tanenbaum',
      'issueDate': '2023-05-15',
      'returnDate': '2023-08-01',
      'studentCnic': '222233334444'
    },
    // Additional books for testing multiple book issuance
    {
      'bookId': '11',
      'title': 'Data Structures',
      'author': 'Mark Allen Weiss',
      'issueDate': '2023-05-20',
      'returnDate': '2023-08-10',
      'studentCnic': '1234567890'
    },
    {
      'bookId': '12',
      'title': 'Operating Systems',
      'author': 'Abraham Silberschatz',
      'issueDate': '2023-06-01',
      'returnDate': '2023-09-01',
      'studentCnic': '1234567890'
    },
  ];

  List<Map<String, String>> _filteredStudents = [];
  Map<String, dynamic>? _selectedStudent;
  List<Map<String, String>> _studentBooks = [];

  @override
  void initState() {
    super.initState();
    _filteredStudents = _students;
  }

  void _navigateToPage(int pageIndex) {
    _pageController.jumpToPage(pageIndex);
  }

  void _filterStudents(String query) {
    setState(() {
      _filteredStudents = _students
          .where((student) =>
              student['cnic']!.contains(query) ||
              student['name']!.contains(query))
          .toList();
    });
  }

  void _selectStudent(Map<String, dynamic> student) {
    setState(() {
      _selectedStudent = student;
      _studentBooks = _books
          .where((book) => book['studentCnic'] == student['cnic'])
          .toList();
    });
  }

  void _reloadStudents() {
    setState(() {
      _filteredStudents = _students;
      _searchController.clear();
      _selectedStudent = null;
      _studentBooks = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Record Page'),
        ),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 200,
                height: 200,
                color: Colors.grey[300],
                child: Image.asset('images/logolibrary.png', fit: BoxFit.cover),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _navigateToPage(0),
                child: const Text('Students'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _navigateToPage(1),
                child: const Text('Issued Book Details'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _navigateToPage(2),
                child: const Text('Add Book Detail'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 4, width: 1),
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 300,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                labelText: 'Search by CNIC or Name',
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.search),
                                  onPressed: () {
                                    _filterStudents(_searchController.text);
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: _reloadStudents,
                        ),
                      ],
                    ),
                    const Divider(thickness: 2),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Container(
                                width: double.infinity, // Full width
                                padding: const EdgeInsets.all(
                                    26.0), // Padding for space around the table
                                child: DataTable(
                                  columnSpacing: 4, // Spacing between columns
                                  columns: const [
                                    DataColumn(label: Text('CNIC')),
                                    DataColumn(label: Text('Name')),
                                  ],
                                  rows: _filteredStudents.map((student) {
                                    return DataRow(
                                      cells: [
                                        DataCell(
                                          Text(student['cnic']!),
                                          onTap: () {
                                            _selectStudent(student);
                                          },
                                        ),
                                        DataCell(
                                          Text(student['name']!),
                                          onTap: () {
                                            _selectStudent(student);
                                          },
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (_selectedStudent != null) ...[
                                    const Center(
                                      child: Text(
                                        'CNIC Details',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity, // Full width
                                      padding: const EdgeInsets.all(
                                          26.0), // Padding for space around the table
                                      child: DataTable(
                                        columnSpacing:
                                            24, // Spacing between columns
                                        columns: const [
                                          DataColumn(label: Text('CNIC')),
                                          DataColumn(label: Text('Name')),
                                          DataColumn(
                                              label: Text('Mobile Number')),
                                        ],
                                        rows: [
                                          DataRow(
                                            cells: [
                                              DataCell(Text(
                                                  _selectedStudent!['cnic'])),
                                              DataCell(Text(
                                                  _selectedStudent!['name'])),
                                              const DataCell(
                                                  Text('123-456-7890')),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const VerticalDivider(
                                        thickness: 4, width: 1),
                                    const Center(
                                      child: Text(
                                        'Issued Books',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity, // Full width
                                      padding: const EdgeInsets.all(
                                          26.0), // Padding for space around the table
                                      child: DataTable(
                                        columnSpacing:
                                            24, // Spacing between columns
                                        columns: const [
                                          DataColumn(label: Text('B_ID')),
                                          DataColumn(label: Text('Title')),
                                          DataColumn(label: Text('Author')),
                                          DataColumn(label: Text('Issue Date')),
                                          DataColumn(
                                              label: Text('Return Date')),
                                        ],
                                        rows: _studentBooks.map((book) {
                                          return DataRow(
                                            cells: [
                                              DataCell(Text(book['bookId']!)),
                                              DataCell(Text(book['title']!)),
                                              DataCell(Text(book['author']!)),
                                              DataCell(
                                                  Text(book['issueDate']!)),
                                              DataCell(
                                                  Text(book['returnDate']!)),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                IssuedBooksDetailsPage(books: _books, students: _students),
                BooksDetailsPage(books: _books),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class IssuedBooksDetailsPage extends StatefulWidget {
  final List<Map<String, String>> books;
  final List<Map<String, String>> students;

  const IssuedBooksDetailsPage(
      {required this.books, required this.students, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _IssuedBooksDetailsPageState createState() => _IssuedBooksDetailsPageState();
}

class _IssuedBooksDetailsPageState extends State<IssuedBooksDetailsPage> {
  DateTimeRange? _dateRange;
  Map<String, List<Map<String, String>>> _bookDetails = {};

  @override
  void initState() {
    super.initState();
    _initializeBookDetails();
  }

  void _initializeBookDetails() {
    setState(() {
      _bookDetails = {};
      for (var book in widget.books) {
        final bookTitle = book['title']!;
        if (!_bookDetails.containsKey(bookTitle)) {
          _bookDetails[bookTitle] = [];
        }
        _bookDetails[bookTitle]!.add(book);
      }
    });
  }

  void _filterBooksByDate() {
    if (_dateRange == null) return;

    final filteredBooks = <String, List<Map<String, String>>>{};

    for (var bookTitle in _bookDetails.keys) {
      filteredBooks[bookTitle] = _bookDetails[bookTitle]!.where((book) {
        final issueDate = DateTime.parse(book['issueDate']!);
        return issueDate
                .isAfter(_dateRange!.start.subtract(const Duration(days: 1))) &&
            issueDate.isBefore(_dateRange!.end.add(const Duration(days: 1)));
      }).toList();
    }

    setState(() {
      _bookDetails = filteredBooks;
    });
  }

  void _resetFilters() {
    setState(() {
      _dateRange = null;
      _initializeBookDetails();
    });
  }

  Widget _buildDateSelector(BuildContext context) {
    return IconButton(
      icon: Container(
        width: 40,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.calendar_today),
      ),
      onPressed: () async {
        final DateTimeRange? picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
          initialDateRange: _dateRange,
          builder: (context, child) {
            return Theme(
              data: ThemeData.light().copyWith(
                primaryColor: Colors.blue,
                buttonTheme:
                    ButtonThemeData(textTheme: ButtonTextTheme.primary),
              ),
              child: child!,
            );
          },
        );
        if (picked != null && picked != _dateRange) {
          setState(() {
            _dateRange = picked;
          });
          _filterBooksByDate();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Issued Books Details'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetFilters,
          ),
          _buildDateSelector(context),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: _bookDetails.entries
                    .where((entry) => entry.value.isNotEmpty)
                    .map((entry) {
                  final bookTitle = entry.key;
                  final bookList = entry.value;
                  final issueCount = bookList.length;

                  return ExpansionTile(
                    title: Text('$bookTitle (Issued: $issueCount times)'),
                    children: bookList.map((book) {
                      final student = widget.students.firstWhere(
                        (student) => student['cnic'] == book['studentCnic'],
                        orElse: () => {'cnic': 'Unknown', 'name': 'Unknown'},
                      );
                      return ListTile(
                        title: Text(
                            'Issue Date: ${book['issueDate']}  and  Return Date: ${book['returnDate']} '),
                        subtitle: Text(
                            'Student: ${student['name']} (${student['cnic']})'),
                      );
                    }).toList(),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BooksDetailsPage extends StatefulWidget {
  final List<Map<String, dynamic>> books;

  const BooksDetailsPage({required this.books, Key? key}) : super(key: key);

  @override
  _BooksDetailsPageState createState() => _BooksDetailsPageState();
}

class _BooksDetailsPageState extends State<BooksDetailsPage> {
  DateTimeRange? _dateRange;
  String? _filterSource;
  int? _minPrice;
  int? _maxPrice;
  bool? _filterBinding;

  @override
  void initState() {
    super.initState();
    _initializeFilters();
  }

  void _initializeFilters() {
    setState(() {
      _dateRange = null;
      _filterSource = null;
      _minPrice = null;
      _maxPrice = null;
      _filterBinding = null;
    });
  }

  void _applyFilters() {
    setState(() {});
  }

  Widget _buildDateSelector(BuildContext context) {
    return IconButton(
      icon: Container(
        width: 40,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.calendar_today),
      ),
      onPressed: () async {
        final DateTimeRange? picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
          initialDateRange: _dateRange,
          builder: (context, child) {
            return Theme(
              data: ThemeData.light().copyWith(
                primaryColor: Colors.blue,
                buttonTheme:
                    ButtonThemeData(textTheme: ButtonTextTheme.primary),
              ),
              child: child!,
            );
          },
        );
        if (picked != null && picked != _dateRange) {
          setState(() {
            _dateRange = picked;
          });
          _applyFilters();
        }
      },
    );
  }

  void _resetFilters() {
    _initializeFilters();
    _applyFilters();
  }

  Widget _buildFilterIcons() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _resetFilters,
        ),
        _buildDateSelector(context),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () async {
            final result = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Filter Books'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<String>(
                        value: _filterSource,
                        decoration: const InputDecoration(labelText: 'Source'),
                        items: ['Donation', 'Cash']
                            .map((source) => DropdownMenuItem(
                                  value: source,
                                  child: Text(source),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _filterSource = value;
                          });
                        },
                      ),
                      if (_filterSource == 'Cash') ...[
                        TextField(
                          decoration:
                              const InputDecoration(labelText: 'Min Price'),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              _minPrice = int.tryParse(value);
                            });
                          },
                        ),
                        TextField(
                          decoration:
                              const InputDecoration(labelText: 'Max Price'),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              _maxPrice = int.tryParse(value);
                            });
                          },
                        ),
                      ],
                      DropdownButtonFormField<bool>(
                        value: _filterBinding,
                        decoration: const InputDecoration(labelText: 'Binding'),
                        items: [
                          DropdownMenuItem(
                            value: true,
                            child: const Text('Yes'),
                          ),
                          DropdownMenuItem(
                            value: false,
                            child: const Text('No'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _filterBinding = value;
                          });
                        },
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _applyFilters();
                      },
                      child: const Text('Apply'),
                    ),
                  ],
                );
              },
            );

            if (result != null) {
              _applyFilters();
            }
          },
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getFilteredBooks() {
    return widget.books.where((book) {
      bool matches = true;

      if (_dateRange != null) {
        final addedDate = DateTime.parse(book['addedDate']);
        matches &= addedDate
                .isAfter(_dateRange!.start.subtract(const Duration(days: 1))) &&
            addedDate.isBefore(_dateRange!.end.add(const Duration(days: 1)));
      }

      if (_filterSource != null) {
        matches &= book['source'] == _filterSource;
        if (_filterSource == 'Cash' &&
            (_minPrice != null || _maxPrice != null)) {
          final price = book['price'];
          if (_minPrice != null) {
            matches &= price >= _minPrice!;
          }
          if (_maxPrice != null) {
            matches &= price <= _maxPrice!;
          }
        }
      }

      if (_filterBinding != null) {
        matches &= book['binding'] == (_filterBinding! ? 'Yes' : 'No');
      }

      return matches;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredBooks = _getFilteredBooks();

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Books Details'),
        ),
        actions: [
          _buildFilterIcons(),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredBooks.length,
        itemBuilder: (context, index) {
          final book = filteredBooks[index];
          return ListTile(
            title: Text('${book['title']} (ID: ${book['id']})'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Author: ${book['author']}'),
                Text('Source: ${book['source']}'),
                if (book['source'] == 'Cash') Text('Price: ${book['price']}'),
                Text('Pages: ${book['pages']}'),
                Text('Binding: ${book['binding']}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
