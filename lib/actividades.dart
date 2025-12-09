import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'detalle_actividad.dart';
import 'dart:convert';             // NECESARIO para jsonDecode
import 'package:flutter/services.dart'; // NECESARIO para rootBundle


class Item {
  final int id;
  final String titulo;
  final String descripcion;
  final String imagePath;

  final String precio;           
  final String duracion;         
  final String nivel;            
  final String descripcionLarga; 
  final double rating;           

  Item({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.imagePath,
    required this.precio,
    required this.duracion,
    required this.nivel,
    required this.descripcionLarga,
    required this.rating,
  });

  // NUEVO: Constructor desde JSON
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json["id"],
      titulo: json["titulo"],
      descripcion: json["descripcion"],
      imagePath: json["imagePath"],
      precio: json["precio"],
      duracion: json["duracion"],
      nivel: json["nivel"],
      descripcionLarga: json["descripcionLarga"],
      rating: (json["rating"] as num).toDouble(),
    );
  }
}


// ---------------------------------------------------------
//  FUNCIÓN PARA CARGAR ACTIVIDADES DESDE JSON
// ---------------------------------------------------------
Future<List<Item>> cargarActividades() async {
  final String data =
      await rootBundle.loadString('assets/data/actividades.json');

  final List<dynamic> jsonList = jsonDecode(data);

  return jsonList.map((json) => Item.fromJson(json)).toList();
}


// Pantalla de actividades
class ActividadesPage extends StatelessWidget {
  const ActividadesPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado de actividades náuticas'),
        backgroundColor: Colors.pinkAccent,
        centerTitle: true,
      ),

      body: FutureBuilder<List<Item>>(
        future: cargarActividades(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Error al cargar las actividades'),
            );
          }

          final actividades = snapshot.data!;

          return ListView.builder(
            itemCount: actividades.length,
            itemBuilder: (context, index) {
              final actividad = actividades[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetalleActividadPage(actividad: actividad),
                    ),
                  );
                },

                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey, width: 0.5),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Hero(
                        tag: actividad.id,
                        child: Image.asset(
                          actividad.imagePath,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),

                      const SizedBox(width: 25),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Row(
                              children: [
                                FaIcon(
                                  _iconoActividad(actividad.titulo),
                                  size: 26,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  actividad.titulo,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            Text(
                              actividad.descripcion,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );

        },
      ),
    );
  }

  // Iconos según actividad
  IconData _iconoActividad(String titulo) {
    switch (titulo) {
      case 'Surf':
        return FontAwesomeIcons.water;
      case 'Windsurf':
        return FontAwesomeIcons.wind;
      case 'Paddle Surf':
        return FontAwesomeIcons.personSwimming;
      case 'Wingfoil':
        return FontAwesomeIcons.flag;
      case 'Kitesurf':
        return FontAwesomeIcons.cloud;
      default:
        return FontAwesomeIcons.circleInfo;
    }
  }
}
