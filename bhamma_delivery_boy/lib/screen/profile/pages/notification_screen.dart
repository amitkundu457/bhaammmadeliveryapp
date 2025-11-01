// import 'package:deligo_delivery_boy/api/api_helper.dart';
// import 'package:deligo_delivery_boy/models/notification_model.dart';
// import 'package:deligo_delivery_boy/utils/default_colors.dart';
// import 'package:deligo_delivery_boy/utils/utils.dart';
// import 'package:flutter/material.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class NotificationScreen extends StatefulWidget {
//   const NotificationScreen({super.key});

//   @override
//   State<NotificationScreen> createState() => _NotificationScreenState();
// }

// class _NotificationScreenState extends State<NotificationScreen> {
//   NotificationModel? notificationModel;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     getDetails();
//   }

//   Future<void> getDetails() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     var token = await prefs.getString('login_token');
//     try {
//       notificationModel = await ApiHandler.fetchNotification(token!);
//       print("length ${notificationModel!.all!.length}");
//     } catch (e) {
//       isLoading = true;
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text("Notification",
//               style: TextStyle(color: DefaultColor.red)),
//           centerTitle: true,
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back_ios_new, color: DefaultColor.red),
//             onPressed: () {
//               Navigator.pop(context); // Navigate Back to Previous Screen
//             },
//           ),
//         ),
//         body: isLoading
//             ? SizedBox(
//                 height: double.infinity,
//                 width: double.infinity,
//                 child: Center(
//                   child: LoadingAnimationWidget.dotsTriangle(
//                     color: DefaultColor.red,
//                     size: 50,
//                   ),
//                 ))
//             // : notificationModel!.all!.isEmpty
//             //     ? Padding(
//             //         padding: EdgeInsets.all(16.0),
//             //         child: Center(
//             //           child: Column(
//             //             mainAxisSize: MainAxisSize.min,
//             //             children: [
//             //               Icon(
//             //                 Icons.image_not_supported_outlined,
//             //                 size: 100,
//             //                 color: Color(0xFFBDBDBD),
//             //               ),
//             //               const SizedBox(height: 20),
//             //               const Text(
//             //                 "No Notification Found",
//             //                 style: TextStyle(
//             //                   fontSize: 20,
//             //                   fontWeight: FontWeight.bold,
//             //                   color: Colors.black54,
//             //                 ),
//             //               ),
//             //               const SizedBox(height: 8),
//             //               const Text(
//             //                 "No recent notifications available",
//             //                 style: TextStyle(
//             //                   fontSize: 16,
//             //                   color: Colors.grey,
//             //                 ),
//             //               ),
//             //             ],
//             //           ),
//             //         ),
//             //       )
//             : ScrollConfiguration(
//                 behavior: const ScrollBehavior().copyWith(overscroll: false),
//                 child: ListView(
//                   padding: const EdgeInsets.all(16.0),
//                   children: [
//                     // Text(
//                     //   "Recent Notifications",
//                     //   style: theme.textTheme.titleMedium?.copyWith(
//                     //     fontWeight: FontWeight.bold,
//                     //   ),
//                     // ),
//                     //const SizedBox(height: 10),
//                     ListView.builder(
//                       physics: NeverScrollableScrollPhysics(),
//                       shrinkWrap: true,
//                       itemCount: notificationModel!.all!.length,
//                       itemBuilder: (context, index) {
//                         return _buildNotificationTile(
//                           context,
//                           title: "Payment Received",
//                           subtitle: notificationModel!.all![index].data!.message
//                               .toString(),
//                           time: formatNotificationTime(
//                               notificationModel!.all![index].createdAt!),
//                         );
//                       },
//                     )
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }

//   // ✅ Custom Notification Tile
//   Widget _buildNotificationTile(
//     BuildContext context, {
//     required String title,
//     required String subtitle,
//     required String time,
//   }) {
//     final theme = Theme.of(context);

