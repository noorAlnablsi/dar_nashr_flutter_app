// import 'dart:typed_data';
// import 'package:dar_nashr/core/resources/color.dart';
// import 'package:dar_nashr/main.dart';
// import 'package:dar_nashr/models/book_model.dart';
// import 'package:dar_nashr/pages/homepages/book/pdf_reader.dart';
// import 'package:dio/dio.dart';
// import 'package:file_saver/file_saver.dart';
// import 'package:flutter/material.dart';
// import 'package:path/path.dart' as p;

// class BookDetailsMobile extends StatefulWidget {
//   final Book book;
//   const BookDetailsMobile({super.key, required this.book});

//   @override
//   State<BookDetailsMobile> createState() => _BookDetailsMobileState();
// }

// class _BookDetailsMobileState extends State<BookDetailsMobile> {
//   bool _downloading = false;

//   // يبني URL كامل لمسار نسبي
//   String _fullUrl(String path) {
//     if (path.isEmpty) return '';
//     if (path.startsWith('http')) return path;
//     final normalized = path.replaceAll('\\', '/').replaceFirst(RegExp(r'^/+'), '');
//     final base = url.endsWith('/') ? url : '$url/';
//     return '$base$normalized';
//   }

//   String _formatDate(String iso) {
//     final i = iso.indexOf('T');
//     return i > 0 ? iso.substring(0, i) : iso;
//   }

//   Future<void> _downloadPdf(String filePath, String suggestedName) async {
//     final pdfUrl = _fullUrl(filePath);
//     if (pdfUrl.isEmpty) {
//       _toast('رابط الملف غير صالح', isError: true);
//       return;
//     }

//     setState(() => _downloading = true);
//     try {
//       final resp = await Dio().get<List<int>>(
//         pdfUrl,
//         options: Options(
//           responseType: ResponseType.bytes,
//           followRedirects: true,
//           validateStatus: (s) => true, // ما نرمي إلايدج تلقائياً
//         ),
//       );

//       if (resp.statusCode == 200 && resp.data != null) {
//         final bytes = Uint8List.fromList(resp.data!);
//         String fileName = p.basename(Uri.parse(pdfUrl).path);
//         // لو الاسم من الرابط مو واضح، نستخدم العنوان
//         if (!fileName.toLowerCase().endsWith('.pdf')) {
//           fileName = '${suggestedName.isEmpty ? 'book' : suggestedName}.pdf';
//         }
//         await FileSaver.instance.saveFile(
//           name: fileName,
//           bytes: bytes,
//           ext: 'pdf',
//           mimeType: MimeType.pdf,
//         );
//         _toast('تم تنزيل الملف: $fileName');
//       } else {
//         _toast('فشل التنزيل (${resp.statusCode}).', isError: true);
//       }
//     } catch (e) {
//       _toast('تعذّر تنزيل الملف', isError: true);
//     } finally {
//       if (mounted) setState(() => _downloading = false);
//     }
//   }

//   void _toast(String msg, {bool isError = false}) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(msg, textAlign: TextAlign.center),
//         backgroundColor: isError ? Colors.red : Colors.green,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final b = widget.book;

//     // بعض الحقول حسب موديلك:
//     final coverUrl = _fullUrl(b.coverUrl);
//     final pdfUrl = _fullUrl(b.bookFile);
//     final isFree = b.isFree || b.price == 0;
//     final publisherName = (/* إذا موديلك يحتوي */ (b as dynamic).publisherHouseName) ?? ''; // لو عندك الحقل
//     // إن ما عندك publisherHouseName واستخدمت publisherHouseId قدّم بديل:
//     final publisherText = publisherName.isNotEmpty
//         ? publisherName
//         : (b.publisherHouseId == 0 ? 'غير محددة' : 'رقم ${b.publisherHouseId}');

//     final createdAtText = b.createdAt is DateTime
//         ? (b.createdAt as DateTime).toIso8601String()
//         : (b.createdAt is String ? b.createdAt as String : '');

