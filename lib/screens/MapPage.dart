import 'dart:async';

import 'package:enrich/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();

  int selectIndex = -1;
  Set<Polyline> selectPolyline = new Set();

  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(28.419905, 77.039304),
    zoom: 14.4746,
  );

/*
  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(28.419905, 77.039304),
      //  tilt: 59.440717697143555,
      zoom: 1.0);
*/

  List mainList;

  @override
  void initState() {
    super.initState();

    mainList = List();

    Utils.api.getLocation().then((map) {
      print(map);
      mainList = map;

      setState(() {});
    });

    /*  Timer(Duration(seconds: 3), () {
      print('---');
      selectPolyline.add(Polyline(
          polylineId: PolylineId('2019-04-28'),
          points: [
            LatLng(28.419905, 77.039304),
            LatLng(28.420466, 77.038049),
            LatLng(28.418541, 77.036976),
          ],
          color: Colors.red));
    });*/
  }

  @override
  Widget build(BuildContext context) {
    selectPolyline.forEach((p) {
      print('##${p.points}');
      print('##${p.polylineId}');
    });

    return new Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: 400,
            child: GoogleMap(
              mapType: MapType.normal,
              polylines: selectPolyline,
              myLocationEnabled: true,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
          DropdownButton(
              value: selectIndex,
              items: getItems(),
              onChanged: (d) {
                print(d);
                selectIndex = d;
                Set<Polyline> poly = new Set<Polyline>();

                poly.add(mainList[selectIndex]['polyline']);
                selectPolyline = poly;

                mainList[selectIndex]['polyline'].points.forEach((l) {
                  print('---');
                  print(l.latitude);
                  print(l.longitude);
                });

                if (selectIndex != -1) {
                  //   print(mainList[selectIndex]['location'][0]['lat']);

                  _kGooglePlex = CameraPosition(
                    target: LatLng(mainList[selectIndex]['location'][0]['lat'],
                        mainList[selectIndex]['location'][0]['lon']),
                    zoom: 1.0,
                  );
                }

                print(selectPolyline.length);
                setState(() {});
              }),
          ListView.builder(
              itemCount: mainList.length > 0 && selectIndex!=-1
                  ? mainList[selectIndex]['location'].length
                  : 0,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('${mainList[selectIndex]['location'][index]['lat']} -- ${mainList[selectIndex]['location'][index]['lon']}'),
                );
              }),
        ],
      ),
      /*  floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),*/
    );
  }

  /* Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }*/

  List<DropdownMenuItem> getItems() {
    List<DropdownMenuItem> list = List();

    list.add(DropdownMenuItem(
      child: Text('Select Date'),
      value: -1,
    ));

    for (int i = 0; i < mainList.length; i++) {
      Map map = mainList[i];
      list.add(DropdownMenuItem(
        child: Text(map['date']),
        value: i,
      ));
    }

    print('---${list.length}');
    return list;
  }
}
