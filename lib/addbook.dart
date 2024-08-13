import 'package:admin_dashboard_app/src/database/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';


void main() {
  runApp(const AddBook());
}

class AddBook extends StatefulWidget {
  const AddBook({Key? key}) : super(key: key);

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  final db = Mysql();
  final classification_name = TextEditingController();
  final classification_number = TextEditingController();
  final book_title = TextEditingController();
  final book_author_code = TextEditingController();
  final book_author_name = TextEditingController();
  final book_edition = TextEditingController();
  final book_isbn = TextEditingController();
  final book_publishing_year = TextEditingController();
  final book_image = TextEditingController();
  final book_publishing_place = TextEditingController();
  final book_volume = TextEditingController();
  final book_quantity = TextEditingController();
  final book_page = TextEditingController();
  final book_source = TextEditingController();
  final book_price = TextEditingController();
  final book_binding = TextEditingController();
  final book_shelf = TextEditingController();
  final book_association_id = TextEditingController();

  var classificationId;
  var bookTitleId;
  var bookAuthorId;
  var bookedditionid;
  var bookvolumeid;
  var book_pageid;
  var book_associationid;
  var bookshelfid;

  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
  void _clearImage() {
    setState(() {
      _image = null;
    });
  }
  Future<void> table_classification() async {
    var conn = await db.getConnection();
    String sqlQuery = 'INSERT INTO book_classification(Book_Classification_Name, Book_Classification_Number) VALUES (?, ?)';
    var result = await conn.query(sqlQuery, [classification_name.text, classification_number.text]);
    classificationId = result.insertId;
    print("Data added to table_classification with ID: $classificationId");
  }

  Future<void> table_book_title() async {
    var conn = await db.getConnection();
    String sqlQuery = 'INSERT INTO book_title(book_title) VALUES (?)';
    var result = await conn.query(sqlQuery, [book_title.text]);
    bookTitleId = result.insertId; // Get the inserted ID
    print("Added to table_book_title with ID: $bookTitleId");
  }

  Future<void> table_book_author() async {
    var conn = await db.getConnection();
    String sqlQuery = 'INSERT INTO book_author(Book_author_code, Book_author_name, Book_title_id) VALUES (?,?,?)';
    var result = await conn.query(sqlQuery, [book_author_code.text, book_author_name.text, bookTitleId]);
    bookAuthorId = result.insertId;
    print('Added to table_book_author with ID: $bookAuthorId');
  }

  Future<void> table_book_edition() async {
    var conn = await db.getConnection();
    Uint8List? imageBytes;

    if (_image != null) {
      imageBytes = await _image!.readAsBytes();
    }
    String sqlQuery = 'INSERT INTO eddition_table(Book_Eddition, ISBN, Book_Publishing_year, BOOK_eddition_image, Book_Publishing_place, Book_author_id, Book_title_id) VALUES (?,?,?,?,?,?,?)';
    var result = await conn.query(sqlQuery, [book_edition.text, book_isbn.text, book_publishing_year.text, imageBytes, book_publishing_place.text, bookAuthorId, bookTitleId]);
    bookedditionid = result.insertId;
    setState(() {});
    print('Added to table_book_edition with ID: $bookedditionid');
  }





  Future<void> table_book_volume() async {
    var conn = await db.getConnection();
    String sqlQuery = 'INSERT INTO book_volume(Volume, Quantity, Eddition_id) VALUES (?,?,?)';
    var result = await conn.query(sqlQuery, [book_volume.text, book_quantity.text, bookedditionid]);
    bookvolumeid = result.insertId;
    setState(() {});
    print('Added to table_book_volume with ID: $bookvolumeid');
  }

  Future<void> table_book_page() async {
    var conn = await db.getConnection();
    String sqlQuery = 'INSERT INTO book_page_detail(Book_page, Book_source, Book_price, Book_binding, Book_Volume_id) VALUES (?,?,?,?,?)';
    var result = await conn.query(sqlQuery, [book_page.text, book_source.text, book_price.text, book_binding.text, bookvolumeid]);
    book_pageid = result.insertId;
    setState(() {});
    print('Added to table_book_page with ID: $book_pageid');
  }

