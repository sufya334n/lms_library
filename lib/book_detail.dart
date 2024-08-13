// import 'package:flutter/material.dart';

// void main() {
//   runApp(Bookdetail());
// }

// class Bookdetail extends StatelessWidget {
//   const Bookdetail({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: "Book Detail",
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(primaryColor: Colors.blueGrey),
//       home: DashBoardScreen(),
//     );
//   }
// }

// class DashBoardScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Center(child: Text("Book Detail")),
//       ),
//       body: Container(
//         color: Colors.cyan,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: <Widget>[
//             //  Padding(
//             //    padding: const EdgeInsets.only(left: 10.0, top: 10.0),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 Container(
//                   width: 1,
//                   height: 100,
//                   margin: EdgeInsets.all(8),
//                   color: Colors.transparent,
//                   child: Image.asset(
//                     "assets/images/pic1.PNG",
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ],
//             ),
//             // ),
//             Expanded(
//               //child: Padding(
//               //  padding: const EdgeInsets.only(left: 10.0, top: 10.0),
//               child: Container(
//                 color: Colors.grey,
//                 margin: EdgeInsets.all(8),
//                 child: Stack(
//                   children: <Widget>[
//                     ListView(
//                       children: <Widget>[
//                         Padding(
//                           padding: const EdgeInsets.all(20.0),
//                           child: Row(
//                             children: [
//                               Text(
//                                 "Title: ",
//                                 style: TextStyle(fontSize: 20),
//                               ),
//                               SizedBox(width: 10),
//                               Expanded(
//                                 child: TextField(
//                                   decoration: InputDecoration(
//                                     border: OutlineInputBorder(),
//                                     labelText: 'Enter title',
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(20.0),
//                           child: Row(
//                             children: [
//                               Text(
//                                 "Author: ",
//                                 style: TextStyle(fontSize: 20),
//                               ),
//                               SizedBox(width: 10),
//                               Expanded(
//                                 child: TextField(
//                                   decoration: InputDecoration(
//                                     border: OutlineInputBorder(),
//                                     labelText: 'Enter author',
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(20.0),
//                           child: Row(
//                             children: [
//                               Text(
//                                 "Edition: ",
//                                 style: TextStyle(fontSize: 20),
//                               ),
//                               SizedBox(width: 10),
//                               Expanded(
//                                 child: TextField(
//                                   decoration: InputDecoration(
//                                     border: OutlineInputBorder(),
//                                     labelText: 'Enter edition',
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(20.0),
//                           child: Row(
//                             children: [
//                               Text(
//                                 "Quantity: ",
//                                 style: TextStyle(fontSize: 20),
//                               ),
//                               SizedBox(width: 10),
//                               Expanded(
//                                 child: TextField(
//                                   decoration: InputDecoration(
//                                     border: OutlineInputBorder(),
//                                     labelText: 'Enter quantity',
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(20.0),
//                           child: Row(
//                             children: [
//                               Text(
//                                 "Description: ",
//                                 style: TextStyle(fontSize: 20),
//                               ),
//                               SizedBox(width: 10),
//                               Expanded(
//                                 child: TextField(
//                                   maxLines: 5,
//                                   decoration: InputDecoration(
//                                     border: OutlineInputBorder(),
//                                     labelText: 'Enter description',
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     Positioned(
//                       bottom: 16.0,
//                       right: 16.0,
//                       child: ElevatedButton(
//                         child: Text("Issue"),
//                         onPressed: () {
//                           print("Issue");
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               // ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
