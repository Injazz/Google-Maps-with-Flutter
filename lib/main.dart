
import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'map/map_bloc.dart';
import 'map/map_event.dart';
import 'map/map_page.dart';

class MainBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }
}

void main() {
  BlocSupervisor.delegate = MainBlocDelegate();
  runApp(
    BlocProvider<MapBloc>(
      builder: (context) {
        return MapBloc()
          ..dispatch(MapLoad());
      },
      child: App(),
    ),
  );
}

class App extends StatelessWidget {

  App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MapPage()
    );
  }
}