import 'package:flutter/material.dart';

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
                  content: Text(
                    'Próximamente: detalles de ${actividad.titulo}.',
                  ),
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
                  // Imagen aumentada
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

                  // Título y descripción más grandes
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          actividad.titulo,
                          style: const TextStyle(
                            fontSize: 28, 
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
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
}
