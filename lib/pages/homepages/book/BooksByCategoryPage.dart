// import 'package:dar_nashr/core/widget/book_card.dart';
// import 'package:dar_nashr/models/book_model.dart';
// import 'package:dar_nashr/services/book_service.dart';
// import 'package:dar_nashr/services/categories_service.dart';
// import 'package:flutter/material.dart';

// class BooksByCategoryPage extends StatefulWidget {
//   const BooksByCategoryPage({super.key});

//   @override
//   State<BooksByCategoryPage> createState() => _BooksByCategoryPageState();
// }

// class _BooksByCategoryPageState extends State<BooksByCategoryPage> {
//   final CategoryService categoryService = CategoryService();
//   final BookService bookService = BookService();

//   List<dynamic> categories = [];
//   List<dynamic> allBooks = [];
//   List<dynamic> filteredBooks = [];
//   int? selectedCategoryId;

//   bool isLoadingCategories = true;
//   bool isLoadingBooks = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchCategories();
//     fetchBooks();
//   }

//   void fetchCategories() async {
//     final result = await categoryService.getCategories();
//     setState(() {
//       categories = result;
//       isLoadingCategories = false;
//     });
//   }

//   void fetchBooks() async {
//     final result = await bookService.getAllBooks();
//     setState(() {
//       allBooks = result;
//       filteredBooks = result; // أول ما نفتح الصفحة يعرض الكل
//       isLoadingBooks = false;
//     });
//   }

//   void filterBooksByCategory(int categoryId) {
//     setState(() {
//       selectedCategoryId = categoryId;
//       filteredBooks = allBooks.where((book) {
//         final cats = book["categories"] as List<dynamic>;
//         return cats.any((c) => c["id"] == categoryId);
//       }).toList();
//     });
//   }

