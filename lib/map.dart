import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Karta extends StatefulWidget {
  @override
  State<Karta> createState() => _KartaState();
}

class _KartaState extends State<Karta> {

  double curr_zoom = 16.5;
  MapController mapController = MapController();
  LatLng currentCenter = LatLng(42.640838, 18.109043);
  LatLng sv_vlaho_point = LatLng(42.640807, 18.1101376);
  LatLng katedrala_point = LatLng(42.639938, 18.110465);
  LatLng mala_braca_point = LatLng(42.641947, 18.107670);

  void zoom_map_in(){
    curr_zoom += 0.5;
    mapController.move(currentCenter, curr_zoom);
  }

  void zoom_map_out(){
    curr_zoom -= 0.5;
    mapController.move(currentCenter, curr_zoom);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Karta'),
        centerTitle: true,
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          center: currentCenter, // Coordinates for Dubrovnik, Old Town
          zoom: curr_zoom,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                  point: sv_vlaho_point,
                  width: 50,
                  height: 50,
                  builder: (ctx) => new Container(
                    child: IconButton(
                      icon: const Icon(Icons.church),
                      color: Colors.black,
                      iconSize: 50,
                      //onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => SvetiVlaho()));},
                      onPressed: (){},
                      tooltip: 'Crkva sv. Vlaha',
                    ),
                  )
              ),
              Marker(
                  point: katedrala_point,
                  width: 50,
                  height: 50,
                  builder: (ctx) => new Container(
                    child: IconButton(
                      icon: const Icon(Icons.church),
                      color: Colors.black,
                      iconSize: 50,
                      //onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => Katedrala()));},
                      onPressed: (){},
                      tooltip: 'Katedrala',
                    ),
                  )
              ),
              Marker(
                  point: mala_braca_point,
                  width: 50,
                  height: 50,
                  builder: (ctx) => new Container(
                    child: IconButton(
                      icon: const Icon(Icons.church),
                      color: Colors.black,
                      iconSize: 50,
                      //onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => MalaBraca()));},
                      onPressed: (){},
                      tooltip: "Samostan Male braće",
                    ),
                  )
              ),
            ],
          ),
        ],
      ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: zoom_map_in,
              tooltip: 'Zoom in',
              child: const Icon(Icons.add),
            ),
            const SizedBox(height: 20,),
            FloatingActionButton(
              onPressed: zoom_map_out,
              tooltip: 'Zoom out',
              child: const Icon(Icons.remove),
            )
          ],
        )
    );
  }
}
