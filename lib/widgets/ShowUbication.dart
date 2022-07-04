import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShowUbication extends StatefulWidget {
  final String? title;
  final String? snippet;
  final String latitud;
  final String longitud;
  const ShowUbication({Key? key, required this.latitud,required this.longitud, this.title, this.snippet}) : super(key: key);

  @override
  _ShowUbicationState createState() => _ShowUbicationState();
}

class _ShowUbicationState extends State<ShowUbication> {
  late GoogleMapController mapController;
  late LatLng _center;
  late final Marker? marker;
  @override
  void initState() {
    // TODO: implement initState

    _center = LatLng(double.parse(widget.latitud),double.parse(widget.longitud) );
    marker = Marker(
        markerId: MarkerId("someid"),
        position: _center,
        infoWindow: widget.title != null ? InfoWindow(
            title: widget.title,
            snippet: widget.snippet
        ): InfoWindow() ,
    );
    print(_center);
  }
  void _onMapCreated(GoogleMapController controller) {

    mapController = controller;

    print("ubicacion : $_center");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 14,
          ),
          markers: <Marker>{marker!},
        ),
      ),
    );
  }
}