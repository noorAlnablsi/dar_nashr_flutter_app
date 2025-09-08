// import 'package:flutter/material.dart';
// import 'package:dar_nashr/core/resources/color.dart';

// class CustomTopBar extends StatelessWidget {
//   const CustomTopBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         IconButton(
//           onPressed: () {},
//           icon: const Icon(Icons.menu, color: AppColors.primary),
//         ),
//         Image.asset(
//           "images/imageho.png",
//           width: 45,
//           height: 35,
//         ),
//       ],
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:dar_nashr/core/resources/color.dart';

class CustomTopBar extends StatelessWidget {
  const CustomTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            // فتح الـ Drawer
            Scaffold.of(context).openDrawer();
          },
          icon: const Icon(Icons.menu, color: AppColors.primary),
        ),
        Image.asset(
          "images/imageho.png",
          width: 45,
          height: 35,
        ),
      ],
    );
  }
}

