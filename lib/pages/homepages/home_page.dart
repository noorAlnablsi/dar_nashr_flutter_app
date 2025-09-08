import 'package:dar_nashr/core/resources/color.dart';
import 'package:dar_nashr/core/widget/advertisement_section.dart';
import 'package:dar_nashr/core/widget/books_section_widget.dart';
import 'package:dar_nashr/core/widget/custom_top_bar.dart';
import 'package:dar_nashr/core/widget/publishers_section_widget.dart';
import 'package:dar_nashr/core/widget/quotes_section%20_widget.dart';
import 'package:dar_nashr/core/widget/search_bar%20_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:dar_nashr/core/widget/custom_top_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          CustomTopBar(),
          Gap(12),
          SearchBarWidget(),
          Gap(24),
           AdvertisementSection(), 
           Gap(15),
          QuotesSection(),
          Gap(24),
          BooksSection(),
          Gap(24),
          PublishersSection(),
        ],
      ),
    );
  }
}
