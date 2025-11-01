import 'package:flutter/material.dart';

Widget buildImagePickerOption(BuildContext context, String label,
      IconData icon, Color iconColor, Function ontab) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: () {
        // Handle image picking logic here
        Navigator.pop(context); // Close bottom sheet after selection
        ontab();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
        margin: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color:
              isDarkMode ? const Color.fromARGB(255, 25, 26, 27) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 6,
              spreadRadius: 1,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: iconColor.withOpacity(0.1),
              child: Icon(icon, color: iconColor),
            ),
            SizedBox(width: 15),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                // color: Colors.black87,
              ),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
