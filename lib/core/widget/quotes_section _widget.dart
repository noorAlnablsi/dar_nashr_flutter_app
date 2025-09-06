
// import 'package:dar_nashr/core/resources/color.dart';
// import 'package:dar_nashr/pages/homepages/add_qout_page.dart';
// import 'package:flutter/material.dart';
// import 'package:dar_nashr/core/widget/quote_card.dart';
// import 'package:dar_nashr/core/widget/quotes_header.dart'; 

// class QuotesSection extends StatelessWidget {
//   const QuotesSection({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final List<Map<String, String>> quotes = [
//       {
//         'quote': "مادمت حيا فلا بد ان تعمل",
//         'author': 'إسلام جمال لكنود',
//         'addedBy':'نور النابلسي'
//       },
//       {
//         'quote': "مادام الأمل طريقا فسنحياه",
//          'author': 'إسلام جمال لكنود',
//         'addedBy':"مرام حصري"
//       },
//       {   'quote': "لم نخلق عبثا",
//          'author': 'إسلام جمال لكنود',
//         'addedBy':"رنيم الأمين"
//       }
//     ];

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//           Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 3, ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const Text(
//             "اقتباسات مما كتب",
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: Color(0xff1D2A45),
//             ),
//           ),
//           TextButton(
//             onPressed: () { Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(builder: (context) => AddQuotePage()),
//                         );
             
//             },
//             child: const Text(
//               "إضافة اقتباس",
//               style: TextStyle(
//                 fontSize: 12,
//                 color: AppColors.secondary,
//                 decoration: TextDecoration.underline,
//                 decorationColor: AppColors.secondary,
                
//                 decorationThickness: 1,
//               ),
//             ),
//           ),
//         ],
//       ),
//     ), 
//          SizedBox(height: 8),
//         SizedBox(
//           height: 110,
//           child: ListView.separated(
//             scrollDirection: Axis.horizontal,
//             itemCount: quotes.length,
//             separatorBuilder: (_, __) => const SizedBox(width: 12),
//             itemBuilder: (context, index) {
//               final quote = quotes[index];
//               return QuoteCard(

//                 quoteText: quote['quote']!,
//                 authorName: quote['author']!, addedBy: quote['addedBy']!,
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }


//========================================





// import 'package:dar_nashr/models/quote_model.dart';
// import 'package:dar_nashr/services/qoute_service.dart';
// import 'package:flutter/material.dart';
// import 'package:dar_nashr/core/resources/color.dart';
// import 'package:dar_nashr/pages/homepages/add_qout_page.dart';
// import 'package:dar_nashr/core/widget/quote_card.dart';

// class QuotesSection extends StatefulWidget {
//   const QuotesSection({super.key});

//   @override
//   State<QuotesSection> createState() => _QuotesSectionState();
// }

// class _QuotesSectionState extends State<QuotesSection> {
//   final QuoteService _quoteService = QuoteService();
//   late Future<List<Quote>> _quotesFuture;

//   @override
//   void initState() {
//     super.initState();
//     _quotesFuture = _quoteService.getQuotes();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 3),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 "اقتباسات مما كتب",
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xff1D2A45),
//                 ),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (context) => const AddQuotePage()),
//                   );
//                 },
//                 child: const Text(
//                   "إضافة اقتباس",
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: AppColors.secondary,
//                     decoration: TextDecoration.underline,
//                     decorationColor: AppColors.secondary,
//                     decorationThickness: 1,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 8),
//         SizedBox(
//           height: 120,
//           child: FutureBuilder<List<Quote>>(
//             future: _quotesFuture,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               } else if (snapshot.hasError) {
//                 return Center(child: Text("خطأ: ${snapshot.error}"));
//               } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                 return const Center(child: Text("لا يوجد اقتباسات"));
//               }

//               final quotes = snapshot.data!;
//               return ListView.separated(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: quotes.length,
//                 separatorBuilder: (_, __) => const SizedBox(width: 12),
//                 itemBuilder: (context, index) {
//                   final quote = quotes[index];
//                   return QuoteCard(
//                     quoteText: quote.text,
//                     authorName: quote.authorName ?? "غير معروف",
//                     addedBy: quote.addedBy ?? "مجهول",
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }



import 'package:dar_nashr/models/qoute_model.com';

