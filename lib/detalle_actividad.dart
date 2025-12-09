import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'actividades.dart'; // para acceder al modelo Item

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

                //  1. IMAGEN PRINCIPAL
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: 
                      Hero(
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

                //  2. TARJETA DE INFORMACIÓN
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

                      // Título con icono
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.water,
                            color: Colors.blue.shade700,
                            size: 28,
                          ),
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

                      // Descripción larga
                      Text(
                        actividad.descripcionLarga,
                        style: const TextStyle(
                          fontSize: 18,
                          height: 1.4,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 25),

                      // Línea divisoria
                      Container(
                        height: 2,
                        width: double.infinity,
                        color: Colors.orange.withOpacity(0.4),
                      ),

                      const SizedBox(height: 25),

                      // Información adicional
                      _infoRow(FontAwesomeIcons.euroSign, "Precio", actividad.precio),
                      const SizedBox(height: 15),

                      _infoRow(FontAwesomeIcons.clock, "Duración", actividad.duracion),
                      const SizedBox(height: 15),

                      _infoRow(FontAwesomeIcons.personSwimming, "Nivel", actividad.nivel),
                      const SizedBox(height: 15),

                      _infoRow(FontAwesomeIcons.star, "Valoración", actividad.rating.toString()),
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

  //  Widget reutilizable para cada fila de información
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
          child: Text(
            valor,
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }
}
