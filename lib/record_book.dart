import 'package:admin_dashboard_app/src/database/data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mysql1/mysql1.dart'; // Import the MySQL package

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
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  final PageController _pageController = PageController();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _students = [];
  List<Map<String, dynamic>> _books = [];
  List<Map<String, String>> _filteredStudents = [];
  Map<String, dynamic>? _selectedStudent;
  List<Map<String, dynamic>> _studentBooks = [];

  @override
  void initState() {
    super.initState();
    _fetchStudents();
    _fetchBooks();
  }
  Future<void> _fetchStudents() async {
    var db = Mysql();
    var conn = await db.getConnection();

    var results = await conn.query('SELECT student_id, cnic, student_name, phone_number FROM students');
    setState(() {
      _students = results
          .map((row) => {
        'studentId': row['student_id'].toString(),
        'cnic': row['cnic'].toString(),
        'name': row['student_name'].toString(),
        'mobile': row['phone_number']?.toString() ?? '', // Handle null mobile number
      })
          .toList();
      _filteredStudents = _students;
    });
    await conn.close();
  }

  Future<void> _fetchBooks() async {
    var db = Mysql();
    var conn = await db.getConnection();

    var results = await conn.query(
        'SELECT issue_details.issue_id, issue_details.association_id, books.title, authors.author_name, issue_details.issue_date, '
            'students.cnic AS student_cnic, return_details.return_date '
            'FROM issue_details '
            'JOIN associations ON issue_details.association_id = associations.association_id '
            'JOIN books ON associations.book_id = books.book_id '
            'JOIN authors ON books.author_id = authors.author_id '
            'JOIN students ON issue_details.student_id = students.student_id '
            'LEFT JOIN return_details ON issue_details.issue_id = return_details.issue_id'
    );

    setState(() {
      _books = results
          .map((row) => {
        'issueId': row['issue_id'].toString(),
        'associationId': row['association_id'].toString(),
        'title': row['title'].toString(),
        'author': row['author_name'].toString(),
        'issueDate': DateFormat('yyyy-MM-dd').format(row['issue_date']),
        'returnDate': row['return_date'] != null
            ? DateFormat('yyyy-MM-dd').format(row['return_date'])
            : 'Not Returned',
        'studentCnic': row['student_cnic'].toString(),
      })
          .toList();
    });
    await conn.close();
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
                color: Colors.white10,
                child: Image.asset('images/a.png', fit: BoxFit.cover),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _navigateToPage(0),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple.shade900,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 15),
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Students'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _navigateToPage(1),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple.shade900,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Issued Details'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _navigateToPage(2),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple.shade900,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Book Detail'),
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
                                width: double.infinity,
                                padding: const EdgeInsets.all(26.0),
                                child: DataTable(
                                  columnSpacing: 4,
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
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(26.0),
                                      child: DataTable(
                                        columnSpacing: 24,
                                        columns: const [
                                          DataColumn(label: Text('CNIC')),
                                          DataColumn(label: Text('Name')),
                                          DataColumn(label: Text('Mobile Number')),
                                        ],
                                        rows: [
                                          DataRow(
                                            cells: [
                                              DataCell(Text(_selectedStudent!['cnic'])),
                                              DataCell(Text(_selectedStudent!['name'])),
                                              DataCell(Text(_selectedStudent!['mobile']?? 'N/A')),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const VerticalDivider(thickness: 4, width: 1),
                                    const Center(
                                      child: Text(
                                        'Issued Books',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(26.0),
                                      child: DataTable(
                                        columnSpacing: 24,
                                        columns: const [
                                          DataColumn(label: Text('Book_ID')),
                                          DataColumn(label: Text('Title')),
                                          DataColumn(label: Text('Author')),
                                          DataColumn(label: Text('Issue Date')),
                                          DataColumn(label: Text('Return_Date')),
                                        ],
                                        rows: _studentBooks.map((book) {
                                          return DataRow(
                                            cells: [
                                              DataCell(Text(book['associationId']!)),
                                              DataCell(Text(book['title']!)),
                                              DataCell(Text(book['author']!)),
                                              DataCell(Text(book['issueDate']!)),
                                              DataCell(Text(book['returnDate']!)),
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
                IssuedBooksDetailsPage(),
                BooksDetailsPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

























// import 'package:admin_dashboard_app/src/database/data.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: RecordPage(),
//     );
//   }
// }
//
// class RecordPage extends StatefulWidget {
//   const RecordPage({super.key});
//
//   @override
//   // ignore: library_private_types_in_public_api
//   _RecordPageState createState() => _RecordPageState();
// }
//
// class _RecordPageState extends State<RecordPage> {
//   final PageController _pageController = PageController();
//   final TextEditingController _searchController = TextEditingController();
//   final List<Map<String, String>> _students = [
//     {'cnic': '1234567890', 'name': 'John Doe'},
//     {'cnic': '0987654321', 'name': 'Jane Smith'},
//     {'cnic': '111122223333', 'name': 'Alice Johnson'},
//     {'cnic': '444455556666', 'name': 'Bob Brown'},
//     {'cnic': '777788889999', 'name': 'Charlie Davis'},
//     {'cnic': '000011112222', 'name': 'Diana Evans'},
//     {'cnic': '333344445555', 'name': 'Evan Frank'},
//     {'cnic': '666677778888', 'name': 'Fiona Green'},
//     {'cnic': '999900001111', 'name': 'George Harris'},
//     {'cnic': '222233334444', 'name': 'Hannah Ivy'},
//   ];
//
//   final List<Map<String, String>> _books = [
//     {
//       'bookId': '1',
//       'title': 'Flutter for Beginners',
//       'author': 'John Doe',
//       'issueDate': '2023-01-01',
//       'returnDate': '2023-02-01',
//       'studentCnic': '1234567890'
//     },
//     {
//       'bookId': '2',
//       'title': 'Flutter for Beginners',
//       'author': 'Jane Doe',
//       'issueDate': '2023-01-15',
//       'returnDate': '2023-03-01',
//       'studentCnic': '1234567890'
//     },
//     {
//       'bookId': '3',
//       'title': 'Effective Java',
//       'author': 'Joshua Bloch',
//       'issueDate': '2023-02-01',
//       'returnDate': '2023-04-01',
//       'studentCnic': '111122223333'
//     },
//     {
//       'bookId': '4',
//       'title': 'Clean Code',
//       'author': 'Robert C. Martin',
//       'issueDate': '2023-02-15',
//       'returnDate': '2023-05-01',
//       'studentCnic': '444455556666'
//     },
//     {
//       'bookId': '5',
//       'title': 'Design Patterns',
//       'author': 'Erich Gamma',
//       'issueDate': '2023-03-01',
//       'returnDate': '2023-05-15',
//       'studentCnic': '777788889999'
//     },
//     {
//       'bookId': '6',
//       'title': 'Refactoring',
//       'author': 'Martin Fowler',
//       'issueDate': '2023-03-15',
//       'returnDate': '2023-06-01',
//       'studentCnic': '000011112222'
//     },
//     {
//       'bookId': '7',
//       'title': 'The Pragmatic Programmer',
//       'author': 'Andrew Hunt',
//       'issueDate': '2023-04-01',
//       'returnDate': '2023-06-15',
//       'studentCnic': '333344445555'
//     },
//     {
//       'bookId': '8',
//       'title': 'Introduction to Algorithms',
//       'author': 'Thomas H. Cormen',
//       'issueDate': '2023-04-15',
//       'returnDate': '2023-07-01',
//       'studentCnic': '666677778888'
//     },
//     {
//       'bookId': '9',
//       'title': 'Artificial Intelligence',
//       'author': 'Stuart Russell',
//       'issueDate': '2023-05-01',
//       'returnDate': '2023-07-15',
//       'studentCnic': '999900001111'
//     },
//     {
//       'bookId': '10',
//       'title': 'Computer Networks',
//       'author': 'Andrew S. Tanenbaum',
//       'issueDate': '2023-05-15',
//       'returnDate': '2023-08-01',
//       'studentCnic': '222233334444'
//     },
//     // Additional books for testing multiple book issuance
//     {
//       'bookId': '11',
//       'title': 'Data Structures',
//       'author': 'Mark Allen Weiss',
//       'issueDate': '2023-05-20',
//       'returnDate': '2023-08-10',
//       'studentCnic': '1234567890'
//     },
//     {
//       'bookId': '12',
//       'title': 'Operating Systems',
//       'author': 'Abraham Silberschatz',
//       'issueDate': '2023-06-01',
//       'returnDate': '2023-09-01',
//       'studentCnic': '1234567890'
//     },
//   ];
//
//   List<Map<String, String>> _filteredStudents = [];
//   Map<String, dynamic>? _selectedStudent;
//   List<Map<String, String>> _studentBooks = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _filteredStudents = _students;
//   }
//
//   void _navigateToPage(int pageIndex) {
//     _pageController.jumpToPage(pageIndex);
//   }
//
//   void _filterStudents(String query) {
//     setState(() {
//       _filteredStudents = _students
//           .where((student) =>
//               student['cnic']!.contains(query) ||
//               student['name']!.contains(query))
//           .toList();
//     });
//   }
//
//   void _selectStudent(Map<String, dynamic> student) {
//     setState(() {
//       _selectedStudent = student;
//       _studentBooks = _books
//           .where((book) => book['studentCnic'] == student['cnic'])
//           .toList();
//     });
//   }
//
//   void _reloadStudents() {
//     setState(() {
//       _filteredStudents = _students;
//       _searchController.clear();
//       _selectedStudent = null;
//       _studentBooks = [];
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Center(
//           child: Text('Record Page'),
//         ),
//       ),
//       body: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Column(
//             children: [
//               Container(
//                 width: 200,
//                 height: 200,
//                 color: Colors.grey[300],
//                 child: Image.asset('images/logolibrary.png', fit: BoxFit.cover),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () => _navigateToPage(0),
//                 child: const Text('Students'),
//               ),
//               const SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: () => _navigateToPage(1),
//                 child: const Text('Issued Book Details'),
//               ),
//               const SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: () => _navigateToPage(2),
//                 child: const Text('Add Book Detail'),
//               ),
//             ],
//           ),
//           const VerticalDivider(thickness: 4, width: 1),
//           Expanded(
//             child: PageView(
//               controller: _pageController,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         SizedBox(
//                           width: 300,
//                           child: Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: TextField(
//                               controller: _searchController,
//                               decoration: InputDecoration(
//                                 labelText: 'Search by CNIC or Name',
//                                 border: const OutlineInputBorder(),
//                                 suffixIcon: IconButton(
//                                   icon: const Icon(Icons.search),
//                                   onPressed: () {
//                                     _filterStudents(_searchController.text);
//                                   },
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.refresh),
//                           onPressed: _reloadStudents,
//                         ),
//                       ],
//                     ),
//                     const Divider(thickness: 2),
//                     Expanded(
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: SingleChildScrollView(
//                               child: Container(
//                                 width: double.infinity, // Full width
//                                 padding: const EdgeInsets.all(
//                                     26.0), // Padding for space around the table
//                                 child: DataTable(
//                                   columnSpacing: 4, // Spacing between columns
//                                   columns: const [
//                                     DataColumn(label: Text('CNIC')),
//                                     DataColumn(label: Text('Name')),
//                                   ],
//                                   rows: _filteredStudents.map((student) {
//                                     return DataRow(
//                                       cells: [
//                                         DataCell(
//                                           Text(student['cnic']!),
//                                           onTap: () {
//                                             _selectStudent(student);
//                                           },
//                                         ),
//                                         DataCell(
//                                           Text(student['name']!),
//                                           onTap: () {
//                                             _selectStudent(student);
//                                           },
//                                         ),
//                                       ],
//                                     );
//                                   }).toList(),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: SingleChildScrollView(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   if (_selectedStudent != null) ...[
//                                     const Center(
//                                       child: Text(
//                                         'CNIC Details',
//                                         style: TextStyle(
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     Container(
//                                       width: double.infinity, // Full width
//                                       padding: const EdgeInsets.all(
//                                           26.0), // Padding for space around the table
//                                       child: DataTable(
//                                         columnSpacing:
//                                             24, // Spacing between columns
//                                         columns: const [
//                                           DataColumn(label: Text('CNIC')),
//                                           DataColumn(label: Text('Name')),
//                                           DataColumn(
//                                               label: Text('Mobile Number')),
//                                         ],
//                                         rows: [
//                                           DataRow(
//                                             cells: [
//                                               DataCell(Text(
//                                                   _selectedStudent!['cnic'])),
//                                               DataCell(Text(
//                                                   _selectedStudent!['name'])),
//                                               const DataCell(
//                                                   Text('123-456-7890')),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     const VerticalDivider(
//                                         thickness: 4, width: 1),
//                                     const Center(
//                                       child: Text(
//                                         'Issued Books',
//                                         style: TextStyle(
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     Container(
//                                       width: double.infinity, // Full width
//                                       padding: const EdgeInsets.all(
//                                           26.0), // Padding for space around the table
//                                       child: DataTable(
//                                         columnSpacing:
//                                             24, // Spacing between columns
//                                         columns: const [
//                                           DataColumn(label: Text('B_ID')),
//                                           DataColumn(label: Text('Title')),
//                                           DataColumn(label: Text('Author')),
//                                           DataColumn(label: Text('Issue_Date')),
//                                           DataColumn(
//                                               label: Text('Return_Date')),
//                                         ],
//                                         rows: _studentBooks.map((book) {
//                                           return DataRow(
//                                             cells: [
//                                               DataCell(Text(book['bookId']!)),
//                                               DataCell(Text(book['title']!)),
//                                               DataCell(Text(book['author']!)),
//                                               DataCell(
//                                                   Text(book['issueDate']!)),
//                                               DataCell(
//                                                   Text(book['returnDate']!)),
//                                             ],
//                                           );
//                                         }).toList(),
//                                       ),
//                                     ),
//                                   ],
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 IssuedBooksDetailsPage(
//                     //books: _books, students: _students
//                 ),
//                 BooksDetailsPage(
//                     //books: _books
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



















//
// class IssuedBooksDetailsPage extends StatefulWidget {
//   const IssuedBooksDetailsPage({super.key});
//
//   @override
//   _IssuedBooksDetailsPageState createState() => _IssuedBooksDetailsPageState();
// }
//
// class _IssuedBooksDetailsPageState extends State<IssuedBooksDetailsPage> {
//   DateTimeRange? _dateRange;
//   Map<String, List<Map<String, String>>> _bookDetails = {};
//   List<Map<String, String>> _students = [];
//   List<Map<String, String>> _books = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchDataFromDatabase();
//   }
//
//   Future<void> _fetchDataFromDatabase() async {
//     var db = Mysql();
//     var conn = await db.getConnection();
//
//     var results = await conn.query('''
//       SELECT
//         i.issue_date, i.association_id, s.student_name, s.cnic, r.return_date
//       FROM
//         issue_details i
//       JOIN
//         students s ON i.student_id = s.student_id
//       LEFT JOIN
//         return_details r ON i.issue_id = r.issue_id
//     ''');
//
//     var students = <Map<String, String>>[];
//     var books = <Map<String, String>>[];
//
//     for (var row in results) {
//       var associationId = row['association_id'].toString();
//       var issueDate = row['issue_date'].toString();
//       var returnDate = row['return_date']?.toString() ?? 'N/A';
//       var studentCnic = row['cnic'].toString();
//       var studentName = row['student_name'].toString();
//
//       students.add({'cnic': studentCnic, 'name': studentName});
//       books.add({
//         'associationId': associationId,
//         'issueDate': issueDate,
//         'returnDate': returnDate,
//         'studentCnic': studentCnic,
//       });
//     }
//
//     setState(() {
//       _students = students;
//       _books = books;
//       _initializeBookDetails();
//     });
//
//     await conn.close();
//   }
//
//   void _initializeBookDetails() {
//     setState(() {
//       _bookDetails = {};
//       for (var book in _books) {
//         final bookTitle = 'Book ID: ${book['associationId']}'; // Using associationId as the title
//         if (!_bookDetails.containsKey(bookTitle)) {
//           _bookDetails[bookTitle] = [];
//         }
//         _bookDetails[bookTitle]!.add(book);
//       }
//     });
//   }
//
//   void _filterBooksByDate() {
//     if (_dateRange == null) return;
//
//     final filteredBooks = <String, List<Map<String, String>>>{};
//
//     for (var bookTitle in _bookDetails.keys) {
//       filteredBooks[bookTitle] = _bookDetails[bookTitle]!.where((book) {
//         final issueDate = DateTime.parse(book['issueDate']!);
//         return issueDate
//             .isAfter(_dateRange!.start.subtract(const Duration(days: 1))) &&
//             issueDate.isBefore(_dateRange!.end.add(const Duration(days: 1)));
//       }).toList();
//     }
//
//     setState(() {
//       _bookDetails = filteredBooks;
//     });
//   }
//
//   void _resetFilters() {
//     setState(() {
//       _dateRange = null;
//       _initializeBookDetails();
//     });
//   }
//
//   Widget _buildDateSelector(BuildContext context) {
//     return IconButton(
//       icon: Container(
//         width: 40,
//         height: 50,
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.black),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: const Icon(Icons.calendar_today),
//       ),
//       onPressed: () async {
//         final DateTimeRange? picked = await showDateRangePicker(
//           context: context,
//           firstDate: DateTime(2000),
//           lastDate: DateTime.now(),
//           initialDateRange: _dateRange,
//           builder: (context, child) {
//             return Theme(
//               data: ThemeData.light().copyWith(
//                 primaryColor: Colors.blue,
//                 buttonTheme:
//                 ButtonThemeData(textTheme: ButtonTextTheme.primary),
//               ),
//               child: child!,
//             );
//           },
//         );
//         if (picked != null && picked != _dateRange) {
//           setState(() {
//             _dateRange = picked;
//           });
//           _filterBooksByDate();
//         }
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Center(
//           child: Text('Issued Books Details'),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: _resetFilters,
//           ),
//           _buildDateSelector(context),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: SingleChildScrollView(
//               child: Column(
//                 children: _bookDetails.entries
//                     .where((entry) => entry.value.isNotEmpty)
//                     .map((entry) {
//                   final bookTitle = entry.key;
//                   final bookList = entry.value;
//                   final issueCount = bookList.length;
//
//                   return ExpansionTile(
//                     title: Text('$bookTitle (Issued: $issueCount times)'),
//                     children: bookList.map((book) {
//                       final student = _students.firstWhere(
//                             (student) => student['cnic'] == book['studentCnic'],
//                         orElse: () => {'cnic': 'Unknown', 'name': 'Unknown'},
//                       );
//                       return ListTile(
//                         title: Text(
//                             'Issue Date: ${book['issueDate']}  and  Return Date: ${book['returnDate']} '),
//                         subtitle: Text(
//                             'Student: ${student['name']} (${student['cnic']})'),
//                       );
//                     }).toList(),
//                   );
//                 }).toList(),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//








class IssuedBooksDetailsPage extends StatefulWidget {
  const IssuedBooksDetailsPage({super.key});

  @override
  _IssuedBooksDetailsPageState createState() => _IssuedBooksDetailsPageState();
}

class _IssuedBooksDetailsPageState extends State<IssuedBooksDetailsPage> {
  DateTimeRange? _dateRange;
  Map<String, List<Map<String, String>>> _bookDetails = {};
  List<Map<String, String>> _students = [];
  List<Map<String, String>> _books = [];

  @override
  void initState() {
    super.initState();
    _fetchDataFromDatabase();
  }

  Future<void> _fetchDataFromDatabase() async {
    var db = Mysql();
    var conn = await db.getConnection();

    var results = await conn.query('''
      SELECT 
        i.issue_date, b.title, s.student_name, s.cnic, r.return_date
      FROM 
        issue_details i
      JOIN 
        students s ON i.student_id = s.student_id
      JOIN 
        books b ON i.association_id = b.book_id
      LEFT JOIN 
        return_details r ON i.issue_id = r.issue_id
    ''');

    var students = <Map<String, String>>[];
    var books = <Map<String, String>>[];

    for (var row in results) {
      var bookTitle = row['title'].toString();
      var issueDate = row['issue_date'].toString();
      var returnDate = row['return_date']?.toString() ?? 'N/A';
      var studentCnic = row['cnic'].toString();
      var studentName = row['student_name'].toString();

      students.add({'cnic': studentCnic, 'name': studentName});
      books.add({
        'bookTitle': bookTitle,
        'issueDate': issueDate,
        'returnDate': returnDate,
        'studentCnic': studentCnic,
      });
    }

    setState(() {
      _students = students;
      _books = books;
      _initializeBookDetails();
    });

    await conn.close();
  }

  void _initializeBookDetails() {
    setState(() {
      _bookDetails = {};
      for (var book in _books) {
        final bookTitle = book['bookTitle']!;
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
                      final student = _students.firstWhere(
                            (student) => student['cnic'] == book['studentCnic'],
                        orElse: () => {'cnic': 'Unknown', 'name': 'Unknown'},
                      );
                      return ListTile(
                        title: Text(
                          'Issue Date: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(book['issueDate']!))}  and  Return Date: ${book['returnDate'] == 'N/A' ? 'N/A' : DateFormat('yyyy-MM-dd').format(DateTime.parse(book['returnDate']!))}',
                        ),
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












//
// class BooksDetailsPage extends StatefulWidget {
//   final List<Map<String, dynamic>> books;
//
//   const BooksDetailsPage({required this.books, Key? key}) : super(key: key);
//
//   @override
//   _BooksDetailsPageState createState() => _BooksDetailsPageState();
// }
//
//
//
//
//
//
//
// class _BooksDetailsPageState extends State<BooksDetailsPage> {
//   DateTimeRange? _dateRange;
//   String? _filterSource;
//   int? _minPrice;
//   int? _maxPrice;
//   bool? _filterBinding;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeFilters();
//   }
//
//   void _initializeFilters() {
//     setState(() {
//       _dateRange = null;
//       _filterSource = null;
//       _minPrice = null;
//       _maxPrice = null;
//       _filterBinding = null;
//     });
//   }
//
//   void _applyFilters() {
//     setState(() {});
//   }
//
//   Widget _buildDateSelector(BuildContext context) {
//     return IconButton(
//       icon: Container(
//         width: 40,
//         height: 50,
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.black),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: const Icon(Icons.calendar_today),
//       ),
//       onPressed: () async {
//         final DateTimeRange? picked = await showDateRangePicker(
//           context: context,
//           firstDate: DateTime(2000),
//           lastDate: DateTime.now(),
//           initialDateRange: _dateRange,
//           builder: (context, child) {
//             return Theme(
//               data: ThemeData.light().copyWith(
//                 primaryColor: Colors.blue,
//                 buttonTheme:
//                     ButtonThemeData(textTheme: ButtonTextTheme.primary),
//               ),
//               child: child!,
//             );
//           },
//         );
//         if (picked != null && picked != _dateRange) {
//           setState(() {
//             _dateRange = picked;
//           });
//           _applyFilters();
//         }
//       },
//     );
//   }
//
//   void _resetFilters() {
//     _initializeFilters();
//     _applyFilters();
//   }
//
//   Widget _buildFilterIcons() {
//     return Row(
//       children: [
//         IconButton(
//           icon: const Icon(Icons.refresh),
//           onPressed: _resetFilters,
//         ),
//         _buildDateSelector(context),
//         IconButton(
//           icon: const Icon(Icons.search),
//           onPressed: () async {
//             final result = await showDialog(
//               context: context,
//               builder: (BuildContext context) {
//                 return AlertDialog(
//                   title: const Text('Filter Books'),
//                   content: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       DropdownButtonFormField<String>(
//                         value: _filterSource,
//                         decoration: const InputDecoration(labelText: 'Source'),
//                         items: ['Donation', 'Cash']
//                             .map((source) => DropdownMenuItem(
//                                   value: source,
//                                   child: Text(source),
//                                 ))
//                             .toList(),
//                         onChanged: (value) {
//                           setState(() {
//                             _filterSource = value;
//                           });
//                         },
//                       ),
//                       if (_filterSource == 'Cash') ...[
//                         TextField(
//                           decoration:
//                               const InputDecoration(labelText: 'Min Price'),
//                           keyboardType: TextInputType.number,
//                           onChanged: (value) {
//                             setState(() {
//                               _minPrice = int.tryParse(value);
//                             });
//                           },
//                         ),
//                         TextField(
//                           decoration:
//                               const InputDecoration(labelText: 'Max Price'),
//                           keyboardType: TextInputType.number,
//                           onChanged: (value) {
//                             setState(() {
//                               _maxPrice = int.tryParse(value);
//                             });
//                           },
//                         ),
//                       ],
//                       DropdownButtonFormField<bool>(
//                         value: _filterBinding,
//                         decoration: const InputDecoration(labelText: 'Binding'),
//                         items: [
//                           DropdownMenuItem(
//                             value: true,
//                             child: const Text('Yes'),
//                           ),
//                           DropdownMenuItem(
//                             value: false,
//                             child: const Text('No'),
//                           ),
//                         ],
//                         onChanged: (value) {
//                           setState(() {
//                             _filterBinding = value;
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                   actions: [
//                     TextButton(
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                       child: const Text('Cancel'),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                         _applyFilters();
//                       },
//                       child: const Text('Apply'),
//                     ),
//                   ],
//                 );
//               },
//             );
//
//             if (result != null) {
//               _applyFilters();
//             }
//           },
//         ),
//       ],
//     );
//   }
//
//   List<Map<String, dynamic>> _getFilteredBooks() {
//     return widget.books.where((book) {
//       bool matches = true;
//
//       if (_dateRange != null) {
//         final addedDate = DateTime.parse(book['addedDate']);
//         matches &= addedDate
//                 .isAfter(_dateRange!.start.subtract(const Duration(days: 1))) &&
//             addedDate.isBefore(_dateRange!.end.add(const Duration(days: 1)));
//       }
//
//       if (_filterSource != null) {
//         matches &= book['source'] == _filterSource;
//         if (_filterSource == 'Cash' &&
//             (_minPrice != null || _maxPrice != null)) {
//           final price = book['price'];
//           if (_minPrice != null) {
//             matches &= price >= _minPrice!;
//           }
//           if (_maxPrice != null) {
//             matches &= price <= _maxPrice!;
//           }
//         }
//       }
//
//       if (_filterBinding != null) {
//         matches &= book['binding'] == (_filterBinding! ? 'Yes' : 'No');
//       }
//
//       return matches;
//     }).toList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final filteredBooks = _getFilteredBooks();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Center(
//           child: Text('Books Details'),
//         ),
//         actions: [
//           _buildFilterIcons(),
//         ],
//       ),
//       body: ListView.builder(
//         itemCount: filteredBooks.length,
//         itemBuilder: (context, index) {
//           final book = filteredBooks[index];
//           return ListTile(
//             title: Text('${book['title']} (ID: ${book['id']})'),
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Author: ${book['author']}'),
//                 Text('Source: ${book['source']}'),
//                 if (book['source'] == 'Cash') Text('Price: ${book['price']}'),
//                 Text('Pages: ${book['pages']}'),
//                 Text('Binding: ${book['binding']}'),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }




class BooksDetailsPage extends StatefulWidget {
  const BooksDetailsPage({Key? key}) : super(key: key);

  @override
  _BooksDetailsPageState createState() => _BooksDetailsPageState();
}

class _BooksDetailsPageState extends State<BooksDetailsPage> {
  DateTimeRange? _dateRange;
  String? _filterSource;
  int? _minPrice;
  int? _maxPrice;
  bool? _filterBinding;
  List<Map<String, dynamic>> _books = [];

  @override
  void initState() {
    super.initState();
    _initializeFilters();
    _fetchBooksData(); // Fetch data from database
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

  Future<void> _fetchBooksData() async {
    // Your MySQL connection settings
    var db = Mysql();
    var conn = await db.getConnection();

    try {
      // Query to join books and authors table
      final results = await conn.query('''
        SELECT 
          books.book_id, books.title, books.edition, books.isbn, books.publish_year, 
          books.publish_place, books.image, books.shelf, books.classification_number, 
          books.classification_name, books.category, books.volume, books.quantity, 
          books.pages, books.source, books.price, books.binding, books.description, 
          authors.author_name, authors.author_code 
        FROM books 
        JOIN authors ON books.author_id = authors.author_id
      ''');

      List<Map<String, dynamic>> booksData = [];

      for (var row in results) {
        booksData.add({
          'book_id': row['book_id'],
          'title': row['title'],
          'edition': row['edition'],
          'isbn': row['isbn'],
          'publish_year': row['publish_year'],
          'publish_place': row['publish_place'],
          'image': row['image'],
          'shelf': row['shelf'],
          'classification_number': row['classification_number'],
          'classification_name': row['classification_name'],
          'category': row['category'],
          'volume': row['volume'],
          'quantity': row['quantity'],
          'pages': row['pages'],
          'source': row['source'],
          'price': row['price'],
          'binding': row['binding'],
          'description': row['description'],
          'author_name': row['author_name'],
          'author_code': row['author_code'],
        });
      }

      setState(() {
        _books = booksData;
      });
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      await conn.close();
    }
  }

  void _applyFilters() {
    setState(() {});
  }

  void _resetFilters() {
    _initializeFilters();
    _applyFilters();
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

  Future<void> _showFilterDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter Books'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: _filterSource,
                  decoration: const InputDecoration(labelText: 'Source'),
                  items: ['donation', 'cash'] // Replace with actual sources
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
                if (_filterSource == 'cash') ...[
                  TextField(
                    decoration: const InputDecoration(labelText: 'Min Price'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _minPrice = int.tryParse(value);
                      });
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Max Price'),
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
                      child: const Text('hb'),
                    ),
                    DropdownMenuItem(
                      value: false,
                      child: const Text('pb'),
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
  }

  List<Map<String, dynamic>> _getFilteredBooks() {
    return _books.where((book) {
      bool matches = true;

      if (_dateRange != null) {
        // Assuming publish_year is a year like 2020 or 2021
        final publishYear = int.tryParse(book['publish_year'].toString());

        if (publishYear != null) {
          // Create a DateTime object using the publish year
          final addedDate = DateTime(publishYear);

          matches &= addedDate.isAfter(
            _dateRange!.start.subtract(const Duration(days: 1)),
          ) &&
              addedDate.isBefore(
                _dateRange!.end.add(const Duration(days: 1)),
              );
        } else {
          matches = false; // If publishYear couldn't be parsed, exclude the book
        }
      }

      if (_filterSource != null) {
        matches &= book['source'] == _filterSource;
        if (_filterSource == 'cash' && (_minPrice != null || _maxPrice != null)) {
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
        matches &= book['binding'] == (_filterBinding! ? 'hb' : 'pb');
      }

      return matches;
    }).toList();
  }




  // List<Map<String, dynamic>> _getFilteredBooks() {
  //   return _books.where((book) {
  //     bool matches = true;
  //
  //     if (_dateRange != null) {
  //       final addedDate = DateTime.parse(book['publish_year'].toString());
  //       matches &= addedDate
  //           .isAfter(_dateRange!.start.subtract(const Duration(days: 1))) &&
  //           addedDate.isBefore(_dateRange!.end.add(const Duration(days: 1)));
  //     }
  //
  //     if (_filterSource != null) {
  //       matches &= book['source'] == _filterSource;
  //       if (_filterSource == 'cash' &&
  //           (_minPrice != null || _maxPrice != null)) {
  //         final price = book['price'];
  //         if (_minPrice != null) {
  //           matches &= price >= _minPrice!;
  //         }
  //         if (_maxPrice != null) {
  //           matches &= price <= _maxPrice!;
  //         }
  //       }
  //     }
  //
  //     if (_filterBinding != null) {
  //       matches &= book['binding'] == (_filterBinding! ? 'hb' : 'pb');
  //     }
  //
  //     return matches;
  //   }).toList();
  // }

  @override
  Widget build(BuildContext context) {
    final filteredBooks = _getFilteredBooks();

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Books Details'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetFilters,
          ),
          _buildDateSelector(context),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredBooks.length,
        itemBuilder: (context, index) {
          final book = filteredBooks[index];
          return ListTile(
            title: Text('${book['title']} '),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Author: ${book['author_name']} (${book['author_code']})'),
                Text('Edition: ${book['edition']}'),
                Text('Volume: ${book['volume']}'),
                Text('Quantity: ${book['quantity']}'),
                Text('Price: ${book['price']}'),
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
