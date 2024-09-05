import 'package:admin_dashboard_app/src/database/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';

import 'package:mysql1/mysql1.dart';


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
  final book_volume      = TextEditingController();
  final book_description = TextEditingController();
  final book_page        = TextEditingController();
  final book_source      = TextEditingController();
  final book_price       = TextEditingController();
  final book_binding     = TextEditingController();
  final book_shelf       = TextEditingController();
  final book_association_id = TextEditingController();
  final associationController = TextEditingController();

  var bookTitleId;
  var bookAuthorId;
  var book_associationid;





  // pick image
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



  //clear image
  void _clearImage() {
    setState(() {
      _image = null;
    });
  }
//author table for entry
  Future<void> table_book_author() async {
    var conn = await db.getConnection();
    // Check if the author already exists
    String checkQuery = 'SELECT author_id FROM authors WHERE author_code = ? AND author_name = ?';
    var result = await conn.query(checkQuery, [book_author_code.text, book_author_name.text]);
    if (result.isNotEmpty) {
      bookAuthorId = result.first['author_id'];
      print('Author already exists with ID: $bookAuthorId');
    } else {
      // If the author doesn't exist, insert the new author
      String sqlQuery = 'INSERT INTO authors(author_code, author_name) VALUES (?,?)';
      var insertResult = await conn.query(sqlQuery, [book_author_code.text, book_author_name.text]);
      bookAuthorId = insertResult.insertId;
      print('Added to table_book_author with ID: $bookAuthorId');
    }
  }





  //book tittle table
  Future<void> table_book_title() async {
    var conn = await db.getConnection();
    Uint8List? imageBytes;

    if (_image != null) {
      imageBytes = await _image!.readAsBytes();
    }
    String sqlQuery = 'INSERT INTO books(title,edition,isbn,publish_year,publish_place,image,shelf,classification_number,classification_name,category,volume,quantity,pages,source,price,binding,author_id,description) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
    var result = await conn.query(sqlQuery, [book_title.text,book_edition.text,book_isbn.text,book_publishing_year.text,book_publishing_place.text,imageBytes,book_shelf.text,classification_number.text,classification_name.text,1,book_volume.text,0,book_page.text, book_source.text, book_price.text, book_binding.text,bookAuthorId,book_description.text]);
    bookTitleId = result.insertId; // Get the inserted ID
    print("Added to table_book_title with ID: $bookTitleId");
  }





  // association table   is ka mtlb he agr book tittle id select hui hogi to association k table pr jaye gi
  Future<void> table_book_association() async {
    var conn = await db.getConnection();

    // Check if the book_id exists in the books table
    var bookExistsQuery = 'SELECT COUNT(*) FROM books WHERE book_id = ?';
    var result = await conn.query(bookExistsQuery, [bookTitleId]);

    int count = result.first[0];

    if (count > 0) {
      // Check if the copy number already exists for the given book_id
      var duplicateCheckQuery = 'SELECT COUNT(*) FROM associations WHERE book_id = ? AND copy_number = ?';
      var duplicateResult = await conn.query(duplicateCheckQuery, [bookTitleId, associationController.text]);

      int duplicateCount = duplicateResult.first[0];

      if (duplicateCount > 0) {
        // Alert the user about the duplicate copy number
        print('Error: Duplicate copy number detected for this book.');
        // You can show an alert dialog here if you want
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Duplicate Association id')),
        );
      } else {
        // If no duplicate, insert into the associations table
        String sqlQuery = 'INSERT INTO associations(book_id, copy_number) VALUES (?,?)';
        var insertResult = await conn.query(sqlQuery, [bookTitleId, associationController.text]);

        book_associationid = insertResult.insertId;
        setState(() {});

        await updateBookQuantity();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('book is successfully added')),
        );
        print('Added to table_book_association with ID: $book_associationid');
      }
    } else {
      // If the book doesn't exist, handle the error or insert into books first
      print('Error: book_id does not exist in the books table.');
      // Optionally, you could add code here to insert the book into the books table
    }
  }


  Future<void> updateBookQuantity() async {
    try {
      // Fetch the current quantity of the book
      var conn = await db.getConnection();
      var result = await conn.query(
        'SELECT quantity FROM books WHERE book_id = ?',
        [bookTitleId],
      );

      if (result.isEmpty) {
        throw Exception('Book with ID $bookTitleId not found.');
      }

      // Get the current quantity
      var currentQuantity = result.first['quantity'] as int;

      // Calculate the new quantity
      int newQuantity = currentQuantity + 1;

      // Update the quantity in the database
      await conn.query(
        'UPDATE books SET quantity = ? WHERE book_id = ?',
        [newQuantity, bookTitleId],
      );
      print('Book quantity updated successfully.');
    } catch (e) {
      print('Error updating book quantity: $e');
    }
  }


  Future<void> showAssociationDialog() async {
    while (true) {


      bool shouldContinue = await showDialog(
        context: context,
        barrierDismissible: false, // Prevent dismissing by tapping outside
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Enter Association ID"),
            content: TextField(
              controller: associationController,
              decoration: InputDecoration(
                labelText: 'Association ID',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  if (associationController.text.isNotEmpty) {
                    // Save the association ID to the database

                  await table_book_association();

                    Navigator.of(context).pop(true);
                  associationController.clear();
                    // Continue asking for more IDs
                  } else {
                    showAlert("Please enter an Association ID.");
                  }
                },
                child: Text("Save and Add Another"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // Exit the loop
                },
                child: Text("Exit"),
              ),
            ],
          );
        },
      );

      if (!shouldContinue) break; // Break the loop if the user clicks "Exit"
    }
  }






















  //
  // Future<void> fetchBookDetails() async {
  //   if (book_association_id.text.isEmpty ||
  //       !RegExp(r'^\d+$').hasMatch(book_association_id.text)) {
  //     showAlert("Please enter a valid numeric Book Association ID.");
  //     return;
  //   }
  //
  //   try {
  //     var conn = await db.getConnection();
  //
  //     // Step 1: Retrieve the book_id from the table_book_association
  //     String associationQuery = '''
  //   SELECT book_id
  //   FROM associations
  //   WHERE association_id = ?
  //   ''';
  //
  //     var associationResults = await conn.query(associationQuery, [int.parse(book_association_id.text)]);
  //
  //     if (associationResults.isNotEmpty) {
  //       var associationRow = associationResults.first;
  //       int bookId = associationRow['book_id'];
  //
  //       // Step 2: Retrieve the book details using the book_id
  //       String bookQuery = '''
  //     SELECT b.classification_name, b.classification_number,
  //            b.title, a.author_code, a.author_name,
  //            b.edition, b.isbn, b.publish_year,
  //            b.publish_place, b.volume,
  //            b.description, b.pages,
  //            b.source, b.price, b.binding, b.shelf
  //     FROM associations AS ba
  //     JOIN books AS b ON ba.book_id = b.book_id
  //     JOIN authors AS a ON b.author_id = a.author_id
  //     WHERE ba.book_id = ?
  //     ''';
  //
  //       var bookResults = await conn.query(bookQuery, [bookId]);
  //
  //       if (bookResults.isNotEmpty) {
  //         var row = bookResults.first;
  //
  //         classification_name.text = row['classification_name'].toString();
  //         classification_number.text = row['classification_number'].toString();
  //         book_title.text = row['title'].toString();
  //         book_author_code.text = row['author_code'].toString();
  //         book_author_name.text = row['author_name'].toString();
  //         book_edition.text = row['edition'].toString();
  //         book_isbn.text = row['isbn'].toString();
  //         book_publishing_year.text = row['publish_year'].toString();
  //         book_publishing_place.text = row['publish_place'].toString();
  //         book_volume.text = row['volume'].toString();
  //         book_description.text = row['description'].toString();
  //         book_page.text = row['pages'].toString();
  //         book_source.text = row['source'].toString();
  //         book_price.text = row['price'].toString();
  //         book_binding.text = row['binding'].toString();
  //         book_shelf.text = row['shelf'].toString();
  //
  //         // Inform the user that the book details have been fetched
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text('Book details fetched successfully')),
  //         );
  //       } else {
  //         showAlert("No book details found with the provided Association ID.");
  //       }
  //     } else {
  //       showAlert("No association found with the provided Association ID.");
  //     }
  //   } catch (e) {
  //     print('Error fetching book details: $e');
  //     showAlert("An error occurred while fetching book details.");
  //   }
  // }
  //