//   // حوّل كل الكتب لـ List<Book> للاستعمال في البحث
//   List<Book> get _allBooksAsModels =>
//       allBooks.map((e) => Book.fromJson(e as Map<String, dynamic>)).toList();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("الكتب حسب التصنيفات"),
//         actions: [
//           IconButton(
//             tooltip: 'بحث',
//             icon: const Icon(Icons.search),
//             onPressed: () async {
//               // فتح البحث: يعرض قائمة كتب فقط (بدون التصنيفات)
//               await showSearch<Book?>(
//                 context: context,
//                 delegate: BooksSearchDelegate(allBooks: _allBooksAsModels),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // ✅ شريط التصنيفات
//           SizedBox(
//             height: 50,
//             child: isLoadingCategories
//                 ? const Center(child: CircularProgressIndicator())
//                 : ListView.separated(
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     scrollDirection: Axis.horizontal,
//                     itemCount: categories.length,
//                     separatorBuilder: (_, __) => const SizedBox(width: 8),
//                     itemBuilder: (context, index) {
//                       final category = categories[index];
//                       final isSelected = selectedCategoryId == category["id"];
//                       return GestureDetector(
//                         onTap: () => filterBooksByCategory(category["id"]),
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 16, vertical: 8),
//                           decoration: BoxDecoration(
//                             color: isSelected
//                                 ? const Color(0xff731F28) // خمري
//                                 : Colors.grey.shade200,
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Center(
//                             child: Text(
//                               category["name"],
//                               style: TextStyle(
//                                 color: isSelected ? Colors.white : Colors.black,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//           ),

//           const SizedBox(height: 16),

//           // ✅ عرض الكتب
//           Expanded(
//             child: isLoadingBooks
//                 ? const Center(child: CircularProgressIndicator())
//                 : filteredBooks.isEmpty
//                     ? const Center(child: Text("لا يوجد كتب لهذا التصنيف"))
//                     : GridView.builder(
//                         padding: const EdgeInsets.all(12),
//                         gridDelegate:
//                             const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 2,
//                           crossAxisSpacing: 12,
//                           mainAxisSpacing: 12,
//                           childAspectRatio: 0.65,
//                         ),
//                         itemCount: filteredBooks.length,
//                         itemBuilder: (context, index) {
//                           final map =
//                               filteredBooks[index] as Map<String, dynamic>;
//                           final book = Book.fromJson(map);
//                           return BookCard(book: book);
//                         },
//                       ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /// ======================
// /// Search Delegate للكتب
// /// ======================
// class BooksSearchDelegate extends SearchDelegate<Book?> {
//   final List<Book> allBooks;

//   BooksSearchDelegate({required this.allBooks})
//       : super(
//           searchFieldLabel: 'ابحث عن كتاب، مؤلف، وصف، تصنيف...',
//           keyboardType: TextInputType.text,
//           textInputAction: TextInputAction.search,
//         );

//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     return [
//       if (query.isNotEmpty)
//         IconButton(
//           icon: const Icon(Icons.clear),
//           onPressed: () => query = '',
//           tooltip: 'مسح',
//         ),
//     ];
//   }

//   @override
//   Widget? buildLeading(BuildContext context) {
//     return IconButton(
//       icon: const Icon(Icons.arrow_back),
//       onPressed: () => close(context, null),
//       tooltip: 'رجوع',
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     final results = _filterBooks(allBooks, query);
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: _BooksGridResults(books: results),
//     );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     final results = _filterBooks(allBooks, query);
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: _BooksGridResults(books: results),
//     );
//   }

//   List<Book> _filterBooks(List<Book> source, String q) {
//     final needle = q.trim().toLowerCase();
//     if (needle.isEmpty) return [];

//     bool matches(Book b) {
//       final inTitle = b.title.toLowerCase().contains(needle);
//       final inAuthor = b.authorName.toLowerCase().contains(needle);
//       final inDesc = b.description.toLowerCase().contains(needle);
//       final inCats = b.categories
//           .map((c) => c.name.toLowerCase())
//           .any((name) => name.contains(needle));
//       return inTitle || inAuthor || inDesc || inCats;
//     }

//     return source.where(matches).toList();
//   }
// }

// /// ويدجت صغيرة لإظهار النتائج كشبكة كروت كتب
// class _BooksGridResults extends StatelessWidget {
//   final List<Book> books;
//   const _BooksGridResults({required this.books});

//   @override
//   Widget build(BuildContext context) {
//     if (books.isEmpty) {
//       return const Center(child: Text('لا نتائج'));
//     }
//     return GridView.builder(
//       padding: const EdgeInsets.all(12),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 12,
//         mainAxisSpacing: 12,
//         childAspectRatio: 0.65,
//       ),
//       itemCount: books.length,
//       itemBuilder: (context, index) {
//         return BookCard(book: books[index]);
//       },
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dar_nashr/models/book_model.dart';
import 'package:dar_nashr/services/book_service.dart';
import 'package:dar_nashr/services/categories_service.dart';
import 'package:dar_nashr/core/widget/book_card.dart';
import 'package:dar_nashr/pages/homepages/book/add_book_page.dart'; // صفحة إضافة كتاب
import 'package:dar_nashr/pages/homepages/book/book_details_page.dart';

class BooksByCategoryPage extends StatefulWidget {
  const BooksByCategoryPage({super.key});

  @override
  State<BooksByCategoryPage> createState() => _BooksByCategoryPageState();
}

class _BooksByCategoryPageState extends State<BooksByCategoryPage> {
  final CategoryService categoryService = CategoryService();
  final BookService bookService = BookService();

  List<dynamic> categories = [];
  List<dynamic> allBooks = [];
  List<dynamic> filteredBooks = [];
  int? selectedCategoryId;

  bool isLoadingCategories = true;
  bool isLoadingBooks = true;

  String? userRole; // ✅ دور المستخدم

  @override
  void initState() {
    super.initState();
    loadUserRole();
    fetchCategories();
    fetchBooks();
  }

  Future<void> loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString('role') ?? 'reader';
    });
  }

  void fetchCategories() async {
    final result = await categoryService.getCategories();
    setState(() {
      categories = result;
      isLoadingCategories = false;
    });
  }

  void fetchBooks() async {
    final result = await bookService.getAllBooks();
    setState(() {
      allBooks = result;
      filteredBooks = result; // عرض الكل بالبداية
      isLoadingBooks = false;
    });
  }

  void filterBooksByCategory(int categoryId) {
    setState(() {
      selectedCategoryId = categoryId;
      filteredBooks = allBooks.where((book) {
        final cats = book["categories"] as List<dynamic>;
        return cats.any((c) => c["id"] == categoryId);
      }).toList();
    });
  }

  // تحويل كل الكتب لنموذج Book للبحث
  List<Book> get _allBooksAsModels =>
      allBooks.map((e) => Book.fromJson(e as Map<String, dynamic>)).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الكتب حسب التصنيفات"),
        actions: [
          IconButton(
            tooltip: 'بحث',
            icon: const Icon(Icons.search),
            onPressed: () async {
              await showSearch<Book?>(
                context: context,
                delegate: BooksSearchDelegate(allBooks: _allBooksAsModels),
              );
            },
          ),
        ],
      ),

      // // ✅ زر الإضافة يظهر فقط إذا المستخدم كاتب
      // floatingActionButton: userRole == 'writer'
      //     ? FloatingActionButton(
      //         onPressed: () {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(builder: (_) => const AddBookPage()),
      //           );
      //         },
      //         child: const Icon(Icons.add),
      //         tooltip: "نشر كتاب",
      //       )

      floatingActionButton: userRole == 'writer'
    ? FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddBookPage()),
          );
          if (result == true) {
            fetchBooks(); // ✅ إعادة تحميل الكتب مباشرة بعد النشر
          }
        },
        child: const Icon(Icons.add),
        tooltip: "نشر كتاب",
      )
    : null,

        

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // شريط التصنيفات
          SizedBox(
            height: 50,
            child: isLoadingCategories
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final isSelected = selectedCategoryId == category["id"];
                      return GestureDetector(
                        onTap: () => filterBooksByCategory(category["id"]),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xff731F28)
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              category["name"],
                              style: TextStyle(
                                color:
                                    isSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 16),

          // عرض الكتب
          Expanded(
            child: isLoadingBooks
                ? const Center(child: CircularProgressIndicator())
                : filteredBooks.isEmpty
                    ? const Center(child: Text("لا يوجد كتب لهذا التصنيف"))
                    : GridView.builder(
                        padding: const EdgeInsets.all(12),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.65,
                        ),
                        itemCount: filteredBooks.length,
                        itemBuilder: (context, index) {
                          final map =
                              filteredBooks[index] as Map<String, dynamic>;
                          final book = Book.fromJson(map);
                          return BookCard(book: book);
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

/// ======================
/// Search Delegate للكتب
/// ======================
class BooksSearchDelegate extends SearchDelegate<Book?> {
  final List<Book> allBooks;

  BooksSearchDelegate({required this.allBooks})
      : super(
          searchFieldLabel: 'ابحث عن كتاب، مؤلف، وصف، تصنيف...',
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
          tooltip: 'مسح',
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
      tooltip: 'رجوع',
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = _filterBooks(allBooks, query);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: _BooksGridResults(books: results),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final results = _filterBooks(allBooks, query);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: _BooksGridResults(books: results),
    );
  }

  List<Book> _filterBooks(List<Book> source, String q) {
    final needle = q.trim().toLowerCase();
    if (needle.isEmpty) return [];

    bool matches(Book b) {
      final inTitle = b.title.toLowerCase().contains(needle);
      final inAuthor = b.authorName.toLowerCase().contains(needle);
      final inDesc = b.description.toLowerCase().contains(needle);
      final inCats = b.categories
          .map((c) => c.name.toLowerCase())
          .any((name) => name.contains(needle));
      return inTitle || inAuthor || inDesc || inCats;
    }

    return source.where(matches).toList();
  }
}

class _BooksGridResults extends StatelessWidget {
  final List<Book> books;
  const _BooksGridResults({required this.books});

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) {
      return const Center(child: Text('لا نتائج'));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.65,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        return BookCard(book: books[index]);
      },
    );
  }
}
