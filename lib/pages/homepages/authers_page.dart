import 'package:flutter/material.dart';
import 'package:dar_nashr/core/resources/color.dart';
import 'package:dar_nashr/models/writer_model.dart';
import 'package:dar_nashr/services/writer_service.dart';

class AuthorsPage extends StatefulWidget {
  const AuthorsPage({super.key});

  @override
  State<AuthorsPage> createState() => _AuthorsPageState();
}

class _AuthorsPageState extends State<AuthorsPage> {
  final WriterService _writerService = WriterService();
  late Future<List<Writer>> _writersFuture;

  @override
  void initState() {
    super.initState();
    _writersFuture = _writerService.getWriters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          "الكتّاب",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Writer>>(
        future: _writersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text("حدث خطأ: ${snapshot.error}"),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("لا يوجد كتّاب لعرضهم"),
            );
          }

          final writers = snapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: writers.length,
            itemBuilder: (context, index) {
              final writer = writers[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: Text(
                      writer.username.isNotEmpty
                          ? writer.username[0]
                          : "?",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    writer.username,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    writer.writerBio ?? "لا يوجد وصف",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.book, color: AppColors.primary),
                      Text("${writer.publishedBooksCount} كتاب"),
                    ],
                  ),
                  onTap: () {
                    // لاحقاً فيك تفتح صفحة تفاصيل الكاتب
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
