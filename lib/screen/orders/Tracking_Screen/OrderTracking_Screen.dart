// import 'dart:async';
// import 'dart:convert';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:http/http.dart' as http;
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:location/location.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class OrderTrackingPage extends StatefulWidget {
//   final String name;
//   final String address;
//   final String phone;
//
//   const OrderTrackingPage({
//     super.key,
//     required this.name,
//     required this.address,
//     required this.phone,
//   });
//
//   @override
//   State<OrderTrackingPage> createState() => _OrderTrackingPageState();
// }
//
// class _OrderTrackingPageState extends State<OrderTrackingPage> {
//   GoogleMapController? mapController;
//   Location location = Location();
//   String googleAPIKey = 'AIzaSyDPbGzcvHYuIK2boIPD8VVuzWf8_g3tDs0';
//
//   StreamSubscription<LocationData>? _locationSubscription;
//
//   LatLng? origin;
//   LatLng destination = const LatLng(22.5972, 88.4371);
//
//   Set<Polyline> polylines = {};
//   Map<MarkerId, Marker> markers = {};
//
//   String distance = '';
//   String duration = '';
//   bool _followUser = true;
//   bool isVisible = false;
//
//   BitmapDescriptor currentIcon = BitmapDescriptor.defaultMarker;
//   BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
//
//   @override
//   void initState() {
//     super.initState();
//     _initLocationAndDirections();
//     setCustomMarkerIcons();
//   }
//
//   Future<BitmapDescriptor> getResizedMarker(String path, int width) async {
//     ByteData data = await rootBundle.load(path);
//     ui.Codec codec = await ui.instantiateImageCodec(
//       data.buffer.asUint8List(),
//       targetWidth: width,
//     );
//     ui.FrameInfo fi = await codec.getNextFrame();
//     final byteData = await fi.image.toByteData(format: ui.ImageByteFormat.png);
//     return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
//   }
//
//   void setCustomMarkerIcons() async {
//     final icon1 = await getResizedMarker("assets/images/image1.png", 90);
//     final icon2 = await getResizedMarker("assets/images/image2.png", 90);
//
//     setState(() {
//       currentIcon = icon1;
//       destinationIcon = icon2;
//     });
//   }
//
//   Future<void> _initLocationAndDirections() async {
//     bool serviceEnabled = await location.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await location.requestService();
//       if (!serviceEnabled) return;
//     }
//
//     PermissionStatus permissionGranted = await location.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await location.requestPermission();
//       if (permissionGranted != PermissionStatus.granted) return;
//     }
//
//     final currentLocation = await location.getLocation();
//     origin = LatLng(currentLocation.latitude!, currentLocation.longitude!);
//
//     if (!mounted) return;
//
//     _updateMarkers();
//     await _getTrafficColoredRoute();
//
//     _locationSubscription = location.onLocationChanged.listen((loc) async {
//       if (!mounted) return;
//       setState(() {
//         origin = LatLng(loc.latitude!, loc.longitude!);
//         _updateMarkers();
//       });
//
//       await _getTrafficColoredRoute();
//
//       if (_followUser) {
//         mapController?.animateCamera(CameraUpdate.newLatLng(origin!));
//       }
//     });
//   }
//
//   void _updateMarkers() {
//     markers[const MarkerId("origin")] = Marker(
//       markerId: const MarkerId("origin"),
//       position: origin!,
//       icon: currentIcon,
//       infoWindow: const InfoWindow(title: "Bike Location"),
//     );
//
//     markers[const MarkerId("destination")] = Marker(
//       markerId: const MarkerId("destination"),
//       position: destination,
//       icon: destinationIcon,
//       infoWindow: const InfoWindow(title: "Drop Point"),
//     );
//   }
//
//   Future<void> _getTrafficColoredRoute() async {
//     if (origin == null) return;
//
//     final url = Uri.parse(
//       'https://maps.googleapis.com/maps/api/directions/json'
//           '?origin=${origin!.latitude},${origin!.longitude}'
//           '&destination=${destination.latitude},${destination.longitude}'
//           '&key=$googleAPIKey'
//           '&mode=driving'
//           '&departure_time=now'
//           '&traffic_model=best_guess',
//     );
//
//     try {
//       final response = await http.get(url);
//       final data = jsonDecode(response.body);
//
//       if (data['status'] != 'OK') {
//         print("Google Directions API Error: ${data['status']}");
//         return;
//       }
//
//       final route = data['routes'][0]['legs'][0];
//       final steps = route['steps'];
//
//       String newDistance = route['distance']['text'];
//       String newDuration = route['duration']['text'];
//
//       Set<Polyline> trafficPolylines = {};
//       int id = 1;
//
//       for (var step in steps) {
//         final points = PolylinePoints().decodePolyline(step['polyline']['points']);
//         final latLngs = points.map((e) => LatLng(e.latitude, e.longitude)).toList();
//
//         int normal = step['duration']['value'];
//         int traffic = step['duration_in_traffic']?['value'] ?? normal;
//         double ratio = traffic / normal;
//
//         Color color;
//         if (ratio >= 1.5) {
//           color = Colors.red;
//         } else if (ratio >= 1.2) {
//           color = Colors.orange;
//         } else {
//           color = Colors.blue;
//         }
//
//         trafficPolylines.add(
//           Polyline(
//             polylineId: PolylineId("segment$id"),
//             color: color,
//             width: 6,
//             points: latLngs,
//           ),
//         );
//         id++;
//       }
//
//       if (!mounted) return;
//
//       setState(() {
//         polylines = trafficPolylines;
//         distance = newDistance;
//         duration = newDuration;
//       });
//     } catch (e) {
//       print("Error fetching directions: $e");
//     }
//   }
//
//   @override
//   void dispose() {
//     _locationSubscription?.cancel();
//     super.dispose();
//   }
//
//   void _launchPhone() async {
//     final phone = widget.phone.trim();
//     if (phone.isEmpty) {
//       Fluttertoast.showToast(msg: "Phone number is empty");
//       return;
//     }
//
//     final Uri phoneUri = Uri.parse("tel:$phone");
//
//     try {
//       if (await canLaunchUrl(phoneUri)) {
//         await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
//       } else {
//         Fluttertoast.showToast(msg: "Unable to launch phone dialer");
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: "Error: $e");
//     }
//   }
//
//
//   // void _launchPhone() async {
//   //   if (widget.phone.isEmpty) return;
//   //   final Uri phoneUri = Uri(scheme: 'tel', path: widget.phone);
//   //   if (!await launchUrl(phoneUri, mode: LaunchMode.externalApplication)) {
//   //     debugPrint('Could not open dialer');
//   //   }
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: origin == null || polylines.isEmpty
//             ? Center(
//           child: LoadingAnimationWidget.dotsTriangle(
//             color: Colors.blue,
//             size: 50,
//           ),
//         )
//             : Stack(
//           children: [
//             GoogleMap(
//               initialCameraPosition:
//               CameraPosition(target: origin!, zoom: 17),
//               polylines: polylines,
//               markers: Set<Marker>.of(markers.values),
//               onMapCreated: (controller) => mapController = controller,
//               myLocationEnabled: true,
//               myLocationButtonEnabled: true,
//               onCameraMoveStarted: () {
//                 setState(() {
//                   _followUser = false;
//                 });
//               },
//             ),
//             Positioned(
//               bottom: 0,
//               left: 0,
//               right: 0,
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.black87,
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text("Time: $duration", style: TextStyle(color: Colors.white)),
//                       Text("Distance: $distance", style: TextStyle(color: Colors.white)),
//                       const SizedBox(height: 10),
//                       Row(
//                         children: [
//                           const CircleAvatar(
//                             backgroundImage: AssetImage('assets/images/profile.png'),
//                             radius: 24,
//                           ),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(widget.name,
//                                     style: TextStyle(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold)),
//                                 Text("Delivery to ${widget.address}",
//                                     style: TextStyle(color: Colors.white70)),
//                               ],
//                             ),
//                           ),
//                           IconButton(
//                             icon: Icon(Icons.call, color: Colors.white),
//                             onPressed: _launchPhone,
//                           )
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }