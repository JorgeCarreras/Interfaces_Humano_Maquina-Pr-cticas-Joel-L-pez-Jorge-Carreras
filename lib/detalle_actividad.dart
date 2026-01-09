import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'actividades.dart';

class DetalleActividadPage extends StatelessWidget {
  final Item actividad;

  const DetalleActividadPage({super.key, required this.actividad});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 171, 165, 255),
              Color.fromARGB(255, 255, 244, 224),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [

                // IMAGEN
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Hero(
                      tag: actividad.id,
                      child: Image.asset(
                        actividad.imagePath,
                        width: double.infinity,
                        height: 500,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                // TARJETA INFO
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        children: [
                          FaIcon(FontAwesomeIcons.water,
                              color: Colors.blue.shade700, size: 28),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              actividad.titulo,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          )
                        ],
                      ),

                      const SizedBox(height: 20),

                      Text(
                        actividad.descripcionLarga,
                        style: const TextStyle(
                          fontSize: 18,
                          height: 1.4,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 25),
                      Container(
                        height: 2,
                        width: double.infinity,
                        color: Colors.orange.withOpacity(0.4),
                      ),
                      const SizedBox(height: 25),

                      _infoRow(FontAwesomeIcons.euroSign, "Precio", actividad.precio),
                      const SizedBox(height: 15),
                      _infoRow(FontAwesomeIcons.clock, "Duración", actividad.duracion),
                      const SizedBox(height: 15),
                      _infoRow(FontAwesomeIcons.personSwimming, "Nivel", actividad.nivel),
                      const SizedBox(height: 15),
                      _infoRow(FontAwesomeIcons.star, "Valoración",
                          actividad.rating.toString()),

                      const SizedBox(height: 30),

                      // 🔥 BOTÓN RESERVAR
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.event_available),
                          label: const Text("Reservar"),
                          onPressed: () async {
                            final horario =
                                await _mostrarDialogoHorario(context);

                            if (horario == null) return;

                            await _mostrarDialogoConfirmacion(
                              context,
                              horario,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icono, String titulo, String valor) {
    return Row(
      children: [
        FaIcon(icono, size: 22, color: Colors.blue.shade700),
        const SizedBox(width: 12),
        Text(
          "$titulo: ",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(valor, style: const TextStyle(fontSize: 20)),
        ),
      ],
    );
  }
}

/// ----------------------
/// DIALOGO 1: ELEGIR HORARIO
/// ----------------------
Future<String?> _mostrarDialogoHorario(BuildContext context) async {
  String seleccionado = 'Mañana (9:00 - 13:00)';

  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Elige un horario'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(
                  title: const Text('Mañana (9:00 - 13:00)'),
                  value: 'Mañana (9:00 - 13:00)',
                  groupValue: seleccionado,
                  onChanged: (v) => setState(() => seleccionado = v!),
                ),
                RadioListTile<String>(
                  title: const Text('Tarde (16:00 - 20:00)'),
                  value: 'Tarde (16:00 - 20:00)',
                  groupValue: seleccionado,
                  onChanged: (v) => setState(() => seleccionado = v!),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, null),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, seleccionado),
                child: const Text('Aceptar'),
              ),
            ],
          );
        },
      );
    },
  );
}

/// ----------------------
/// DIALOGO 2: CONFIRMACIÓN
/// ----------------------
Future<void> _mostrarDialogoConfirmacion(
  BuildContext context,
  String horario,
) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text('¡Inscripción confirmada!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 50),
            const SizedBox(height: 12),
            const Text('Te has inscrito correctamente en el horario:'),
            const SizedBox(height: 6),
            Text(
              horario,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ),
        ],
      );
    },
  );
}
