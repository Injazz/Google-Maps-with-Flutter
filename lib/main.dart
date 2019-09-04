import 'dart:async';
import 'dart:math';
import 'main_bloc.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<MainBloc>(
      builder: (context) => MainBloc(),
      dispose: (context, mainBloc) => mainBloc.dispose(),
      child: MaterialApp(
        title: 'Google Map Clusterization Test',
        home: MapSample(),
        theme: ThemeData(
          primaryColor: Colors.white,
        ),
      ),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;

  LocationData currentLocation;
  double _currentZoom = 12.0;

  Set<Marker> markers = Set();

  MainBloc _bloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _bloc = Provider.of<MainBloc>(context);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Random Markers"),
      ),
      body: StreamBuilder<Map<MarkerId, Marker>>(
        stream: _bloc.markers,
        builder: (context, snapshot) {
          return Stack(
            children: <Widget>[
              GoogleMap(
                mapType: MapType.normal,
                myLocationEnabled: false,
                myLocationButtonEnabled: false,
                initialCameraPosition: CameraPosition(target: LatLng(56.8389,60.6057), zoom: 12.0),
                onMapCreated: (GoogleMapController controller) {
                  _onMapCreated(controller);
                },
                onCameraMove: _onCameraMove,
                onCameraIdle: _onCameraIdle,
                markers: (snapshot.data != null) ? Set.of(snapshot.data.values) : Set(),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 75,
                  height: 202,
                  padding: EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white
                  ),
                  child: Column(
                    children: <Widget>[
                      MaterialButton(
                        child: Icon(Icons.update),
                        onPressed: (){},
                      ),
                      MaterialButton(
                        child: Icon(Icons.group_add),
                        onPressed: () {},
                      ),
                      MaterialButton(
                        child: Icon(Icons.group_work),
                        onPressed: () {},
                      ),
                      MaterialButton(
                        child: Icon(Icons.headset),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.gps_fixed),
        onPressed: moveCameraToOurPosition,
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    print("onMapCreated");
    mapController = controller;
    moveCameraToOurPosition();
    _controller.complete(mapController);
  }

    // May be called as often as every frame, so just track the last zoom value.
  void _onCameraMove(CameraPosition cameraPosition) {
    _currentZoom = cameraPosition.zoom;
  }

  void _onCameraIdle() {
    _bloc.setCameraZoom(_currentZoom);
  }

  void moveCameraToOurPosition() async {
    Location().getLocation().then((location) {
      mapController?.moveCamera(
          CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(
                location.latitude,
                location.longitude,
            ),
            zoom: 10.0,
          ),
        ),
      );
    });
  }
}