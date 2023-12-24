import 'package:uuid/uuid.dart';

class Pharmacie {
  String? id; // Mappé à recordid
  String? nom; // Mappé à pharmacie
  String? quartier; // Mappé à quartier
  double? latitude;
  double? longitude;

  Pharmacie({
    String? id,
    required this.nom,
    required this.quartier,
    required this.latitude,
    required this.longitude,
  }) : id = id ?? const Uuid().v4();

  Pharmacie.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? const Uuid().v4();
    quartier = json['fields']['quartier'];
    latitude = double.parse(json['fields']['latitude']);
    nom = json['fields']['pharmacie'];
    longitude = double.parse(json['fields']['longitude']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['quartier'] = quartier;
    data['latitude'] = latitude;
    data['pharmacie'] = nom;
    data['longitude'] = longitude;
    return data;
  }
}
