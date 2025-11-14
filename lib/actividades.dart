import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Clase modelo
class Item {
  final int id;
  final String titulo;
  final String descripcion;
  final String imagePath;

  Item({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.imagePath,
  });
}

// Pantalla de actividades
class ActividadesPage extends StatelessWidget {
  const ActividadesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de actividades
    final List<Item> actividades = [
      Item(
        id: 1,
        titulo: 'Surf',
        descripcion: 'Clases para todos los niveles.',
        imagePath: 'assets/img/surf.jpg',
      ),
      Item(
        id: 2,
        titulo: 'Windsurf',
        descripcion: 'Aprovecha el viento y deslízate sobre las olas.',
        imagePath: 'assets/img/windsurf.jpeg',
      ),
      Item(
        id: 3,
        titulo: 'Paddle Surf',
        descripcion: 'Disfruta del mar con equilibrio y diversión.',
        imagePath: 'assets/img/paddelsurf.png',
      ),
      // NUEVA Clase WINGFOIL
      Item(
        id: 4,
        titulo: 'Wingfoil',
        descripcion: 'Descubre este nuevo deporte recien llegado de Estados Unidos',
        imagePath: 'assets/img/WingFoil.jpg',
      ),
      Item(
        id: 5,
        titulo: 'Kitesurf',
        descripcion: 'Vuela sobre el mar y disfruta de la adrenalina del viento.',
        imagePath: 'assets/img/kitesurf.jpg',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado de actividades náuticas'),
        backgroundColor: Colors.pinkAccent,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: actividades.length,
        itemBuilder: (context, index) {
          final actividad = actividades[index];

          return GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Próximamente: detalles de ${actividad.titulo}.'),
                  duration: const Duration(seconds: 2),
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
                  // Imagen
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      actividad.imagePath,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 25),

                  // Texto + Iconos FontAwesome
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Row(
                          children: [
                            // Icono según actividad
                            FaIcon(
                              _iconoActividad(actividad.titulo),
                              size: 26,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 10),

                            // TÍTULO
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
      ),
    );
  }

  // Asignar iconos diferentes por actividad
  IconData _iconoActividad(String titulo) {
    switch (titulo) {
      case 'Surf':
        return FontAwesomeIcons.water;          // Ola
      case 'Windsurf':
        return FontAwesomeIcons.wind;           // Viento
      case 'Paddle Surf':
        return FontAwesomeIcons.personSwimming; // Persona nadando
      case 'Wingfoil':
        return FontAwesomeIcons.flag;           // Bandera (vela)
      case 'Kitesurf':
      return FontAwesomeIcons.cloud; // Ráfaga / viento
      default:
        return FontAwesomeIcons.circleInfo;     // Icono genérico
    }
  }
}
