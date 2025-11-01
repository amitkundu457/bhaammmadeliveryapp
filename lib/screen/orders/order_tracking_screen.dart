import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' hide PermissionStatus;
import '../../utils/default_colors.dart';

class OrderTrackingPage extends StatefulWidget {
  final String name;
  final String address;
  final String phone;

  const OrderTrackingPage({super.key,
    required this.name,
    required this.address,
    required this.phone});

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  GoogleMapController? mapController;
  bool isVisible = false;
  Location location = Location();
  String googleAPIKey = 'AIzaSyBHT9ARgpTJIEdvsiaD72Gf7SUUXz-Xqfg';

  // String googleAPIKey = 'AIzaSyDPbGzcvHYuIK2boIPD8VVuzWf8_g3tDs0';

  LatLng? origin;
  LatLng destination = const LatLng(22.5372, 88.3231);

  Set<Polyline> polylines = {};
  Map<MarkerId, Marker> markers = {};

  String distance = '';
  String duration = '';
  bool _followUser = true;
  BitmapDescriptor currentIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;

  // BitmapDescriptor? bikeIcon;

  @override
  void initState() {
    super.initState();
    _initLocationAndDirections();
    setCustomMarkerIcons();
  }

  Future<BitmapDescriptor> getResizedMarker(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    final byteData = await fi.image.toByteData(format: ui.ImageByteFormat.png);
    final resizedImageBytes = byteData!.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(resizedImageBytes);
  }

  void setCustomMarkerIcons() async {
    final icon1 = await getResizedMarker(
        "assets/images/image1.png", 90); // user
    final icon2 = await getResizedMarker(
        "assets/images/image2.png", 90); // destination

    setState(() {
      currentIcon = icon1;
      destinationIcon = icon2;
    });
  }

  Future<void> _initLocationAndDirections() async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    final currentLocation = await location.getLocation();
    origin = LatLng(currentLocation.latitude!, currentLocation.longitude!);

    _updateMarkers();
    await _getTrafficColoredRoute();

    location.onLocationChanged.listen((loc) {
      if (!mounted) return; // 🛑 Prevent setState after dispose
      setState(() {
        origin = LatLng(loc.latitude!, loc.longitude!);
        _updateMarkers();
      });
      _getTrafficColoredRoute();

      //   mapController?.animateCamera(CameraUpdate.newLatLng(origin!));
      // Only center map if user hasn't interacted
      if (_followUser) {
        mapController?.animateCamera(CameraUpdate.newLatLng(origin!));
      }
    });
  }

  void _updateMarkers() {
    markers[const MarkerId("origin")] = Marker(
      markerId: const MarkerId("origin"),
      position: origin!,
      icon: currentIcon, // Use the bike icon
      infoWindow: const InfoWindow(title: "Bike Location"),
    );

    markers[const MarkerId("destination")] = Marker(
      markerId: const MarkerId("destination"),
      position: destination,
      icon: destinationIcon, // Use an orange marker for the destination
      infoWindow: const InfoWindow(title: "Drop Point"),
    );
  }

  Future<void> _getTrafficColoredRoute() async {
    final url = Uri.parse('https://maps.googleapis.com/maps/api/directions/json'
        '?origin=${origin!.latitude},${origin!.longitude}'
        '&destination=${destination.latitude},${destination.longitude}'
        '&key=$googleAPIKey'
        '&mode=driving'
        '&departure_time=now'
        '&traffic_model=best_guess');

    final response = await http.get(url);
    final data = jsonDecode(response.body);

    if (data['status'] != 'OK') return;

    final steps = data['routes'][0]['legs'][0]['steps'];
    final route = data['routes'][0]['legs'][0];
    distance = route['distance']['text'];
    duration = route['duration']['text'];

    Set<Polyline> trafficPolylines = {};
    int id = 1;

    for (var step in steps) {
      final points = PolylinePoints.decodePolyline(
          step['polyline']['points']);
      final latLngs = points.map((e) => LatLng(e.latitude, e.longitude))
          .toList();

      int normal = step['duration']['value'];
      int traffic = step['duration_in_traffic']?['value'] ?? normal;

      double ratio = traffic / normal;

      Color color;
      if (ratio >= 1.5) {
        color = Colors.red; // heavy traffic
      } else if (ratio >= 1.2) {
        color = Colors.orange; // moderate traffic
      } else {
        color = Colors.blue; // light or no traffic
      }

      trafficPolylines.add(
        Polyline(
          polylineId: PolylineId("segment$id"),
          color: color,
          width: 6,
          points: latLngs,
        ),
      );
      id++;
    }

    setState(() {
      polylines = trafficPolylines;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: origin == null
            ? Center(
          child: LoadingAnimationWidget.dotsTriangle(
            color: DefaultColor.mainColor,
            size: 50,
          ),
        )
            : Stack(
          children: [
            GoogleMap(
              initialCameraPosition:
              CameraPosition(target: origin!, zoom: 17),

              // zoomGesturesEnabled: true,
              // scrollGesturesEnabled: true,
              // rotateGesturesEnabled: true,
              // tiltGesturesEnabled: true,
              // myLocationEnabled: false,
              // myLocationButtonEnabled: true,
              // zoomControlsEnabled: false,
              // trafficEnabled: false,

              polylines: polylines,
              markers: Set<Marker>.of(markers.values),
              onMapCreated: (controller) => mapController = controller,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onCameraMoveStarted: () {
                setState(() {
                  _followUser = false;
                });
              },
            ),
            isVisible == false
                ? Container()
                : Positioned(
              top: 75,
              right: 12,
              child: Container(
                width: 39,
                height: 39,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isVisible = !isVisible;
                        print(isVisible);
                      });
                    },
                    child: Icon(
                      Icons.zoom_out_map,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ),
            ),
            isVisible
                ? Container()
                : Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color: DefaultColor.mainColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  isVisible = !isVisible!;
                                  print(isVisible);
                                });
                              },
                              child: const Icon(
                                Icons.zoom_in_map,
                                color: Colors.white,
                              ),
                            )),
                        Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            //const Icon(Icons.access_time, color: Colors.white),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$duration',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  'total time',
                                  style: TextStyle(
                                      color: Colors.white70),
                                ),
                                Text(
                                  '$distance',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  'total distance',
                                  style: TextStyle(
                                      color: Colors.white70),
                                ),
                              ],
                            ),
                            const Spacer(),
                            const Icon(Icons.location_on,
                                color: Colors.white),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.address,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    'Delivery place',
                                    style: TextStyle(
                                        color: Colors.white70),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Divider(
                          color: DefaultColor.border.withOpacity(0.5),
                        ),
                        const SizedBox(height: 35),
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundImage: AssetImage(
                                  'assets/images/profile.png'),
                              radius: 24,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  'Customer',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),

                            CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.white.withOpacity(0.1),
                              child: IconButton(
                                icon: const Icon(
                                    Icons.phone, color: Colors.white),
                                onPressed: () async {
                                  final number = widget.phone.trim();

                                  if (number.isNotEmpty) {
                                    // Ask runtime permission
                                    if (await Permission.phone
                                        .request()
                                        .isGranted) {
                                      await FlutterPhoneDirectCaller.callNumber(
                                          number);
                                    } else {
                                      debugPrint(
                                          "Phone permission not granted");
                                    }
                                  }
                                },
                              ),
                            )

                            // CircleAvatar(
                            //   radius: 24, // Adjust size as needed
                            //
                            //   backgroundColor: Colors.white
                            //       .withOpacity(
                            //           0.1), // Background color
                            //   child: IconButton(
                            //     icon: const Icon(Icons.phone,
                            //         color: Colors.white),
                            //     onPressed: () {
                            //     },
                            //   ),
                            // )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }
}



