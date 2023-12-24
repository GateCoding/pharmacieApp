import 'package:flutter/material.dart';
import 'package:flutter_pharmacie/models/pharmacie.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

class PharmacieDetailPage extends StatelessWidget {
  final Pharmacie pharmacie;

  const PharmacieDetailPage({super.key, required this.pharmacie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pharmacie.nom ?? 'Détails de la pharmacie'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nom: ${pharmacie.nom ?? 'N/A'}'),
            Text('Quartier: ${pharmacie.quartier ?? 'N/A'}'),
            SizedBox(
              height: 300, // Adjust the height according to your layout
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(
                      pharmacie.latitude ?? 0.0, pharmacie.longitude ?? 0.0),
                  initialZoom: 10.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                    userAgentPackageName: 'com.example.flutter_pharmacie',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                          point: LatLng(pharmacie.latitude ?? 0.0,
                              pharmacie.longitude ?? 0.0),
                          width: 80,
                          height: 80,
                          child: const FlutterLogo())
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
