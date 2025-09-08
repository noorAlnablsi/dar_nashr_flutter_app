
import 'package:dar_nashr/pages/Jobs/job_opportunities.dart';
import 'package:dar_nashr/pages/homepages/Drawer/app_drawer_page.dart';
import 'package:dar_nashr/pages/homepages/authers_page.dart';
import 'package:dar_nashr/pages/profile/ProfilePage.dart';
import 'package:dar_nashr/pages/publisher/publisher_screen.dart';
import 'package:flutter/material.dart';
import 'package:dar_nashr/core/resources/color.dart';
import 'package:dar_nashr/pages/homepages/home_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    JobOpportunitiesPage(), 
    PublishersPage(), 
    Placeholder(), 
  AuthorsPage(), 

  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: AppColors.lightGray,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: _pages[_selectedIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'فرص العمل',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apartment),
            label: 'دور النشر',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'المفضلة',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'الكتّاب',
          ),
        ],
      ),
    );
  }
}
