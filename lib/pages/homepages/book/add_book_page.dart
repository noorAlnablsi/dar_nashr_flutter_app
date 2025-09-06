import 'dart:io';
import 'package:dar_nashr/services/book_publish_service.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dar_nashr/core/resources/color.dart';

import 'package:dar_nashr/services/categories_service.dart';
import 'package:gap/gap.dart';

class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  bool isFree = true;
  File? bookFile;
  File? coverImage;

  List<dynamic> categories = [];
  List<int> selectedCategoryIds = [];
  bool isLoadingCategories = true;
  bool isUploading = false;

  final CategoryService categoryService = CategoryService();

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  void fetchCategories() async {
    final result = await categoryService.getCategories();
    setState(() {
      categories = result;
      isLoadingCategories = false;
    });
  }

  Future<void> pickBookFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() => bookFile = File(result.files.single.path!));
    }
  }

  Future<void> pickCoverImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null && result.files.single.path != null) {
      setState(() => coverImage = File(result.files.single.path!));
    }
  }

  Future<void> uploadBook() async {
    if (!_formKey.currentState!.validate()) return;
    if (bookFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار ملف الكتاب')),
      );
      return;
    }
    if (selectedCategoryIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار تصنيف واحد على الأقل')),
      );
      return;
    }

    setState(() => isUploading = true);

    final success = await BookUploadService.uploadBook(
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      isFree: isFree,
      price: isFree ? 0 : double.tryParse(priceController.text.trim()) ?? 0,
      categoryIds: selectedCategoryIds,
      bookFile: bookFile!,
      coverImage: coverImage,
    );

    setState(() => isUploading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? 'تم نشر الكتاب بنجاح ' : 'فشل في نشر الكتاب '),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );

    if (success) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          SizedBox(
            width: 10,
          ),
          Text(
            'نشر كتاب جديد',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontSize: 20),
          ),
          SizedBox(
            width: 110,
          )
        ],
        backgroundColor: AppColors.lightGray,
      ),
      body: isLoadingCategories
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // العنوان
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'عنوان الكتاب',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'الرجاء إدخال العنوان'
                          : null,
                    ),
                    const SizedBox(height: 16),

                    // الوصف
                    TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'وصف الكتاب',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 4,
                      validator: (value) => value == null || value.isEmpty
                          ? 'الرجاء إدخال الوصف'
                          : null,
                    ),
                    const SizedBox(height: 16),

                    // الكتاب مجاني؟
                    Row(
                      children: [
                        const Text('هل الكتاب مجاني؟'),
                        SizedBox(
                          width: 12,
                        ),
                        Switch(
                          value: isFree,
                          onChanged: (val) {
                            setState(() {
                              isFree = val;
                            });
                          },
                          activeColor: AppColors.secondary,
                        ),
                      ],
                    ),
                    Gap(15),
                    // السعر (إذا ليس مجاني)
                    if (!isFree)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: TextFormField(
                          controller: priceController,
                          decoration: const InputDecoration(
                            labelText: 'السعر',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (!isFree && (value == null || value.isEmpty)) {
                              return 'الرجاء إدخال السعر';
                            }
                            return null;
                          },
                        ),
                      ),
                    SizedBox(
                      height: 5,
                    ),
                    // اختيار الكتاب
                    ElevatedButton(
                      onPressed: pickBookFile,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.onPrimary),
                      child: Text(bookFile == null
                          ? 'اختر ملف الكتاب (PDF)'
                          : 'تم اختيار: ${bookFile!.path.split('/').last}',style: TextStyle(color: AppColors.lightGray),),
                    ),
                    const SizedBox(height: 12),

                    // اختيار غلاف
                    ElevatedButton(
                      onPressed: pickCoverImage,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.onPrimary),
                      child: Text(coverImage == null
                          ? 'اختر صورة الغلاف (اختياري)'
                          : 'تم اختيار: ${coverImage!.path.split('/').last}',style: TextStyle(color: AppColors.lightGray),),

                    ),
                    const SizedBox(height: 16),

                    // اختيار التصنيفات
                    const Text('اختر التصنيفات:'),
                    Gap(10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: categories.map((cat) {
                        final id = cat['id'] as int;
                        final selected = selectedCategoryIds.contains(id);
                        return ChoiceChip(
                          label: Text(cat['name']),
                          selected: selected,
                          onSelected: (val) {
                            setState(() {
                              if (val) {
                                selectedCategoryIds.add(id);
                              } else {
                                selectedCategoryIds.remove(id);
                              }
                            });
                          },
                          selectedColor: AppColors.primary.withOpacity(0.7),
                          backgroundColor: Colors.grey.shade200,
                          labelStyle: TextStyle(
                              color: selected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // زر النشر
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isUploading ? null : uploadBook,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          isUploading ? 'جاري النشر...' : 'نشر الكتاب',
                          style: const TextStyle(fontSize: 16,color: AppColors.lightGray),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