  Future<void> table_book_shelf() async {
    var conn = await db.getConnection();
    String sqlQuery = 'INSERT INTO book_shelf(Book_Shelf_Number, Book_Classification_id) VALUES (?,?)';
    var result = await conn.query(sqlQuery, [book_shelf.text, classificationId]);
    bookshelfid = result.insertId;
    setState(() {});
    print('Added to table_book_shelf with ID: $bookshelfid');
  }

  Future<void> table_book_association() async {
    var conn = await db.getConnection();
    String sqlQuery = 'INSERT INTO book_association_table(Book_Association_id, Book_title_id, Book_Shelf_id, Eddition_id, Book_author_id, Book_Classification_id) VALUES (?,?,?,?,?,?)';
    var result = await conn.query(sqlQuery, [book_association_id.text, bookTitleId, bookshelfid, bookedditionid, bookAuthorId, classificationId]);
    book_associationid = result.insertId;
    setState(() {});
    print('Added to table_book_association with ID: $book_associationid');
  }

  Future<void> fetchBookDetails() async {
    if (book_association_id.text.isEmpty || !RegExp(r'^\d+$').hasMatch(book_association_id.text)) {
      showAlert("Please enter a valid numeric Book Association ID.");
      return;
    }

    try {
      var conn = await db.getConnection();

      String sqlQuery = '''
    SELECT bc.Book_Classification_Name, bc.Book_Classification_Number,
           bt.book_title, ba.Book_author_code, ba.Book_author_name,
           et.Book_Eddition, et.ISBN, et.Book_Publishing_year, et.BOOK_eddition_image, et.Book_Publishing_place,
           bv.Volume, bv.Quantity,
           bpd.Book_page, bpd.Book_source, bpd.Book_price, bpd.Book_binding,
           bs.Book_Shelf_Number
    FROM book_association_table bat
    JOIN book_classification bc ON bat.Book_Classification_id = bc.Book_Classification_id
    JOIN book_title bt ON bat.Book_title_id = bt.Book_title_id
    JOIN book_author ba ON bat.Book_author_id = ba.Book_author_id
    JOIN eddition_table et ON bat.Eddition_id = et.Eddition_id
    JOIN book_volume bv ON et.Eddition_id = bv.Eddition_id
    JOIN book_page_detail bpd ON bv.Book_Volume_id = bpd.Book_Volume_id
    JOIN book_shelf bs ON bat.Book_Shelf_id = bs.Book_Shelf_id
    WHERE bat.Book_Association_id = ?
  ''';

      var results = await conn.query(sqlQuery, [int.parse(book_association_id.text)]);

      if (results.isNotEmpty) {
        var row = results.first;

        classification_name.text = row['Book_Classification_Name'].toString();
        classification_number.text = row['Book_Classification_Number'].toString();
        book_title.text = row['book_title'].toString();
        book_author_code.text = row['Book_author_code'].toString();
        book_author_name.text = row['Book_author_name'].toString();
        book_edition.text = row['Book_Eddition'].toString();
        book_isbn.text = row['ISBN'].toString();
        book_publishing_year.text = row['Book_Publishing_year'].toString();
        book_publishing_place.text = row['Book_Publishing_place'].toString();
        book_volume.text = row['Volume'].toString();
        book_quantity.text = row['Quantity'].toString();
        book_page.text = row['Book_page'].toString();
        book_source.text = row['Book_source'].toString();
        book_price.text = row['Book_price'].toString();
        book_binding.text = row['Book_binding'].toString();
        book_shelf.text = row['Book_Shelf_Number'].toString();






        setState(() {});
      } else {
        showAlert("No book found with the given Book Association ID.");
      }
    } catch (e) {
      showAlert("An error occurred: $e");
    }
  }



