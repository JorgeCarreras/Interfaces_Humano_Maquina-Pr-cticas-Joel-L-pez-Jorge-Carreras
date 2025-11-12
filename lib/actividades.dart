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
    final Item surf = Item(
      id: 1,
      titulo: 'Surf',
      descripcion: 'Clases para todos los niveles.',
      imagePath: 'assets/img/surf.jpg', // imagen local
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado de actividades náuticas'),
        backgroundColor: Colors.pinkAccent,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              surf.imagePath,
              width: 300,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            Text(
              surf.titulo,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              surf.descripcion,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
