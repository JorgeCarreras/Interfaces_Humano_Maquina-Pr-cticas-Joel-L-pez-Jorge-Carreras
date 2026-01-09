import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'detalle_actividad.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

//  AJUSTA este import al lugar real donde guardaste Breakpoints
import 'responsive/breakpoints.dart';

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

Future<List<Item>> cargarActividades() async {
  final String data = await rootBundle.loadString('assets/data/actividades.json');
  final List<dynamic> jsonList = jsonDecode(data);
  return jsonList.map((json) => Item.fromJson(json)).toList();
}

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
            return const Center(child: Text('Error al cargar las actividades'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay actividades disponibles'));
          }

          final actividades = snapshot.data!;
          final width = MediaQuery.of(context).size.width;

          //breakpoint por anchura
          final bool isWide = width >= Breakpoints.phone;

          // decide columnas según ancho (2 tablet, 3 desktop)
          final int columns = width >= Breakpoints.tablet ? 3 : 2;

          return isWide
              ? _buildGrid(context, actividades, columns)
              : _buildList(context, actividades);
        },
      ),
    );
  }

  // -------------------------
  //  MÓVIL: LISTA
  // -------------------------
  Widget _buildList(BuildContext context, List<Item> actividades) {
    return ListView.builder(
      itemCount: actividades.length,
      itemBuilder: (context, index) {
        final actividad = actividades[index];

        return GestureDetector(
          onTap: () => _abrirDetalle(context, actividad),
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      actividad.imagePath,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 25),
                Expanded(
                  child: _InfoActividad(
                    actividad: actividad,
                    icono: _iconoActividad(actividad.titulo),
                    tituloSize: 28,
                    descripcionSize: 20,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // -------------------------
  //  TABLET/DESKTOP: GRID
  // -------------------------
  Widget _buildGrid(BuildContext context, List<Item> actividades, int columns) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: actividades.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.45,
      ),
      itemBuilder: (context, index) {
        final actividad = actividades[index];

        return InkWell(
          onTap: () => _abrirDetalle(context, actividad),
          borderRadius: BorderRadius.circular(16),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Hero(
                    tag: actividad.id,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        actividad.imagePath,
                        width: 110,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _InfoActividad(
                      actividad: actividad,
                      icono: _iconoActividad(actividad.titulo),
                      // en grid bajamos un poco el tamaño para que no desborde
                      tituloSize: 22,
                      descripcionSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _abrirDetalle(BuildContext context, Item actividad) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetalleActividadPage(actividad: actividad),
      ),
    );
  }

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

// Widget reutilizable para texto + icono (mismo look en list y grid)
class _InfoActividad extends StatelessWidget {
  final Item actividad;
  final IconData icono;
  final double tituloSize;
  final double descripcionSize;

  const _InfoActividad({
    required this.actividad,
    required this.icono,
    required this.tituloSize,
    required this.descripcionSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            FaIcon(icono, size: 24, color: Colors.blue),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                actividad.titulo,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: tituloSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          actividad.descripcion,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: descripcionSize,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
