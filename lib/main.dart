import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(33.543614, -7.618480);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }
  void _onMapTypeButtonPressed(){
    setState(() {
      _currentMapType = _currentMapType == MapType.normal?MapType.satellite:MapType.normal;
    });
  }


  LatLng _lastMapPosition = _center;

  void _onCameraMove(CameraPosition position){
    _lastMapPosition = position.target;
  }
  MapType _currentMapType = MapType.normal;

  final Set<Marker> _markers = {};

  void _onAddMarkerButtonPressed(){
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: 'really cool place',
          snippet: '5 start rating',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      )
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('My Loca'),
          backgroundColor: Colors.red[700],
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
              mapType: _currentMapType,
              markers: _markers,
              onCameraMove: _onCameraMove,
            ),
            Padding(
                padding: const EdgeInsets.all(16.0),
              child:
              Align(
                alignment: Alignment.topRight,
                child:Column(
                    children: <Widget>[
                      FloatingActionButton(
                        onPressed: () => _onMapTypeButtonPressed(),
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        backgroundColor: Colors.green,
                        child: const Icon(Icons.map , size: 36.0),
                      ),
                      SizedBox(height: 40.0),
                      FloatingActionButton(
                        onPressed: _onAddMarkerButtonPressed,
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        backgroundColor: Colors.green,
                        child: const Icon(Icons.add_location , size: 36.0),
                      )
                    ],
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}