// import 'dart:convert';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'dart:math' as math; // 🔥 For bearing calculation
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:http/http.dart' as http;
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:location/location.dart';
// import '../../utils/default_colors.dart';
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
//   bool isVisible = false;
//   Location location = Location();
//   String googleAPIKey = 'AIzaSyBHT9ARgpTJIEdvsiaD72Gf7SUUXz-Xqfg';
//
//   LatLng? origin;
//   LatLng destination = const LatLng(22.5372, 88.3231);
//
//   Set<Polyline> polylines = {};
//   Map<MarkerId, Marker> markers = {};
//
//   String distance = '';
//   String duration = '';
//   bool _followUser = true;
//   BitmapDescriptor currentIcon = BitmapDescriptor.defaultMarker;
//   BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
//
//   LatLng? _lastLocation; // 🔥 for bearing calculation
//
//   @override
//   void initState() {
//     super.initState();
//     _initLocationAndDirections();
//     setCustomMarkerIcons();
//   }
//
//   // 🔥 Resize custom marker (bike/house)
//   Future<BitmapDescriptor> getResizedMarker(String path, int width) async {
//     ByteData data = await rootBundle.load(path);
//     ui.Codec codec = await ui.instantiateImageCodec(
//       data.buffer.asUint8List(),
//       targetWidth: width,
//     );
//     ui.FrameInfo fi = await codec.getNextFrame();
//     final byteData = await fi.image.toByteData(format: ui.ImageByteFormat.png);
//     final resizedImageBytes = byteData!.buffer.asUint8List();
//     return BitmapDescriptor.fromBytes(resizedImageBytes);
//   }
//
//   void setCustomMarkerIcons() async {
//     final icon1 = await getResizedMarker("assets/images/image1.png", 90); // bike
//     final icon2 = await getResizedMarker("assets/images/image2.png", 90); // house
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
//     //_updateMarkers();
//     await _getTrafficColoredRoute();
//
//     // 🔥 Live location listener
//     location.onLocationChanged.listen((loc) {
//       if (!mounted) return;
//
//       LatLng newLoc = LatLng(loc.latitude!, loc.longitude!);
//
//       // ✅ Snap to polyline (so bike stays on road)
//       if (polylines.isNotEmpty) {
//         List<LatLng> polyPoints = polylines.first.points;
//         newLoc = _getNearestPointOnPolyline(newLoc, polyPoints);
//       }
//
//       // ✅ Calculate bearing (bike facing direction)
//       double rotation = 0.0;
//       if (_lastLocation != null) {
//         rotation = _calculateBearing(_lastLocation!, newLoc);
//       }
//
//       setState(() {
//         origin = newLoc;
//         _lastLocation = newLoc;
//
//         markers[const MarkerId("origin")] = Marker(
//           markerId: const MarkerId("origin"),
//           position: newLoc,
//           icon: currentIcon,
//           rotation: rotation, // ✅ bike face set
//           anchor: const Offset(0.5, 0.5),
//         );
//
//         markers[const MarkerId("destination")] = Marker(
//           markerId: const MarkerId("destination"),
//           position: destination,
//           icon: destinationIcon,
//         );
//       });
//
//       if (_followUser) {
//         mapController?.animateCamera(CameraUpdate.newLatLng(newLoc));
//       }
//     });
//   }
//
//   // 🔥 Helper: nearest point on polyline (snap to road)
//   LatLng _getNearestPointOnPolyline(LatLng current, List<LatLng> polylinePoints) {
//     LatLng nearestPoint = polylinePoints.first;
//     double minDistance = double.infinity;
//
//     for (var point in polylinePoints) {
//       double distance = _calculateDistance(current, point);
//       if (distance < minDistance) {
//         minDistance = distance;
//         nearestPoint = point;
//       }
//     }
//
//     return nearestPoint;
//   }
//
//   // 🔥 Distance calc (Haversine formula)
//   double _calculateDistance(LatLng p1, LatLng p2) {
//     const double R = 6371000;
//     double dLat = (p2.latitude - p1.latitude) * math.pi / 180;
//     double dLon = (p2.longitude - p1.longitude) * math.pi / 180;
//     double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
//         math.cos(p1.latitude * math.pi / 180) *
//             math.cos(p2.latitude * math.pi / 180) *
//             math.sin(dLon / 2) *
//             math.sin(dLon / 2);
//     double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
//     return R * c;
//   }
//
//   // 🔥 Bearing calculation
//   double _calculateBearing(LatLng start, LatLng end) {
//     double lat1 = start.latitude * math.pi / 180;
//     double lon1 = start.longitude * math.pi / 180;
//     double lat2 = end.latitude * math.pi / 180;
//     double lon2 = end.longitude * math.pi / 180;
//
//     double dLon = lon2 - lon1;
//     double y = math.sin(dLon) * math.cos(lat2);
//     double x = math.cos(lat1) * math.sin(lat2) -
//         math.sin(lat1) * math.cos(lat2) * math.cos(dLon);
//
//     double bearing = math.atan2(y, x);
//     return (bearing * 180 / math.pi + 360) % 360;
//   }
//
//   // 🔥 Get traffic-colored route
//   Future<void> _getTrafficColoredRoute() async {
//     final url = Uri.parse(
//         'https://maps.googleapis.com/maps/api/directions/json'
//             '?origin=${origin!.latitude},${origin!.longitude}'
//             '&destination=${destination.latitude},${destination.longitude}'
//             '&key=$googleAPIKey'
//             '&mode=driving'
//             '&departure_time=now'
//             '&traffic_model=best_guess');
//
//     final response = await http.get(url);
//     final data = jsonDecode(response.body);
//
//     if (data['status'] != 'OK') return;
//
//     final steps = data['routes'][0]['legs'][0]['steps'];
//     final route = data['routes'][0]['legs'][0];
//     distance = route['distance']['text'];
//     duration = route['duration']['text'];
//
//     Set<Polyline> trafficPolylines = {};
//     int id = 1;
//
//     for (var step in steps) {
//       //final points = PolylinePoints().decodePolyline(step['polyline']['points']);
//       final points = PolylinePoints.decodePolyline(step['polyline']['points']);
//       final latLngs = points.map((e) => LatLng(e.latitude, e.longitude)).toList();
//
//       int normal = step['duration']['value'];
//       int traffic = step['duration_in_traffic']?['value'] ?? normal;
//
//       double ratio = traffic / normal;
//       Color color;
//       if (ratio >= 1.5) {
//         color = Colors.red;
//       } else if (ratio >= 1.2) {
//         color = Colors.orange;
//       } else {
//         color = Colors.blue;
//       }
//
//       trafficPolylines.add(
//         Polyline(
//           polylineId: PolylineId("segment$id"),
//           color: color,
//           width: 6,
//           points: latLngs,
//         ),
//       );
//       id++;
//     }
//
//     setState(() {
//       polylines = trafficPolylines;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: origin == null
//             ? Center(
//           child: LoadingAnimationWidget.dotsTriangle(
//             color: DefaultColor.mainColor,
//             size: 50,
//           ),
//         )
//             : GoogleMap(
//           initialCameraPosition: CameraPosition(target: origin!, zoom: 17),
//           polylines: polylines,
//           markers: Set<Marker>.of(markers.values),
//           onMapCreated: (controller) => mapController = controller,
//           myLocationEnabled: true,
//           myLocationButtonEnabled: true,
//           onCameraMoveStarted: () {
//             setState(() {
//               _followUser = false;
//             });
//           },
//         ),
//       ),
//     );
//   }
// }

