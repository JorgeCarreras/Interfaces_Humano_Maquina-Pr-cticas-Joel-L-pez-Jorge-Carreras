import 'package:flutter/material.dart';
import 'actividades.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  // Simulamos una carga de datos asíncrona
  Future<bool> cargarDatos() async {
    await Future.delayed(const Duration(seconds: 2)); // Simula espera
    return true; // Devuelve algo al terminar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: cargarDatos(),
        builder: (context, snapshot) {
          // Mientras el Future NO ha terminado (esperando)
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                width: 200,
                height: 200,
                child: CircularProgressIndicator(
                  strokeWidth: 10,
                  backgroundColor: Colors.pink,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              ),
            );
          }

          // Cuando el Future termina correctamente
          if (snapshot.connectionState == ConnectionState.done) {
            // Navegación automática a ActividadesPage
            Future.microtask(() {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const ActividadesPage()),
              );
            });
          }

          // Mientras redirige, devolvemos pantalla vacía
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
