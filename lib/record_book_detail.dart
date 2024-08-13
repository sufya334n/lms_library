import 'package:flutter/material.dart';

class RecordBookDetails extends StatelessWidget {
  const RecordBookDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Record CNIC Details'),
          centerTitle: true,
        ),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height:16), // Adjust this value for desired spacing
                const Text('CNIC'),
                const SizedBox(height: 8),
                SizedBox(
                  width: 200, // Adjust this width as needed
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Name'),
                const SizedBox(height: 8),
                SizedBox(
                  width: 200, // Adjust this width as needed
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Mobile No'),
                const SizedBox(height: 8),
                SizedBox(
                  width: 200, // Adjust this width as needed
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    maxLines: 1,
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ],
            ),
            ),
        );
    }
}