//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 5),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//               color: DefaultColor.border.withOpacity(0.3), width: 1.2)),
//       child: ListTile(
//         leading: CircleAvatar(
//           backgroundColor: Colors.transparent,
//           child: Icon(Icons.notifications_none_outlined,
//               color: Theme.of(context).brightness == Brightness.dark
//                   ? DefaultColor.border
//                   : DefaultColor.bg.withOpacity(0.7)),
//         ),
//         title: Text(
//           title,
//           style: theme.textTheme.titleMedium
//               ?.copyWith(fontWeight: FontWeight.bold, color: DefaultColor.red),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(subtitle, style: theme.textTheme.bodyMedium),
//             const SizedBox(height: 5),
//             Text(time,
//                 style: theme.textTheme.bodySmall!.copyWith(fontSize: 10)),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/api_helper.dart';
import '../../../models/notification_model.dart';
import '../../../utils/default_colors.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationModel? notificationModel;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  Future<void> getDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = await prefs.getString('login_token');

    // Check if token is null
    if (token == null) {
      print("Error: No login token found");
      setState(() {
        isLoading = false;
        errorMessage = "No login token found. Please log in again.";
      });
      return;
    }

    try {
      notificationModel = await ApiHandler.fetchNotification(token);
      print("Fetched notifications: ${notificationModel?.all?.length ?? 0}");
    } catch (e) {
      print("Error fetching notifications: $e");
      setState(() {
        errorMessage = "Failed to load notifications: $e";
      });
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
        appBar: AppBar(
          title: const Text(
            "Notification",
            style: TextStyle(color: DefaultColor.mainColor),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: DefaultColor.mainColor),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: isLoading
            ? Center(
                child: LoadingAnimationWidget.dotsTriangle(
                  color: DefaultColor.mainColor,
                  size: 50,
                ),
              )
            : errorMessage != null
                ? _buildErrorWidget(errorMessage!)
                : (notificationModel == null ||
                        notificationModel!.all == null ||
                        notificationModel!.all!.isEmpty)
                    ? _noNotificationWidget()
                    : ScrollConfiguration(
                        behavior:
                            const ScrollBehavior().copyWith(overscroll: false),
                        child: ListView(
                          padding: const EdgeInsets.all(16.0),
                          children: [
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: notificationModel!.all!.length,
                              itemBuilder: (context, index) {
                                final notif = notificationModel!.all![index];
                                return _buildNotificationTile(
                                  context,
                                  title: notif.data?.message ?? "No title",
                                  subtitle:
                                      "Order ID: ${notif.data?.orderId ?? 'N/A'}",
                                  time: formatNotificationTime(notif.createdAt),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
      ),
    );
  }

  // Widget to display when there are no notifications
  Widget _noNotificationWidget() {
    return const Padding(
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
            SizedBox(height: 20),
            Text(
              "No Notification Found",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "No recent notifications available",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to display error messages
  Widget _buildErrorWidget(String message) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 100,
              color: Colors.red,
            ),
            const SizedBox(height: 20),
            Text(
              "Error",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Custom Notification Tile
  Widget _buildNotificationTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String time,
  }) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: DefaultColor.border.withOpacity(0.3),
          width: 1.2,
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Icon(
            Icons.notifications_none_outlined,
            color: Theme.of(context).brightness == Brightness.dark
                ? DefaultColor.border
                : DefaultColor.bg.withOpacity(0.7),
          ),
        ),
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: DefaultColor.mainColor,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 5),
            Text(
              time,
              style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  // Format notification timestamp
  String formatNotificationTime(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) {
      print("Invalid dateTimeStr: $dateTimeStr");
      return '';
    }
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      final formatter = DateFormat('dd MMM yyyy, hh:mm a');
      return formatter.format(dateTime);
    } catch (e) {
      print("Error parsing dateTimeStr: $dateTimeStr, Error: $e");
      return '';
    }
  }
}
