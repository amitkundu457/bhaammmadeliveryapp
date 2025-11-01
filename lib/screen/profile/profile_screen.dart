import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api_consts.dart';
import '../../api/api_helper.dart';
import '../../models/profile_details.dart';
import '../../utils/default_colors.dart';
import '../../widgets/buttom_manu.dart';
import '../../widgets/custom_image_view.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int selectedIndex = 2;
  ProfileDetails? profileDetails;
  bool isLoading = true;
  void onClicked(int index) {
    setState(() {
      selectedIndex = index;
    });
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
      profileDetails = await ApiHandler.getDeliveryBoydetails(token!);
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
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomMenu(
          selectedIndex: selectedIndex,
          onClicked: onClicked,
        ),
        body: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: Column(
            children: [
              _buildProfileHeader(context),
              // const SizedBox(height: 20),
              // _buildStatistics(context),
              // const SizedBox(height: 10),
              Expanded(child: _buildMenuList(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            DefaultColor.mainColor,
            Color.fromARGB(255, 166, 7, 68),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white, // Change border color if needed
                width: 2, // Adjust border width
              ),
            ),
            child: ClipOval(
              // Ensures the image stays circular
              child: CustomImageView(
                height: 65,
                width: 65,
                fit: BoxFit.fill,
                imagePath: (profileDetails?.profileImage?.isNotEmpty ?? false)
                    ? imageUrl + profileDetails!.profileImage.toString()
                    : 'assets/images/p_image.jpeg',
              ),
            ),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isLoading
                  ? Container()
                  : Text(
                      profileDetails?.user?.name.toString() ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold),
                    ),
              isLoading
                  ? Container()
                  : Text(
                      profileDetails?.user?.email.toString() ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.white70),
                    ),
            ],
          ),
          const Spacer(),
          Column(
            children: [

                IconButton(
                icon: const Icon(Icons.notifications, color: Colors.white),
                onPressed: () {
                  Navigator.pushNamed(context, "/notification");
                },
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/profile_update");
                },
                child: const Icon(Icons.edit, color: Colors.white, size: 24),
              ),
            
            ],
          )
        ],
      ),
    );
  }
  // Widget _buildStatistics(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 16),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         _buildStatBox('10', 'Total Deliveries', Colors.blueAccent),
  //         _buildStatBox('10', 'Completed', Colors.green),
  //         _buildStatBox('€200', 'Total Earned', Colors.orange),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildStatBox(String value, String label, Color color) {
  //   final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  //   return Expanded(
  //     child: Card(
  //       elevation: 0.5,
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //       child: Padding(
  //         padding: const EdgeInsets.symmetric(vertical: 16),
  //         child: Column(
  //           children: [
  //             Text(
  //               value,
  //               style: TextStyle(
  //                   color: color, fontWeight: FontWeight.bold, fontSize: 18),
  //             ),
  //             const SizedBox(height: 4),
  //             Text(
  //               label,
  //               style: TextStyle(
  //                   color: isDarkMode ? Colors.white70 : Colors.black54,
  //                   fontSize: 14),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  Widget _buildMenuList(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      children: [
        _buildMenuTile(Icons.receipt_long, 'My Earning', () {
          Navigator.pushNamed(context, "/earning");
        }),
        _buildMenuTile(Icons.star_border, 'My Reviews', () {
          Navigator.pushNamed(context, "/rating");
        }),
        // _buildMenuTile(Icons.phone, 'Emergency Contact', () {
        //   Navigator.pushNamed(context, "/emergency");
        // }),
        // _buildMenuTile(Icons.gavel, 'Dispute Resolution', () {
        //   Navigator.pushNamed(context, "/dispute");
        // }),
        // _buildMenuTile(Icons.gavel, 'Dispute Items', () {
        //   Navigator.pushNamed(context, "/dispute_list");
        // }),
        _buildMenuTile(Icons.help_outline, 'Help & Support', () {
          Navigator.pushNamed(context, "/help_support");
        }),
        // _buildMenuTile(Icons.settings, 'Settings', () {
        //   Navigator.pushNamed(context, "/settings");
        // }),
        // _buildMenuTile(Icons.announcement, 'Important Announcements', () {
        //   Navigator.pushNamed(context, "/announcements");
        // }),
        _buildMenuTile(Icons.notifications_none, 'Notifications', () {
          Navigator.pushNamed(context, "/notification");
        }),
        _buildMenuTile(Icons.privacy_tip, 'Privacy Policy', () {
          Navigator.pushNamed(context, "/privace_policy");
        }),
        _buildMenuTile(Icons.description, 'Terms & Conditions', () {
          Navigator.pushNamed(context, "/terms_conditions");
        }),
        const SizedBox(height: 20),
        _buildLogoutButton(),
        const SizedBox(height: 10),
      ],
    );
  }
  Widget _buildMenuTile(IconData icon, String title, Function? onTab) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        elevation: 0.2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: Icon(icon, color: DefaultColor.mainColor),
          title: Text(title, style: const TextStyle(fontSize: 16)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 18),
          onTap: () {
            onTab!();
          },
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return ElevatedButton(
      onPressed: () {
        showLogoutDialog(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: DefaultColor.mainColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      child: const Text('Log Out',
          style: TextStyle(color: Colors.white, fontSize: 16)),
    );
  }

  void showLogoutDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "",
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const SizedBox();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationZ((1 - animation.value) * 0.005),
          child: FadeTransition(
            opacity: animation,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              title: const Text("Logout Confirmation"),
              content: const Text("Are you sure you want to log out?"),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.grey.shade300, // Optional: Change color
                          foregroundColor: Colors.black, // Text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 5), // Space between buttons
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          // Perform logout action

                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.remove('login_token');
                          Navigator.pushNamedAndRemoveUntil(
                              context, "/login", (route) => false);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: DefaultColor
                              .mainColor, // Change color for Logout button
                          foregroundColor: Colors.white, // Text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Logout"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
