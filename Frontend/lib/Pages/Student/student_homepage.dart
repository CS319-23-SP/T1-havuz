import 'package:first_trial/Pages/Widgets/LeftBar/left_bar.dart';
import 'package:first_trial/Pages/Widgets/AppBars/app_bars.dart';
import 'package:first_trial/Pages/Widgets/AppBars/roles/student_appbar.dart';
import 'package:first_trial/Pages/Widgets/access_denied.dart';
import 'package:first_trial/final_variables.dart';
import 'package:first_trial/token.dart';
import 'package:flutter/material.dart';

class StudentHomepage extends StatefulWidget {
  const StudentHomepage({super.key});

  @override
  State<StudentHomepage> createState() => _StudentHomepageState();
}

class _StudentHomepageState extends State<StudentHomepage> {
  late final ScrollController _scrollController;

  String? role = "unknown";

  @override
  void initState() {
    super.initState();
    checkRole();
  }

  Future<void> checkRole() async {
    role = await TokenStorage.getRole();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (role != 'student') {
      return AccessDeniedPage();
    }
    return Scaffold(
        appBar: CustomAppBar(
          role: role,
        ),
        body: Row(
          children: [
            LeftBar(
              role: role,
            ),
          ],
        ));
  }
}
/*
class CourseList extends StatelessWidget {
  const CourseList({
    super.key,
    required ScrollController scrollController,
    required this.items,
    required bool isFetchingData,
  })  : _scrollController = scrollController,
        _isFetchingData = isFetchingData;

  final ScrollController _scrollController;
  final List? items;
  final bool _isFetchingData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
          top: 20.0,
          left: 20.0,
          right: 20.0,
          bottom: 8.0), // Adjust padding as needed
      decoration: BoxDecoration(
        color: PoolColors.cardWhite,
        borderRadius: BorderRadius.circular(20.0), // Set the border radius
      ),
      child: ListView(
        controller: _scrollController,
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items!.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300, // Adjust max width as needed
              mainAxisSpacing: 10, // Adjust spacing between rows as needed
              crossAxisSpacing: 10, // Adjust spacing between items as needed
              childAspectRatio: 1, // Maintain aspect ratio of 1:1 for items
            ),
            itemBuilder: (context, index) {
              
              PostDTO post = PostDTO(
                id: '1', // Example: Replace '1' with the actual ID
                tags:
                    'Concert', // Example: Replace 'Sample Tags' with the actual tags
                title:
                    'Mayfest & Mogollar', // Example: Replace 'Sample Title' with the actual title
                imageUrl:
                    'https://t4.ftcdn.net/jpg/04/73/25/49/360_F_473254957_bxG9yf4ly7OBO5I0O5KABlN930GwaMQz.jpg', // Example: Replace with actual image URL
                sdate: DateTime
                    .now(), // Example: Replace 'DateTime.now()' with the actual creation date
                location:
                    "Bilkent", // Example: Replace '10.0' with the actual price
                organizer:
                    'Bilkent', // Example: Replace 'Sample User' with the actual user
              );

              return ProductCard(
                post: post,
              );
            },
          ),
          if (_isFetchingData)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
*/