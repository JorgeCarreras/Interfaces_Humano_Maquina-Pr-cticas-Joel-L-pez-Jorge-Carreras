import 'package:flutter/material.dart';
import 'actividades.dart';
import 'custom_loader.dart'; // OceanWaves

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  Future<bool> cargarDatos() async {
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool>(
        future: cargarDatos(),
        builder: (context, snapshot) {
          // Si terminó correctamente -> navega
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              snapshot.data == true) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ActividadesPage()),
              );
            });
          }

          // Si hubo error -> muestra algo (opcional, pero mejor)
          if (snapshot.hasError) {
            return Stack(
              children: [
                const Positioned.fill(child: OceanWaves()),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, size: 48),
                      const SizedBox(height: 12),
                      const Text('Error cargando datos'),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const LoadingPage()),
                          );
                        },
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          // Mientras carga (y también mientras navega) -> UI con olas + círculo
          return const Stack(
            children: [
              Positioned.fill(child: OceanWaves()),
              Center(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    strokeWidth: 10,
                    backgroundColor: Colors.pink,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
