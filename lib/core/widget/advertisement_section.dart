// core/widget/advertisement_section_widget.dart
import 'package:dar_nashr/main.dart';
import 'package:flutter/material.dart';
import 'package:dar_nashr/services/advertisement_service.dart';

class AdvertisementSection extends StatefulWidget {
  const AdvertisementSection({super.key});

  @override
  State<AdvertisementSection> createState() => _AdvertisementSectionState();
}

class _AdvertisementSectionState extends State<AdvertisementSection> {
  final AdvertisementService adService = AdvertisementService();
  List<dynamic> ads = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAds();
  }

  Future<void> loadAds() async {
    final result = await adService.getAdvertisements();
    setState(() {
      ads = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (ads.isEmpty) {
      return const SizedBox(); // ما في إعلانات → ما منعرض شي
    }

    return SizedBox(
      height: 160,
      child: PageView.builder(
        itemCount: ads.length,
        controller: PageController(viewportFraction: 0.9),
        itemBuilder: (context, index) {
          final ad = ads[index];
          final imageUrl = "${url}${ad['image_url']}"; // 🚨 مهم تكمل الرابط

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Center(child: Icon(Icons.broken_image, size: 50)),
              ),
            ),
          );
        },
      ),
    );
  }
}