//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         backgroundColor: AppColors.lightGray,
//         appBar: AppBar(
//           backgroundColor: AppColors.primary,
//           foregroundColor: Colors.white,
//           title: const Text('تفاصيل الكتاب'),
//         ),
//         body: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Container(
//             decoration: BoxDecoration(
//               color: AppColors.background,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: const [
//                 BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
//               ],
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   // الغلاف
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(10),
//                     child: AspectRatio(
//                       aspectRatio: 3/4,
//                       child: coverUrl.isEmpty
//                           ? Container(
//                               color: AppColors.textSecondaryC,
//                               child: const Icon(Icons.book, size: 72, color: Colors.white),
//                             )
//                           : Image.network(
//                               coverUrl,
//                               fit: BoxFit.cover,
//                               errorBuilder: (_, __, ___) => Container(
//                                 color: AppColors.textSecondaryC,
//                                 child: const Icon(Icons.book, size: 72, color: Colors.white),
//                               ),
//                             ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),

//                   // العنوان + المؤلف
//                   Text(
//                     b.title,
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.primary,
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   Row(
//                     children: [
//                       const Icon(Icons.person, size: 18, color: AppColors.onPrimary),
//                       const SizedBox(width: 6),
//                       Expanded(
//                         child: Text(
//                           b.authorName.isEmpty ? 'كاتب غير معروف' : b.authorName,
//                           style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 6),
//                   Row(
//                     children: [
//                       const Icon(Icons.business, size: 18, color: AppColors.onPrimary),
//                       const SizedBox(width: 6),
//                       Expanded(
//                         child: Text(
//                           'دار النشر: $publisherText',
//                           style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 6),
//                   Row(
//                     children: [
//                       const Icon(Icons.calendar_today, size: 18, color: AppColors.onPrimary),
//                       const SizedBox(width: 6),
//                       Text(
//                         createdAtText.isEmpty ? '' : _formatDate(createdAtText),
//                         style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
//                       ),
//                     ],
//                   ),

//                   // التصنيفات (اختياري إذا موجودة)
//                   if (b.categories.isNotEmpty) ...[
//                     const SizedBox(height: 12),
//                     Wrap(
//                       spacing: 8,
//                       runSpacing: 8,
//                       children: b.categories
//                           .map((c) => Chip(
//                                 label: Text(c.name, style: const TextStyle(color: Colors.white)),
//                                 backgroundColor: AppColors.onPrimary,
//                               ))
//                           .toList(),
//                     ),
//                   ],

//                   const SizedBox(height: 16),
//                   Container(height: 1, color: AppColors.textSecondaryC),
//                   const SizedBox(height: 16),

//                   // السعر
//                   Row(
//                     children: [
//                       const Icon(Icons.sell, size: 18, color: AppColors.onPrimary),
//                       const SizedBox(width: 6),
//                       Text(
//                         isFree ? 'مجاني' : 'السعر: ${b.price.toStringAsFixed(2)} ل.س',
//                         style: TextStyle(
//                           fontSize: 15,
//                           color: isFree ? Colors.green[700] : AppColors.onPrimary,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 16),

//                   // الوصف
//                   const Text(
//                     'الوصف',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                       color: AppColors.primary,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     b.description.isEmpty ? 'لا يوجد وصف متاح.' : b.description,
//                     style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, height: 1.5),
//                   ),

//                   const SizedBox(height: 24),

//                   // الأزرار
//                   Row(
//                     children: [
//                       // قراءة
//                       Expanded(
//                         child: ElevatedButton.icon(
//                           icon: const Icon(Icons.menu_book, color: AppColors.buttonText),
//                           label: const Text('قراءة', style: TextStyle(color: AppColors.buttonText)),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green[700],
//                             minimumSize: const Size.fromHeight(48),
//                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                           ),
//                           onPressed: () {
//                             if (pdfUrl.isEmpty) {
//                               _toast('لا يوجد ملف متاح', isError: true);
//                               return;
//                             }
//                            Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (_) => PDFReaderScreen(
//       pdfUrl: pdfUrl,
//       isFree: b.isFree,
//       // headers: {'Authorization': 'Bearer $token'}, // اختياري
//     ),
//   ),
// );
//                           },
//                         ),
//                       ),
//                       const SizedBox(width: 12),

//                       // تحميل
//                       Expanded(
//                         child: ElevatedButton.icon(
//                           icon: _downloading
//                               ? const SizedBox(
//                                   width: 18, height: 18,
//                                   child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
//                                 )
//                               : const Icon(Icons.download, color: AppColors.buttonText),
//                           label: Text(
//                             _downloading ? 'جاري التنزيل...' : 'تحميل',
//                             style: const TextStyle(color: AppColors.buttonText),
//                           ),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: AppColors.onPrimary,
//                             minimumSize: const Size.fromHeight(48),
//                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                           ),
//                           onPressed: () async {
//                             if (!isFree) {
//                               _toast('الكتاب غير مجاني، التحميل غير متاح', isError: true);
//                               return;
//                             }
//                             if (b.bookFile.isEmpty) {
//                               _toast('لا يوجد ملف متاح', isError: true);
//                               return;
//                             }
//                             await _downloadPdf(b.bookFile, b.title.trim());
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }





