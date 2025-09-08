import 'package:dar_nashr/pages/homepages/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:dar_nashr/core/resources/color.dart';
import 'package:dar_nashr/services/user_interest_service.dart';
import 'package:dar_nashr/pages/homepages/home_page.dart';

class InterestsPage extends StatefulWidget {
  const InterestsPage({super.key});

  @override
  State<InterestsPage> createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {
  final UserInterestService service = UserInterestService();

  List<dynamic> categories = [];
  List<int> selectedIds = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadInterests();
  }

  Future<void> loadInterests() async {
    setState(() => isLoading = true);

    final allCategories = await service.getAllCategories();
    final userInterests = await service.getUserInterests();

    setState(() {
      categories = allCategories;
      selectedIds = userInterests;
      isLoading = false;
    });
  }

  void toggleSelection(int id) {
    setState(() {
      if (selectedIds.contains(id)) {
        selectedIds.remove(id);
      } else {
        selectedIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('اختر اهتماماتك'),
      //   backgroundColor: AppColors.primary,
      // ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "اختر اهتماماتك",
                    style: TextStyle(color: AppColors.primary, fontSize: 24),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final id = category['id'];
                        final name = category['name'] ?? 'بدون اسم';

                        final isSelected = selectedIds.contains(id);

                        return GestureDetector(
                          onTap: () => toggleSelection(id),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              name,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    // onPressed: () async {
                    //   final success =
                    //       await service.saveUserInterests(selectedIds);
                    //   if (success) {
                    //     Navigator.pushReplacement(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (_) =>  MainNavigationPage(),
                    //       ),
                    //     );
                    //   } else {
                    //     ScaffoldMessenger.of(context).showSnackBar(
                    //       const SnackBar(
                    //         content: Text('فشل حفظ الاهتمامات'),
                    //       ),
                    //     );
                    //   }
                    // },
                    onPressed: () async {
                      if (selectedIds.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('يجب أن  تختار اهتمام واحد على الأقل')),
                        );
                        return;
                      }

                      final success =
                          await service.saveUserInterests(selectedIds);
                      if (success) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MainNavigationPage(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('فشل حفظ الاهتمامات')),
                        );
                      }
                    },

                    child: const Text(
                      'حفظ الاهتمامات',
                      style:
                          TextStyle(fontSize: 18, color: AppColors.lightGray),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
