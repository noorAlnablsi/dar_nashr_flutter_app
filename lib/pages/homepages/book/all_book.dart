// // import 'package:dar_nashr/core/widget/book_card.dart';
// // import 'package:dar_nashr/services/book_service.dart';
// // import 'package:flutter/material.dart';

// // class AllBooksPage extends StatefulWidget {
// //   const AllBooksPage({super.key});

// //   @override
// //   State<AllBooksPage> createState() => _AllBooksPageState();
// // }

// // class _AllBooksPageState extends State<AllBooksPage> {
// //   //final BookService bookService = BookService();
// //   List<dynamic> books = [];
// //   bool isLoading = true;

// //   @override
// //   void initState() {
// //     super.initState();
// //     fetchBooks();
// //   }

// //   void fetchBooks() async {
// //     //books = await bookService.getAllBooks();
// //      setState(() {
// //       isLoading = false;
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('جميع الكتب'),
// //       ),
// //       body: isLoading
// //           ? const Center(child: CircularProgressIndicator())
// //           : ListView.separated(
// //               padding: const EdgeInsets.all(12),
// //               itemCount: books.length,
// //               separatorBuilder: (_, __) => const SizedBox(height: 12),
// //               itemBuilder: (context, index) {
// //                 final book = books[index];
// //                 return BookCard(
// //                   title: book['title'] ?? 'بدون عنوان',
// //                 );
// //               },
// //             ),
// //     );
// //   }
// // }



// import 'package:dar_nashr/core/widget/book_card.dart';
// import 'package:dar_nashr/services/book_service.dart';
// import 'package:flutter/material.dart';

// class AllBooksPage extends StatefulWidget {
//   const AllBooksPage({super.key});

//   @override
//   State<AllBooksPage> createState() => _AllBooksPageState();
// }

// class _AllBooksPageState extends State<AllBooksPage> {
//   final BookService bookService = BookService();
//   List<dynamic> books = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchBooks();
//   }

//   void fetchBooks() async {
//     final result = await bookService.getAllBooks();
//     setState(() {
//       books = result;
//       isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('جميع الكتب')),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : books.isEmpty
//               ? const Center(child: Text("لا يوجد كتب"))
//               : ListView.separated(
//                   padding: const EdgeInsets.all(12),
//                   itemCount: books.length,
//                   separatorBuilder: (_, __) => const SizedBox(height: 12),
//                   itemBuilder: (context, index) {
//                     final book = books[index];
//                     return BookCard(
//   title: book['title'] ?? 'بدون عنوان',
//   publisherName: book['publisher_house_name'] ?? 'غير معروف',
//   coverUrl: book['cover_url'], // إذا حابة تعرّضي الغلاف
// );
//                   },
//                 ),
//     );
//   }
// }
