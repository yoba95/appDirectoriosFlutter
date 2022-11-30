import 'dart:async';

import 'package:conexio_dart_api/res/color.dart';
import 'package:conexio_dart_api/res/components/round_button.dart';
import 'package:conexio_dart_api/utils/routes/routes_name.dart';
import 'package:conexio_dart_api/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetLocations extends StatefulWidget {
  const GetLocations({super.key});

  @override
  State<GetLocations> createState() => _GetLocationsState();
}

class _GetLocationsState extends State<GetLocations> {
  final TextEditingController _coordenadas = TextEditingController();
  final TextEditingController _lat = TextEditingController();
  final TextEditingController _long = TextEditingController();
  FocusNode latitud = FocusNode();
  FocusNode longitud = FocusNode();
  Completer<GoogleMapController> _controller = Completer();
  var _botonLocatitation = false;
  var _mylocalitation = false;
  // on below line we have specified camera position
  static CameraPosition _kGoogle = CameraPosition(
    target: LatLng(17.060668, -96.725646),
    zoom: 14.4746,
  );

  final List<Marker> _markers = <Marker>[];

  //Location _location = Location();
  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      if (kDebugMode) {
        print("ERROR" + error.toString());
      }
    });
    setState(() {
      if (_mylocalitation != true || _botonLocatitation != true) {
        _mylocalitation = true;
        _botonLocatitation = true;
      }
    });
    if (kDebugMode) {
      print("My position desde el future: ${_mylocalitation}");
    }
    return await Geolocator.getCurrentPosition();
  }

  void _locateCurrent() {
    if (kDebugMode) {
      print("My position desde el future: ${_mylocalitation}");
    }
    getUserCurrentLocation().then((value) async {
      if (kDebugMode) {
        print("${value.latitude} ${value.longitude}");
      }

      // marker added for current users location
      _markers.add(Marker(
        markerId: MarkerId("2"),
        position: LatLng(value.latitude, value.longitude),
        infoWindow: InfoWindow(
          title: 'My Current Location',
        ),
      ));
      _mylocalitation = true;
      _botonLocatitation = true;
      _lat.text = value.latitude.toString();

      _long.text = value.longitude.toString();
      _kGoogle = new CameraPosition(
          target: LatLng(value.latitude, value.longitude), zoom: 20);

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(_kGoogle));
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    getUserCurrentLocation();
    _locateCurrent();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
          title: Text("Ubicacion"),
          centerTitle: true,
          backgroundColor: AppColors.grenSnackBar),
      body: Container(
        //color: const Color(0xffeeee00), // Yellow
        height: MediaQuery.of(context).size.height,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    //TextImput
                    Container(
                        // A fixed-height child.
                        //color: Color.fromARGB(255, 214, 34, 18), // Yellow
                        height: 200.0,
                        alignment: Alignment.center,
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 10.0),
                              height: 80,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 16),
                              child: TextFormField(
                                controller: _lat,
                                focusNode: latitud,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: 'Latitud',
                                  labelText: 'Latitud',
                                  prefixIcon: Icon(Icons.location_searching),
                                ),
                                onEditingComplete: () =>
                                    Utils.fielFocusGeneral(context, latitud),
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 10.0),
                              height: 80,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 16),
                              child: TextFormField(
                                controller: _long,
                                focusNode: longitud,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: 'Longitud',
                                  labelText: 'Longitud',
                                  prefixIcon: Icon(Icons.location_searching),
                                ),
                                onEditingComplete: () =>
                                    Utils.fielFocusGeneral(context, longitud),
                                textInputAction: TextInputAction.next,
                              ),
                            )
                          ],
                        )),
                    //Map
                    Container(
                      // Another fixed-height child.
                      //color: const Color(0xff008000), // Green
                      height: MediaQuery.of(context).size.height,
                      alignment: Alignment.topCenter,
                      child: Stack(children: <Widget>[
                        Container(
                          //color: Colors.black,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 20.0),
                          height: MediaQuery.of(context).size.height,
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 16),
                          width: MediaQuery.of(context).size.width,
                          child: GoogleMap(
                            initialCameraPosition: _kGoogle,
                            markers: Set<Marker>.of(_markers),
                            mapType: MapType.normal,
                            zoomControlsEnabled: true,
                            buildingsEnabled: true,
                            compassEnabled: true,
                            rotateGesturesEnabled: true,
                            scrollGesturesEnabled: true,
                            onMapCreated: (GoogleMapController controller) {
                              _controller.complete(controller);
                            },
                            myLocationButtonEnabled: _botonLocatitation,
                            myLocationEnabled: _mylocalitation,
                          ),
                        ),
                        Container(
                          // Another fixed-height child.
                          ///color: Color.fromARGB(255, 35, 72, 136), // Green
                          height: 100,
                          alignment: Alignment.center,
                          child: FloatingActionButton.extended(
                            onPressed: () {
                              _locateCurrent();
                              if (kDebugMode) {
                                print(_locateCurrent);
                              }
                            },
                            label: const Text('Ubicacion Actual'),
                            icon: const Icon(Icons.location_on),
                            backgroundColor: Colors.blue,
                          ),
                        ),
                        //FloatingActionButtonLocation.endTop,
                      ]),
                    ),

                    //button
                    Container(
                      // Another fixed-height child.
                      ///color: Color.fromARGB(255, 35, 72, 136), // Green
                      height: 100,
                      alignment: Alignment.center,
                      child: FloatingActionButton.extended(
                        onPressed: () {
                          if (_lat.text.isEmpty || _long.text.isEmpty) {
                            Utils.flushBarErrorMessage(
                                "Antes de continuar asegurese de obtener las coordenadas",
                                context);
                          } else {
                            Map data = {
                              'latitud': _lat.text.toString(),
                              'longitud': _long.text.toString(),
                            };
                            Navigator.pushNamed(
                                context, RoutesName.datDirectorview);
                            // addSchoolViewModel.addSchoolApi(data, context);
                            print("Api agregar escuela");
                          }
                        },
                        label: const Text('Siguiente'),
                        icon: const Icon(Icons.navigate_next),
                        backgroundColor: AppColors.grenSnackBar,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
