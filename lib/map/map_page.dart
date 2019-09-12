import 'dart:async';
import 'dart:math';

import 'map_bloc.dart';
import 'map_state.dart';
import 'map_event.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;

  LocationData currentLocation;
  double _currentZoom = 12.0;

  Set<Marker> markers = Set();

  MapBloc _bloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _bloc = Provider.of<MapBloc>(context);

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
    _bloc.dispatch(MapLoad());
  }

    // May be called as often as every frame, so just track the last zoom value.
  void _onCameraMove(CameraPosition cameraPosition) {
    _currentZoom = cameraPosition.zoom;
    
  }

  void _onCameraIdle() {
    _bloc.dispatch(MapMovementStart(zoom: _currentZoom));
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