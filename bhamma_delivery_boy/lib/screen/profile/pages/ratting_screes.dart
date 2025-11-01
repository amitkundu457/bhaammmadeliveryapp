import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/api_helper.dart';
import '../../../models/feedback_model.dart';
import '../../../utils/default_colors.dart';
import '../../../utils/utils.dart';
import '../../../widgets/buttom_manu.dart';

class RatingReviewsScreen extends StatefulWidget {
  const RatingReviewsScreen({super.key});

  @override
  State<RatingReviewsScreen> createState() => _RatingReviewsScreenState();
}

class _RatingReviewsScreenState extends State<RatingReviewsScreen> {
  int selectedIndex = 2;

  List<FeedbackModel>? feedbackModel;
  bool isLoading = true;

  void onClicked(int index) {
    if (selectedIndex != index) {
      setState(() => selectedIndex = index);
    }
  }

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  Future<void> getDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = await prefs.getString('login_token');
    try {
      // feedbackModel = await ApiHandler.fetchfeedback(token!);
      feedbackModel = await ApiHandler.fetchfeedback(token!);
      print("feedbackModel123 ${jsonEncode(feedbackModel)}");
    } catch (e) {
      isLoading = true;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomMenu(
          selectedIndex: selectedIndex,
          onClicked: onClicked,
        ),
        appBar: AppBar(
          title: const Text("Rating and reviews",
              style: TextStyle(color: DefaultColor.mainColor)),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: DefaultColor.mainColor),
            onPressed: () {
              Navigator.pop(context); // Navigate Back to Previous Screen
            },
          ),
        ),
        body: isLoading
            ? SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Center(
                    child: LoadingAnimationWidget.dotsTriangle(
                  color: DefaultColor.mainColor,
                  size: 50,
                )))
            : feedbackModel!.isEmpty
                ? Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.image_not_supported_outlined,
                            size: 100,
                            color: Color(0xFFBDBDBD),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "No Rating Found",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Currently, there are no ratings available.",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // _buildOverallRating(context),
                        // const SizedBox(height: 30),
                        Text(
                          "Customer reviews",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: DefaultColor.mainColor,
                          ),
                        ),
                        //  const SizedBox(height: 10),
                        ListView.builder(
                          itemCount: feedbackModel!.length,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return _buildReviewCard(
                              context,
                              name: feedbackModel![index]
                                      .customer
                                      ?.name
                                      .toString() ??
                                  'Unknown',
                              rating: double.parse(
                                  feedbackModel![index].rating?.toString() ??
                                      '0'),
                              date: formatNotificationTime(
                                  feedbackModel![index].createdAt!),
                              review: feedbackModel![index].comment.toString(),
                            );
                          },
                        )
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _buildOverallRating(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DefaultColor.mainColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Your overall rating",
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                "4.7",
                style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 5),
              _buildStarRating(4.7),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            "Based on 40 reviews",
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 10),
          const Row(
            children: [
              Text("View rating breakdown",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: DefaultColor.white,
                  )),
              Icon(Icons.keyboard_arrow_down, color: Colors.white),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(BuildContext context,
      {required String name,
      required double rating,
      required String date,
      required String review}) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DefaultColor.mainColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Text(
                rating.toString(),
                style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
              ),
              const SizedBox(width: 5),
              _buildStarRating(rating),
              const Spacer(),
              Text(date,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: Colors.white70)),
            ],
          ),
          const SizedBox(height: 8),
          // const Icon(Icons.camera_alt, color: Colors.white70, size: 18),
          // const SizedBox(height: 5),
          Text(
            review,
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;

    return Row(
      children: List.generate(
            fullStars,
            (index) => const Icon(Icons.star, color: Colors.white, size: 20),
          ) +
          (hasHalfStar
              ? [const Icon(Icons.star_half, color: Colors.white, size: 20)]
              : []),
    );
  }
}
