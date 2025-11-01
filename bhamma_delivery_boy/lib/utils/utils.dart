// Fonts
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

String poppinsFont = "Poppins";
String ralewayFont = "Raleway";
String robotoFont = "Roboto";
String latoFont = "Lato";

// Font Sizes
const double fontSizeSmall = 12.0;
const double fontSizeSmallMedium = 11.0;
const double fontSizeMedium = 16.0;
const double fontSizeMedium15 = 15.0;
const double fontSizeLarge = 20.0;
const double fontSizeExtraLarge = 24.0;

// Additional font utilities if needed
const double fontSizeTitle = 18.0;
const double fontSizeSubtitle = 14.0;
const double fontSizeBody = 14.0;
const double fontSizeCaption = 10.5;

String formatNotificationTime(String utcTime) {
  try {
    DateTime utcDateTime = DateTime.parse(utcTime);
    DateTime localDateTime = utcDateTime.toLocal();

    return DateFormat('dd MMM yyyy, hh:mm a').format(localDateTime);
  } catch (e) {
    return utcTime; // fallback if parsing fails
  }
}

Future<void> makePhoneCall(BuildContext context, String number) async {
  final Uri url = Uri(scheme: 'tel', path: number);
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Cannot make the call")),
    );
  }
}
