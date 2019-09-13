import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class MapState extends Equatable {
 MapState([List props = const []]) : super(props);
}

class MapInitial extends MapState {
  @override
  String toString() => 'MapInitial';
}

class MapLoading extends MapState {
  @override
  String toString() => 'MapLoadFinished';
}

class MapLoadFailed extends MapState {
  final String error;

  MapLoadFailed({@required this.error}) : super([error]);

  @override
  String toString() => 'MapLoadFailed { error: $error }';
}

class MapMovementStarted extends MapState {
  @override
  String toString() => 'MapMovementStarted';
}

class MapMovementStopped extends MapState {
  @override
  String toString() => 'MapMovementStopped';
}

class MapMarkerTapped extends MapState {
  final double zoom;

  MapMarkerTapped({@required this.zoom}) : super([zoom]);
  
  @override
  String toString() => 'MapMarkerTapped'; 
}