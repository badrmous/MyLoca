
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Completer<GoogleMapController> _controller = Completer();


  late Position _currentPosition;
  late String _currentAddress;

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  _getAdresseFromLatlng() async {
    try{
      List<Placemark> p = await geolocator.placemarkFromCoordinates(_currentPosition.latitude, _currentPosition.longitude);
        Placemark place = p[0];
        setState(() {
          _currentAddress =
              "${place.locality} , ${place.postalCode} , ${place.country}";
        });
        print("longitude : ${_currentPosition.longitude} \n latitude : ${_currentPosition.latitude}");
        print("adresse : ${_currentAddress}");
    }catch(e){
      print(e);
    }
  }

  _getCurrentLocation(){
    geolocator
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
          setState(() {
            _currentPosition = position;
            print(position);
          });
          _getAdresseFromLatlng();

        }).catchError((e){
          print(e);
    });
  }


  static const LatLng _center = const LatLng(33.52827513783762 , -7.647955757656057);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);

  }

  void _onMapTypeButtonPressed(){
    setState(() {
      _currentMapType = _currentMapType == MapType.normal?MapType.satellite:MapType.normal;
    });
  }

  LatLng _lastMapPosition = _center;
  // LocationPermission permission = LocationPermission

  void _onCameraMove(CameraPosition position){

    print("camera is moving right now");
    _lastMapPosition = position.target;
  }
  MapType _currentMapType = MapType.normal;

  final Set<Marker> _markers = {};

  void _checkLocation(){

  }

  void _onAddMarkerButtonPressed(){
    _getCurrentLocation();
    print("longitude : ${_currentPosition.longitude} \n latitude : ${_currentPosition.latitude}");
    print("adresse : ${_currentAddress}");
      setState(() {
      _markers.add(Marker(
          markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: 'really cool place',
          snippet: '5 start rating ',
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
                      SizedBox(height: 20.0),
                      FloatingActionButton(
                        onPressed: _onAddMarkerButtonPressed,
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        backgroundColor: Colors.green,
                        child: const Icon(Icons.add_location , size: 36.0),
                      ),
                      SizedBox(height: 20.0),
                      FloatingActionButton(
                          onPressed: _getCurrentLocation,
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                          backgroundColor: Colors.green,
                        child: const Icon(Icons.location_on , size: 36.0),
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