import 'package:dar_nashr/models/quote_model.dart';
import 'package:dar_nashr/services/qoute_service.dart';
import 'package:flutter/material.dart';
import 'package:dar_nashr/core/resources/color.dart';
import 'package:dar_nashr/pages/homepages/add_qout_page.dart';
import 'package:dar_nashr/core/widget/quote_card.dart';

class QuotesSection extends StatefulWidget {
  const QuotesSection({super.key});

  @override
  State<QuotesSection> createState() => _QuotesSectionState();
}

class _QuotesSectionState extends State<QuotesSection> {
  final QuoteService _quoteService = QuoteService();
  late Future<List<Quote>> _quotesFuture;

  @override
  void initState() {
    super.initState();
    _refreshQuotes();
  }

  Future<void> _refreshQuotes() async {
    setState(() {
      _quotesFuture = _quoteService.getQuotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "اقتباسات مما كتب",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1D2A45),
                ),
              ),
              TextButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddQuotePage()),
                  );
                  if (result == true) _refreshQuotes();
                },
                child: const Text(
                  "إضافة اقتباس",
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.onPrimary,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.secondary,
                    decorationThickness: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: FutureBuilder<List<Quote>>(
            future: _quotesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("خطأ: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("لا يوجد اقتباسات"));
              }

              final quotes = snapshot.data!;
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: quotes.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final quote = quotes[index];
                  return QuoteCard(
                    quote: quote,
                    // onLike: () async {
                    //   final success = await _quoteService.toggleLike(quote.id);
                    //   if (success) _refreshQuotes();
                    // },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}


// import 'package:dar_nashr/models/quote_model.dart';
// import 'package:dar_nashr/services/qoute_service.dart';
// import 'package:flutter/material.dart';
// import 'package:dar_nashr/core/resources/color.dart';
// import 'package:dar_nashr/pages/homepages/add_qout_page.dart';
// import 'package:dar_nashr/core/widget/quote_card.dart';

// class QuotesSection extends StatefulWidget {
//   const QuotesSection({super.key});

//   @override
//   State<QuotesSection> createState() => _QuotesSectionState();
// }

// class _QuotesSectionState extends State<QuotesSection> {
//   final QuoteService _quoteService = QuoteService();
//   late Future<List<Quote>> _quotesFuture;

//   @override
//   void initState() {
//     super.initState();
//     _refreshQuotes();
//   }

//   Future<void> _refreshQuotes() async {
//     setState(() {
//       _quotesFuture = _quoteService.getQuotes();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 3),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 "اقتباسات مما كتب",
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xff1D2A45),
//                 ),
//               ),
//               TextButton(
//                 onPressed: () async {
//                   final result = await Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const AddQuotePage()),
//                   );
//                   if (result == true) {
//                     _refreshQuotes(); // إعادة تحميل الاقتباسات بعد إضافة جديدة
//                   }
//                 },
//                 child: const Text(
//                   "إضافة اقتباس",
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: AppColors.secondary,
//                     decoration: TextDecoration.underline,
//                     decorationColor: AppColors.secondary,
//                     decorationThickness: 1,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 8),
//         SizedBox(
//           height: 120,
//           child: FutureBuilder<List<Quote>>(
//             future: _quotesFuture,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               } else if (snapshot.hasError) {
//                 return Center(child: Text("خطأ: ${snapshot.error}"));
//               } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                 return  Center(child: Text("لا يوجد اقتباسات"));
//               }

//               final quotes = snapshot.data!;
//               // return ListView.separated(
//               //   scrollDirection: Axis.horizontal,
//               //   itemCount: quotes.length,
//               //   separatorBuilder: (_, __) => const SizedBox(width: 12),
//               //   itemBuilder: (context, index) {
//               //     final quote = quotes[index];
//               //     return QuoteCard(
//               //       quoteText: quote.text,
//               //       authorName: quote.authorName ?? "غير معروف",
//               //       addedBy: quote.addedBy ?? "مجهول",
//               //     );
//               //   },
//               // );


//               return ListView.separated(
//   scrollDirection: Axis.horizontal,
//   itemCount: quotes.length,
//   separatorBuilder: (_, __) => const SizedBox(width: 12),
//   itemBuilder: (context, index) {
//     final quote = quotes[index];
//     return QuoteCard(
//       quote: quote,
//       onLike: () async {
//         final success = await _quoteService.likeQuote(quote.id);
//         if (success) {
//           _refreshQuotes(); // إعادة تحميل لحتى يتحدث عدد اللايكات
//         }
//       },
//     );
//   },
// );

//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
