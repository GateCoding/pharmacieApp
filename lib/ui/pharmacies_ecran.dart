import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_pharmacie/models/pharmacie.dart';
import 'package:flutter_pharmacie/services/pharmacie_service.dart';
import 'package:flutter_pharmacie/ui/pharmacie_detail_page.dart';

class PharmaciesEcran extends StatefulWidget {
  const PharmaciesEcran({super.key});

  @override
  _PharmaciesEcranState createState() => _PharmaciesEcranState();
}

class _PharmaciesEcranState extends State<PharmaciesEcran> {
  void _ajouterPharmacie() async {
    final nouvellePharmacie = Pharmacie(
      nom: 'Nom de la pharmacie',
      quartier: 'Nom du quartier',
      latitude: 0.0, // Remplacer par les valeurs appropriées
      longitude: 0.0, // Remplacer par les valeurs appropriées
    );

    try {
      final pharmacieCree =
          await pharmacieService.creerPharmacie(nouvellePharmacie);
      setState(() {
        _pharmacies.add(pharmacieCree);
      });
    } catch (e) {
      log('Erreur lors de l\'ajout de la pharmacie: $e');
    }
  }

  void _supprimerPharmacie(String id) async {
    try {
      await pharmacieService.supprimerPharmacie(id);
      setState(() {
        _pharmacies.removeWhere((pharmacie) => pharmacie.id == id);
      });
    } catch (e) {
      log('Erreur lors de la suppression de la pharmacie: $e');
    }
  }

  final PharmacieService pharmacieService = PharmacieService();

  Future<List<Pharmacie>> chargerPharmacies() async {
    try {
      final pharmacies = await pharmacieService.chargerPharmacies();
      return pharmacies;
    } catch (e) {
      throw Exception('Erreur de chargement des pharmacies: $e');
    }
  }

  final List<Pharmacie> _pharmacies = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des pharmacies'),
      ),
      body: FutureBuilder<List<Pharmacie>>(
        future: chargerPharmacies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erreurrr: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Aucune pharmacie disponible.'),
            );
          } else {
            final pharmacies = snapshot.data!;
            return ListView.builder(
              itemCount: pharmacies.length,
              itemBuilder: (context, index) {
                final pharmacie = pharmacies[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PharmacieDetailPage(pharmacie: pharmacie),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text('${pharmacie.nom}'),
                    subtitle: Text('${pharmacie.quartier}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        // Ajouter la logique pour la suppression
                        _supprimerPharmacie('${pharmacie.id}');
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _ajouterPharmacie();
        },
        tooltip: 'Ajouter une pharmacie',
        child: const Icon(Icons.add),
      ),
    );
  }
}