  void showAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Alert"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void clearFields() {
    classification_name.clear();
    classification_number.clear();
    book_title.clear();
    book_author_code.clear();
    book_author_name.clear();
    book_edition.clear();
    book_isbn.clear();
    book_publishing_year.clear();
    book_image.clear();
    book_publishing_place.clear();
    book_volume.clear();
    book_quantity.clear();
    book_page.clear();
    book_source.clear();
    book_price.clear();
    book_binding.clear();
    book_shelf.clear();
    book_association_id.clear();
    _clearImage();
  }

  Future<void> addBook() async {
    if (classification_name.text.isEmpty ||
        classification_number.text.isEmpty ||
        book_title.text.isEmpty ||
        book_author_code.text.isEmpty ||
        book_author_name.text.isEmpty ||
        book_edition.text.isEmpty ||
        book_isbn.text.isEmpty ||
        book_publishing_year.text.isEmpty ||

        book_publishing_place.text.isEmpty ||
        book_volume.text.isEmpty ||
        book_quantity.text.isEmpty ||
        book_page.text.isEmpty ||
        book_source.text.isEmpty ||
        book_price.text.isEmpty ||
        book_binding.text.isEmpty ||
        book_shelf.text.isEmpty ||
        book_association_id.text.isEmpty) {
      showAlert("Please fill in all required fields.");
      return;
    }

    try {
      await table_classification();
      await table_book_title();
      await table_book_author();
      await table_book_edition();
      await table_book_volume();
      await table_book_page();
      await table_book_shelf();
      await table_book_association();

      showAlert("Data saved successfully.");
      clearFields();
    } catch (e) {
      showAlert("An error occurred while saving data: $e");
    }
  }

  @override
  void dispose() {
    classification_name.dispose();
    classification_number.dispose();
    book_title.dispose();
    book_author_code.dispose();
    book_author_name.dispose();
    book_edition.dispose();
    book_isbn.dispose();
    book_publishing_year.dispose();
    book_image.dispose();
    book_publishing_place.dispose();
    book_volume.dispose();
    book_quantity.dispose();
    book_page.dispose();
    book_source.dispose();
    book_price.dispose();
    book_binding.dispose();
    book_shelf.dispose();
    book_association_id.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade900,
        foregroundColor: Colors.white,
        title: const Center(
          child: Text('Add Book'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First container
            Expanded(
              child: Container(
                color: Colors.deepPurple.shade50,
                padding: const EdgeInsets.all(26.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: classification_name,
                      decoration: InputDecoration(
                        labelText:  'Classification Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: classification_number,
                      decoration: InputDecoration(

                        labelText:  'Classification Number',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: book_title,
                      decoration: InputDecoration(
                        labelText:  'Book Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: book_author_code,
                      decoration: InputDecoration(

                        labelText: 'Book Author Code',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: book_author_name,
                      decoration: InputDecoration(
                        labelText: 'Book Author Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: book_edition,
                      decoration: InputDecoration(
                          labelText: 'Book Edition',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: book_isbn,
                      decoration: InputDecoration(
                        labelText: 'Book ISBN',
                        border: OutlineInputBorder(),
                      ),
                    ),



                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Second container
            Expanded(
              child: Container(
                color: Colors.deepPurple.shade50,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    TextField(
                      controller: book_publishing_year,
                      decoration: InputDecoration(
                        labelText: 'Publishing Year',
                        border: OutlineInputBorder(),
                      ),
                    ),


                    const SizedBox(height: 20),
                    TextField(
                      controller: book_publishing_place,
                      decoration: InputDecoration(
                        labelText: 'Publishing Place',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: book_volume,
                      decoration: InputDecoration(
                        labelText: 'Volume',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: book_quantity,
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _clearImage,
                      child: Text("Clear Image"),
                    ),
                    SizedBox(height: 20),
                    _image != null
                        ? Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: FileImage(_image!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ) : Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(child: Text("No image selected")),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: Text("Pick Image"),
                    ),

                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Third container
            Expanded(
              child: Container(
                color: Colors.deepPurple.shade50,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: book_page,
                      decoration: InputDecoration(
                         labelText: 'Page',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: book_source,
                      decoration: InputDecoration(
                        labelText: 'Source',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: book_price,
                      decoration: InputDecoration(
                        labelText: 'Price',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: book_binding,
                      decoration: InputDecoration(
                         labelText: 'Binding',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: book_shelf,
                      decoration: InputDecoration(
                         labelText: 'Shelf',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: book_association_id,
                      decoration: InputDecoration(
                         labelText: 'Book Association ID',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 20),
                    const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: addBook,
                      child: const Text('Save'),
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

                    ),
                    ElevatedButton(

                      onPressed: () async {
                        await fetchBookDetails();
                      },style: ElevatedButton.styleFrom(

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
                      child: const Text('Search Book'),
                    ),

              ],
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