//bc.Book_Classification_Name, bc.Book_Classification_Number,
  //        bt.book_title, ba.Book_author_code, ba.Book_author_name,
  //        et.Book_Eddition, et.ISBN, et.Book_Publishing_year, et.BOOK_eddition_image, et.Book_Publishing_place,
  //        bv.Volume, bv.Quantity,
  //        bpd.Book_page, bpd.Book_source, bpd.Book_price, bpd.Book_binding,






  Future<void> fetchBookDetails() async {
    if (book_association_id.text.isEmpty || !RegExp(r'^\d+$').hasMatch(book_association_id.text)) {
      showAlert("Please enter a valid numeric Book Association ID.");
      return;
    }

    try {
      var conn = await db.getConnection();

      String sqlQuery = '''
    SELECT b.classification_name, b.classification_number,
          b.title, a.author_code, a.author_name,
          b.edition, b.isbn, b.publish_year,
          b.publish_place, b.volume,
          b.description, b.pages,
          b.source, b.price, b.binding, b.shelf,
          b.image
    FROM associations AS ba
    JOIN books AS b ON ba.book_id = b.book_id
    JOIN authors AS a ON b.author_id = a.author_id
    WHERE ba.copy_number = ?
    ''';

      var results = await conn.query(sqlQuery, [int.parse(book_association_id.text)]);

      if (results.isNotEmpty) {
        var row = results.first;

        book_description.text = row['description'].toString();
        classification_name.text = row['classification_name'].toString();
        classification_number.text = row['classification_number'].toString();
        book_title.text = row['title'].toString();
        book_author_code.text = row['author_code'].toString();
        book_author_name.text = row['author_name'].toString();
        book_edition.text = row['edition'].toString();
        book_isbn.text = row['isbn'].toString();
        book_publishing_year.text = row['publish_year'].toString();
        book_publishing_place.text = row['publish_place'].toString();
        book_volume.text = row['volume'].toString();
        book_page.text = row['pages'].toString();
        book_source.text = row['source'].toString();
        book_price.text = row['price'].toString();
        book_binding.text = row['binding'].toString();
        book_shelf.text = row['shelf'].toString();

        // Fetch and convert the image
        if (row['image'] != null) {
          Blob blob = results.first['image'];
          List<int> imageBytes =blob.toBytes();
         // List<int> imageBytes = row['image'];


          _image = File.fromRawPath(Uint8List.fromList(imageBytes));
        } else {
          print('No image found for this book.');
          _image = null;
        }

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
    book_description.clear();
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
        book_description.text.isEmpty ||
        book_page.text.isEmpty ||
        book_source.text.isEmpty ||
        book_price.text.isEmpty ||
        book_binding.text.isEmpty ||
        book_shelf.text.isEmpty) {
      showAlert("Please fill in all required fields.");
      return;
    }

    try {
      var conn = await db.getConnection();

      // Check if all the required fields are present in the same row
      var results = await conn.query(
          '''
      SELECT book_id 
      FROM books 
      WHERE title = ? 
      AND edition = ? 
      AND isbn = ? 
      AND publish_year = ? 
      AND publish_place = ? 
      AND classification_number = ? 
      AND classification_name = ?
      AND volume =?
      AND pages =?
      AND source =?
      AND price =?
      AND binding =?
      AND description =?
      ''',
          [
            book_title.text,
            book_edition.text,
            book_isbn.text,
            book_publishing_year.text,
            book_publishing_place.text,
            classification_number.text,
            classification_name.text,
            book_volume.text,
            book_page.text,
            book_source.text,
            book_price.text,
            book_binding.text,
            book_description.text




          ]
      );

      if (results.isNotEmpty) {
        // Existing book found, fetch the book ID
        bookTitleId = results.first['book_id'];
        print('Book already exists with ID: $bookTitleId');

        // Show the association dialog
        await showAssociationDialog();
      }


      else {
        // Book does not exist, add it to the database
        await table_book_author();
        await table_book_title();

        // `bookTitleId` should now be set by `table_book_title`
        if (bookTitleId == null || bookTitleId == 0) {
          throw Exception('Failed to retrieve the inserted book ID.');
        }

        print('Added new book with ID: $bookTitleId');

        // Show the association dialog
        await showAssociationDialog();
      }

      showAlert("Data saved successfully.");
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
    book_description.dispose();
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
                      controller: book_description,
                      decoration: InputDecoration(
                        labelText: 'Book Description',
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
                         labelText: 'search book by id',
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
                            horizontal: 60, vertical: 15),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    ),
                    ElevatedButton(

                      onPressed: () async
                      {

                        await fetchBookDetails();
                      },
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
