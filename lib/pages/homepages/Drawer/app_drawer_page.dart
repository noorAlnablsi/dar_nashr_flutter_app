import 'package:dar_nashr/pages/profile/ProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:dar_nashr/core/resources/color.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: AppColors.primary),
                ),
                SizedBox(height: 10),
                Text(
                  'اسم المستخدم',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
          ListTile(
  leading: const Icon(Icons.person),
  title: const Text("الحساب"),
  onTap: () {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfilePage()),
    );
  },
),

          // 🔑 خيار تغيير كلمة المرور
          ListTile(
            leading: const Icon(Icons.lock_reset),
            title: const Text("تغيير كلمة المرور"),
            onTap: () {
              Navigator.pop(context);
              // TODO: روح لواجهة تغيير كلمة المرور
            },
          ),
          const SizedBox(height: 20), // ✨ مسافة إضافية
          // 🚪 خيار تسجيل الخروج
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("تسجيل الخروج"),
            onTap: () {
              Navigator.pop(context);
              // TODO: نفّذ تسجيل الخروج
            },
          ),
        ],
      ),
    );
  }
}