import 'dart:typed_data';
import 'package:dar_nashr/core/resources/color.dart';
import 'package:dar_nashr/main.dart';
import 'package:dar_nashr/models/book_model.dart';
import 'package:dar_nashr/pages/homepages/book/pdf_reader.dart';
import 'package:dar_nashr/services/comment_service.dart';
import 'package:dio/dio.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;


class BookDetailsMobile extends StatefulWidget {
  final Book book;
  const BookDetailsMobile({super.key, required this.book});

  @override
  State<BookDetailsMobile> createState() => _BookDetailsMobileState();
}

class _BookDetailsMobileState extends State<BookDetailsMobile> {
  bool _downloading = false;

  final CommentService _commentService = CommentService();
  final TextEditingController _commentController = TextEditingController();
  List<dynamic> _comments = [];
  bool _loadingComments = true;
  bool _postingComment = false;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    setState(() => _loadingComments = true);
    final comments = await _commentService.getBookComments(bookId: widget.book.id);
    if (mounted) {
      setState(() {
        _comments = comments;
        _loadingComments = false;
      });
    }
  }

  Future<void> _submitComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    setState(() => _postingComment = true);
    final success = await _commentService.addComment(bookId: widget.book.id, text: text);
    if (success) {
      _commentController.clear();
      await _loadComments();
    }
    setState(() => _postingComment = false);
  }

  Widget _buildCommentItem(dynamic comment) {
    return ListTile(
      title: Text(comment['user_name'] ?? 'مستخدم', style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(comment['text'] ?? ''),
      trailing: Text(
        (comment['created_at'] ?? '').toString().split('T').first,
        style: const TextStyle(fontSize: 11, color: Colors.grey),
      ),
    );
  }

  String _fullUrl(String path) {
    if (path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    final normalized = path.replaceAll('\\', '/').replaceFirst(RegExp(r'^/+'), '');
    final base = url.endsWith('/') ? url : '$url/';
    return '$base$normalized';
  }

  String _formatDate(String iso) {
    final i = iso.indexOf('T');
    return i > 0 ? iso.substring(0, i) : iso;
  }

  Future<void> _downloadPdf(String filePath, String suggestedName) async {
    final pdfUrl = _fullUrl(filePath);
    if (pdfUrl.isEmpty) {
      _toast('رابط الملف غير صالح', isError: true);
      return;
    }

    setState(() => _downloading = true);
    try {
      final resp = await Dio().get<List<int>>(
        pdfUrl,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
          validateStatus: (s) => true,
        ),
      );

      if (resp.statusCode == 200 && resp.data != null) {
        final bytes = Uint8List.fromList(resp.data!);
        String fileName = p.basename(Uri.parse(pdfUrl).path);
        if (!fileName.toLowerCase().endsWith('.pdf')) {
          fileName = '${suggestedName.isEmpty ? 'book' : suggestedName}.pdf';
        }
        await FileSaver.instance.saveFile(
          name: fileName,
          bytes: bytes,
          ext: 'pdf',
          mimeType: MimeType.pdf,
        );
        _toast('تم تنزيل الملف: $fileName');
      } else {
        _toast('فشل التنزيل (${resp.statusCode}).', isError: true);
      }
    } catch (e) {
      _toast('تعذّر تنزيل الملف', isError: true);
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  void _toast(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, textAlign: TextAlign.center),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final b = widget.book;

    final coverUrl = _fullUrl(b.coverUrl);
    final pdfUrl = _fullUrl(b.bookFile);
    final isFree = b.isFree || b.price == 0;
    final publisherName = (b as dynamic).publisherHouseName ?? '';
    final publisherText = publisherName.isNotEmpty
        ? publisherName
        : (b.publisherHouseId == 0 ? 'غير محددة' : 'رقم ${b.publisherHouseId}');
    final createdAtText = b.createdAt is DateTime
        ? (b.createdAt as DateTime).toIso8601String()
        : (b.createdAt is String ? b.createdAt as String : '');

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.lightGray,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          title: const Text('تفاصيل الكتاب'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // الغلاف
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AspectRatio(
                  aspectRatio: 3/4,
                  child: coverUrl.isEmpty
                      ? Container(
                          color: AppColors.textSecondaryC,
                          child: const Icon(Icons.book, size: 72, color: Colors.white),
                        )
                      : Image.network(
                          coverUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.textSecondaryC,
                            child: const Icon(Icons.book, size: 72, color: Colors.white),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // العنوان + المؤلف
              Text(
                b.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.person, size: 18, color: AppColors.onPrimary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      b.authorName.isEmpty ? 'كاتب غير معروف' : b.authorName,
                      style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.business, size: 18, color: AppColors.onPrimary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'دار النشر: $publisherText',
                      style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 18, color: AppColors.onPrimary),
                  const SizedBox(width: 6),
                  Text(
                    createdAtText.isEmpty ? '' : _formatDate(createdAtText),
                    style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                  ),
                ],
              ),

              // التصنيفات
              if (b.categories.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: b.categories
                      .map((c) => Chip(
                            label: Text(c.name, style: const TextStyle(color: Colors.white)),
                            backgroundColor: AppColors.onPrimary,
                          ))
                      .toList(),
                ),
              ],

              const SizedBox(height: 16),
              Container(height: 1, color: AppColors.textSecondaryC),
              const SizedBox(height: 16),

              // السعر
              Row(
                children: [
                  const Icon(Icons.sell, size: 18, color: AppColors.onPrimary),
                  const SizedBox(width: 6),
                  Text(
                    isFree ? 'مجاني' : 'السعر: ${b.price.toStringAsFixed(2)} ل.س',
                    style: TextStyle(
                      fontSize: 15,
                      color: isFree ? Colors.green[700] : AppColors.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // الوصف
              const Text(
                'الوصف',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                b.description.isEmpty ? 'لا يوجد وصف متاح.' : b.description,
                style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, height: 1.5),
              ),

              const SizedBox(height: 24),

              // الأزرار
              Row(
                children: [
                  // قراءة
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.menu_book, color: AppColors.buttonText),
                      label: const Text('قراءة', style: TextStyle(color: AppColors.buttonText)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        if (pdfUrl.isEmpty) {
                          _toast('لا يوجد ملف متاح', isError: true);
                          return;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PDFReaderScreen(pdfUrl: pdfUrl, isFree: b.isFree),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),

                  // تحميل
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: _downloading
                          ? const SizedBox(
                              width: 18, height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.download, color: AppColors.buttonText),
                      label: Text(
                        _downloading ? 'جاري التنزيل...' : 'تحميل',
                        style: const TextStyle(color: AppColors.buttonText),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.onPrimary,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () async {
                        if (!isFree) {
                          _toast('الكتاب غير مجاني، التحميل غير متاح', isError: true);
                          return;
                        }
                        if (b.bookFile.isEmpty) {
                          _toast('لا يوجد ملف متاح', isError: true);
                          return;
                        }
                        await _downloadPdf(b.bookFile, b.title.trim());
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 12),

              // قسم التعليقات
              const Text(
                'التعليقات',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: 'اكتب تعليقك هنا...',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _postingComment ? null : _submitComment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.onPrimary,
                    ),
                    child: _postingComment
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text('نشر',style: TextStyle(color: AppColors.lightGray),),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _loadingComments
                  ? const Center(child: CircularProgressIndicator())
                  : _comments.isEmpty
                      ? const Text('لا توجد تعليقات بعد.')
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (_, index) => _buildCommentItem(_comments[index]),
                          separatorBuilder: (_, __) => const Divider(),
                          itemCount: _comments.length,
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
