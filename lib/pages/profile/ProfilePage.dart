
// import 'package:dar_nashr/pages/profile/edit_profile_page.dart';
// import 'package:dar_nashr/services/profile_service.dart';
// import 'package:flutter/material.dart';
// import 'package:dar_nashr/core/resources/color.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   final ProfileService _profileService = ProfileService();
//   Map<String, dynamic>? profile;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchProfile();
//   }

//   Future<void> _fetchProfile() async {
//     try {
//       final data = await _profileService.getProfile();
//       setState(() {
//         profile = data;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() => isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("حصل خطأ أثناء جلب البيانات"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   // يحوّل المهارات لنقاط (chips) — يفصل بفواصل/أسطر
//   List<String> _parseSkills(String? raw) {
//     if (raw == null || raw.trim().isEmpty) return [];
//     final s = raw.replaceAll('\n', ',');
//     return s.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
//   }

//   // يحوّل الروابط لقائمة قابلة للنقر
//   List<String> _parseLinks(String? raw) {
//     if (raw == null || raw.trim().isEmpty) return [];
//     final s = raw.replaceAll('\n', ',');
//     return s.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isReady = !isLoading && profile != null;

//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         backgroundColor: AppColors.lightGray,
//         appBar: AppBar(
//           title: const Text("صفحتي"),
//           centerTitle: true,
//           backgroundColor: AppColors.primary,
//           foregroundColor: Colors.white,
//           elevation: 0,
//         ),
//         floatingActionButton: isReady
//             ? FloatingActionButton.extended(
//                 backgroundColor: AppColors.onPrimary,
//                 foregroundColor: Colors.white,
//                 icon: const Icon(Icons.edit),
//                 label: const Text('تعديل'),
//                 onPressed: () async {
//                   final updated = await Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => EditProfilePage(profile: profile!),
//                     ),
//                   );
//                   if (updated == true) _fetchProfile();
//                 },
//               )
//             : null,
//         body: isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : (profile == null)
//                 ? const Center(child: Text("لا توجد بيانات"))
//                 : SingleChildScrollView(
//                     padding: const EdgeInsets.only(bottom: 100),
//                     child: Column(
//                       children: [
//                         _HeaderCard(
//                           name: profile!['username'] ?? 'غير معروف',
//                           email: profile!['email'] ?? '-',
//                           phone: profile!['phone_number'] ?? '-',
//                           avatarUrl: profile!['profile_image'],
//                         ),
//                         const SizedBox(height: 12),

//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 16),
//                           child: Column(
//                             children: [
//                               _StatsRow(
//                                 booksCount:
//                                     (profile!['published_books_count'] ?? 0)
//                                         .toString(),
//                               ),

//                               if ((profile!['bio'] ?? '')
//                                   .toString()
//                                   .trim()
//                                   .isNotEmpty)
//                                 _SectionCard(
//                                   title: 'نبذة عني',
//                                   child: Text(
//                                     profile!['bio'],
//                                     style: const TextStyle(
//                                       color: AppColors.textPrimary,
//                                       height: 1.6,
//                                     ),
//                                   ),
//                                 ),

//                               if (_parseLinks(profile!['social_links'])
//                                   .isNotEmpty)
//                                 _SectionCard(
//                                   title: 'روابط التواصل',
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: _parseLinks(
//                                       profile!['social_links'],
//                                     )
//                                         .map(
//                                           (link) => Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                                 vertical: 4),
//                                             child: Row(
//                                               mainAxisSize: MainAxisSize.min,
//                                               children: [
//                                                 const Icon(Icons.link,
//                                                     size: 18,
//                                                     color:
//                                                         AppColors.onPrimary),
//                                                 const SizedBox(width: 6),
//                                                 Flexible(
//                                                   child: Text(
//                                                     link,
//                                                     style: const TextStyle(
//                                                       color: Colors.blue,
//                                                       decoration: TextDecoration
//                                                           .underline,
//                                                     ),
//                                                     overflow:
//                                                         TextOverflow.ellipsis,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         )
//                                         .toList(),
//                                   ),
//                                 ),

//                               if (_parseSkills(profile!['skills']).isNotEmpty)
//                                 _SectionCard(
//                                   title: 'مهاراتي',
//                                   child: Wrap(
//                                     spacing: 8,
//                                     runSpacing: 8,
//                                     children: _parseSkills(profile!['skills'])
//                                         .map(
//                                           (s) => Chip(
//                                             label: Text(
//                                               s,
//                                               style: const TextStyle(
//                                                 color: Colors.white,
//                                               ),
//                                             ),
//                                             backgroundColor:
//                                                 AppColors.onPrimary,
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                             ),
//                                           ),
//                                         )
//                                         .toList(),
//                                   ),
//                                 ),

