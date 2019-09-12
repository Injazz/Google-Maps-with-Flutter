import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class MapEvent extends Equatable {
  MapEvent([List props = const []]) : super(props);
}

class MapLoad extends MapEvent { 
  @override
  String toString() =>
      'MapLoaded event';
}

class MapMarkerTap extends MapEvent {
  final double addZoom;

  MapMarkerTap({
    @required this.addZoom
  }) : super([addZoom]);

  @override
  String toString() =>
      'MapMarkerTapped event';
}

class MapMovementStart extends MapEvent { 
  final double zoom;

  MapMovementStart({
    @required this.zoom
  }) : super([zoom]);

  @override
  String toString() =>
      'MapMovementStarted event';
}

class MapMovementStop extends MapEvent { 
  @override
  String toString() =>
      'MapMovementStopped event';
}

