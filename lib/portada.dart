import 'package:flutter/material.dart';
import 'main.dart'; // para acceder a LogoPage
import 'form_reserva.dart'; // todavía no existe, pero lo prepararemos

class PortadaPage extends StatelessWidget {
  const PortadaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/portada.jpg'), // REEMPLAZA por la imagen que quieras
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black45, // oscurece la imagen para que destaquen los botones
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const Text(
                "GANDIA SURF SCHOOL",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 60),

              // BOTÓN LOGIN
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LogoPage()),
                  );
                },
                child: const Text(
                  "LOGIN",
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
              ),

              const SizedBox(height: 20),

              // BOTÓN FORMULARIO
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FormReservaPage()),
                  );
                },
                child: const Text(
                  "FORMULARIO",
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