//                               const SizedBox(height: 80),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//       ),
//     );
//   }
// }

// /// =====================
// /// Header مُحسّن بلا Overflow
// /// =====================
// class _HeaderCard extends StatelessWidget {
//   final String name;
//   final String email;
//   final String phone;
//   final String? avatarUrl;

//   const _HeaderCard({
//     required this.name,
//     required this.email,
//     required this.phone,
//     this.avatarUrl,
//   });

//   @override
//   Widget build(BuildContext context) {
//     const double headerHeight = 140;
//     const double avatarRadius = 46;
//     const double overlap = 40;

//     return Column(
//       children: [
//         Stack(
//           clipBehavior: Clip.none,
//           children: [
//             Container(
//               height: headerHeight,
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.centerRight,
//                   end: Alignment.centerLeft,
//                   colors: [AppColors.primary, Color(0xFF25365A)],
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: -overlap,
//               left: 0,
//               right: 0,
//               child: CircleAvatar(
//                 radius: avatarRadius + 4,
//                 backgroundColor: Colors.white,
//                 child: CircleAvatar(
//                   radius: avatarRadius,
//                   backgroundColor: AppColors.secondary,
//                   backgroundImage: (avatarUrl != null && avatarUrl!.isNotEmpty)
//                       ? NetworkImage(avatarUrl!)
//                       : null,
//                   child: (avatarUrl == null || avatarUrl!.isEmpty)
//                       ? const Icon(Icons.person, size: 42, color: Colors.white)
//                       : null,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: overlap + 12),

//         // البطاقة البيضاء
//         Container(
//           margin: const EdgeInsets.symmetric(horizontal: 16),
//           padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: const [
//               BoxShadow(
//                 color: Colors.black12,
//                 blurRadius: 10,
//                 offset: Offset(0, 4),
//               )
//             ],
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 name,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   color: AppColors.primary,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20,
//                 ),
//               ),
//               const SizedBox(height: 8),

//               // Wrap بدل Row حتى ما يصير Overflow
//               Wrap(
//                 alignment: WrapAlignment.center,
//                 crossAxisAlignment: WrapCrossAlignment.center,
//                 spacing: 12,
//                 runSpacing: 6,
//                 children: [
//                   Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Icon(Icons.email,
//                           size: 18, color: AppColors.onPrimary),
//                       const SizedBox(width: 6),
//                       ConstrainedBox(
//                         constraints: const BoxConstraints(maxWidth: 220),
//                         child: Text(
//                           email,
//                           style:
//                               const TextStyle(color: AppColors.textPrimary),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Icon(Icons.phone,
//                           size: 18, color: AppColors.onPrimary),
//                       const SizedBox(width: 6),
//                       ConstrainedBox(
//                         constraints: const BoxConstraints(maxWidth: 160),
//                         child: Text(
//                           phone,
//                           style:
//                               const TextStyle(color: AppColors.textPrimary),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// /// بطاقة قسم عام بعنوان ومحتوى
// class _SectionCard extends StatelessWidget {
//   final String title;
//   final Widget child;

//   const _SectionCard({required this.title, required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 14),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 const Icon(Icons.info, color: AppColors.onPrimary, size: 18),
//                 const SizedBox(width: 6),
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     color: AppColors.primary,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             child,
//           ],
//         ),
//       ),
//     );
//   }
// }

// /// صف إحصائيات يستجيب للعرض
// class _StatsRow extends StatelessWidget {
//   final String booksCount;

