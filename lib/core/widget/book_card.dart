import 'package:flutter/material.dart';
import 'package:dar_nashr/models/book_model.dart';
import 'package:dar_nashr/services/add_book_fav.dart';
import 'package:dar_nashr/main.dart'; // فيه المتغير url
import 'package:dar_nashr/pages/homepages/book/book_details_page.dart'; // أو المسار عندك ل BookDetailsMobile

class BookCard extends StatefulWidget {
  final Book book;

  const BookCard({super.key, required this.book});

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  bool isFav = false;
  final BookServiceFav _bookService = BookServiceFav();

  String _fullUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    final normalized = path.replaceAll('\\', '/').replaceFirst(RegExp(r'^/+'), '');
    final base = url.endsWith('/') ? url : '$url/';
    return '$base$normalized';
  }

  Future<void> _toggleFavorite() async {
    try {
      final success = await _bookService.toggleFavorite(widget.book.id);
      if (success) {
        setState(() => isFav = !isFav);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isFav ? "تمت الإضافة إلى المفضلة ✅" : "تمت الإزالة من المفضلة ❌"),
            backgroundColor: isFav ? Colors.green : Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("حصل خطأ أثناء الإضافة للمفضلة"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cover = _fullUrl(widget.book.coverUrl);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        // ✅ أرسل كل معلومات الكتاب إلى صفحة التفاصيل
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BookDetailsMobile(book: widget.book),
          ),
        );
      },
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // صورة + قلب
            Expanded(
              flex: 7,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: cover.isNotEmpty
                        ? Image.network(
                            cover,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (_, __, ___) => Image.asset(
                              'images/غلاف الكتاب.png',
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          )
                        : Image.asset(
                            'images/غلاف الكتاب.png',
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: _toggleFavorite,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: const Color(0xff731F28),
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // عناوين
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                child: Column(
                  children: [
                    Text(
                      widget.book.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xff1D2A45),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      (widget.book.publisherHouseName ?? 'غير معروف'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xff731F28),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
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