//   const _StatsRow({required this.booksCount});

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (_, constraints) {
//         final isNarrow = constraints.maxWidth < 360;
//         if (isNarrow) {
//           return Column(
//             children: [
//               _MiniStatCard(
//                 icon: Icons.menu_book_rounded,
//                 title: 'الكتب المنشورة',
//                 value: booksCount,
//                 color: AppColors.onPrimary,
//               ),
//               const SizedBox(height: 12),
//               _MiniStatCard(
//                 icon: Icons.verified_user,
//                 title: 'الحالة',
//                 value: 'نشط',
//                 color: AppColors.secondary,
//               ),
//             ],
//           );
//         }
//         return Row(
//           children: [
//             Expanded(
//               child: _MiniStatCard(
//                 icon: Icons.menu_book_rounded,
//                 title: 'الكتب المنشورة',
//                 value: booksCount,
//                 color: AppColors.onPrimary,
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: _MiniStatCard(
//                 icon: Icons.verified_user,
//                 title: 'الحالة',
//                 value: 'نشط',
//                 color: AppColors.secondary,
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// class _MiniStatCard extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String value;
//   final Color color;

//   const _MiniStatCard({
//     required this.icon,
//     required this.title,
//     required this.value,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 88,
//       padding: const EdgeInsets.all(12),
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 8,
//             offset: Offset(0, 3),
//           )
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 38,
//             height: 38,
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.12),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(icon, color: color),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     color: AppColors.textPrimary,
//                     fontSize: 12,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 4),
//                 FittedBox(
//                   fit: BoxFit.scaleDown,
//                   alignment: Alignment.centerRight,
//                   child: Text(
//                     value,
//                     style: const TextStyle(
//                       color: AppColors.primary,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }





import 'package:dar_nashr/pages/profile/edit_profile_page.dart';
import 'package:dar_nashr/services/profile_service.dart';
import 'package:dar_nashr/services/upgrade_service.dart';
import 'package:flutter/material.dart';
import 'package:dar_nashr/core/resources/color.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileService _profileService = ProfileService();
  final UpgradeService _upgradeService = UpgradeService();

  Map<String, dynamic>? profile;
  bool isLoading = true;
  bool _upgrading = false;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final data = await _profileService.getProfile();
      setState(() {
        profile = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("حصل خطأ أثناء جلب البيانات"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // يحوّل المهارات لنقاط (chips) — يفصل بفواصل/أسطر
  List<String> _parseSkills(String? raw) {
    if (raw == null || raw.trim().isEmpty) return [];
    final s = raw.replaceAll('\n', ',');
    return s.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }

  // يحوّل الروابط لقائمة قابلة للنقر
  List<String> _parseLinks(String? raw) {
    if (raw == null || raw.trim().isEmpty) return [];
    final s = raw.replaceAll('\n', ',');
    return s.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isReady = !isLoading && profile != null;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.lightGray,
        appBar: AppBar(
          title: const Text("صفحتي"),
          centerTitle: true,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        floatingActionButton: isReady
            ? FloatingActionButton.extended(
                backgroundColor: AppColors.onPrimary,
                foregroundColor: Colors.white,
                icon: const Icon(Icons.edit),
                label: const Text('تعديل'),
                onPressed: () async {
                  final updated = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditProfilePage(profile: profile!),
                    ),
                  );
                  if (updated == true) _fetchProfile();
                },
              )
            : null,
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : (profile == null)
                ? const Center(child: Text("لا توجد بيانات"))
                : SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: Column(
                      children: [
                        _HeaderCard(
                          name: profile!['username'] ?? 'غير معروف',
                          email: profile!['email'] ?? '-',
                          phone: profile!['phone_number'] ?? '-',
                          avatarUrl: profile!['profile_image'],
                        ),
                        const SizedBox(height: 12),

                        // زر الترقية فقط إذا المستخدم قارئ
                        if (profile!['role'] == 'reader')
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            child: ElevatedButton.icon(
                              icon: _upgrading
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.upgrade),
                              label: Text(_upgrading ? 'جاري الترقية...' : 'الترقية إلى كاتب'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orangeAccent,
                                foregroundColor: Colors.white,
                                minimumSize: const Size.fromHeight(45),
                              ),
                              onPressed: _upgrading
                                  ? null
                                  : () async {
                                      setState(() => _upgrading = true);
                                      final result = await _upgradeService.upgradeToWriter();
                                      setState(() => _upgrading = false);

                                      if (result != null) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text("تمت الترقية إلى كاتب بنجاح!"),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                        await _fetchProfile();
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text("فشل الترقية، حاول لاحقاً"),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    },
                            ),
                          ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              _StatsRow(
                                booksCount:
                                    (profile!['published_books_count'] ?? 0)
                                        .toString(),
                              ),

                              if ((profile!['bio'] ?? '').toString().trim().isNotEmpty)
                                _SectionCard(
                                  title: 'نبذة عني',
                                  child: Text(
                                    profile!['bio'],
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      height: 1.6,
                                    ),
                                  ),
                                ),

                              if (_parseLinks(profile!['social_links']).isNotEmpty)
                                _SectionCard(
                                  title: 'روابط التواصل',
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: _parseLinks(profile!['social_links'])
                                        .map(
                                          (link) => Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 4),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(Icons.link, size: 18, color: AppColors.onPrimary),
                                                const SizedBox(width: 6),
                                                Flexible(
                                                  child: Text(
                                                    link,
                                                    style: const TextStyle(
                                                      color: Colors.blue,
                                                      decoration: TextDecoration.underline,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),

                              if (_parseSkills(profile!['skills']).isNotEmpty)
                                _SectionCard(
                                  title: 'مهاراتي',
                                  child: Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: _parseSkills(profile!['skills'])
                                        .map(
                                          (s) => Chip(
                                            label: Text(
                                              s,
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            backgroundColor: AppColors.onPrimary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),

                              const SizedBox(height: 80),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}

/// =====================
/// Header مُحسّن بلا Overflow
/// =====================
class _HeaderCard extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final String? avatarUrl;

  const _HeaderCard({
    required this.name,
    required this.email,
    required this.phone,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    const double headerHeight = 140;
    const double avatarRadius = 46;
    const double overlap = 40;

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: headerHeight,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [AppColors.primary, Color(0xFF25365A)],
                ),
              ),
            ),
            Positioned(
              bottom: -overlap,
              left: 0,
              right: 0,
              child: CircleAvatar(
                radius: avatarRadius + 4,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: avatarRadius,
                  backgroundColor: AppColors.secondary,
                  backgroundImage: (avatarUrl != null && avatarUrl!.isNotEmpty)
                      ? NetworkImage(avatarUrl!)
                      : null,
                  child: (avatarUrl == null || avatarUrl!.isEmpty)
                      ? const Icon(Icons.person, size: 42, color: Colors.white)
                      : null,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: overlap + 12),

        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12,
                runSpacing: 6,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.email, size: 18, color: AppColors.onPrimary),
                      const SizedBox(width: 6),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 220),
                        child: Text(
                          email,
                          style: const TextStyle(color: AppColors.textPrimary),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.phone, size: 18, color: AppColors.onPrimary),
                      const SizedBox(width: 6),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 160),
                        child: Text(
                          phone,
                          style: const TextStyle(color: AppColors.textPrimary),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// بطاقة قسم عام بعنوان ومحتوى
class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.info, color: AppColors.onPrimary, size: 18),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}

/// صف إحصائيات يستجيب للعرض
class _StatsRow extends StatelessWidget {
  final String booksCount;

  const _StatsRow({required this.booksCount});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final isNarrow = constraints.maxWidth < 360;
        if (isNarrow) {
          return Column(
            children: [
              _MiniStatCard(
                icon: Icons.menu_book_rounded,
                title: 'الكتب المنشورة',
                value: booksCount,
                color: AppColors.onPrimary,
              ),
              const SizedBox(height: 12),
              _MiniStatCard(
                icon: Icons.verified_user,
                title: 'الحالة',
                value: 'نشط',
                color: AppColors.secondary,
              ),
            ],
          );
        }
        return Row(
          children: [
            Expanded(
              child: _MiniStatCard(
                icon: Icons.menu_book_rounded,
                title: 'الكتب المنشورة',
                value: booksCount,
                color: AppColors.onPrimary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MiniStatCard(
                icon: Icons.verified_user,
                title: 'الحالة',
                value: 'نشط',
                color: AppColors.secondary,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _MiniStatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
