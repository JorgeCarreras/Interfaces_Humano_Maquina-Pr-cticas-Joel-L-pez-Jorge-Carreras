import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Práctica 1',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MenuPrincipal(),
      
    );
  }
}

class MenuPrincipal extends StatelessWidget {
  const MenuPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ejercicios Clase Práctica 1'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Mis ejercicios',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 40),
            Container(
              color: Colors.amber,
              width: 200,
              height: 400,
              child: const Text('Hello, Flutter!'),
            ),

            // Botón Ejercicio 1
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Ejercicio1()),
                );
              },
              child: Container(
                width: 250,
                height: 60,
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'Ejercicio 1: Tarjeta personal',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            // Botón Ejercicio 2
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Ejercicio2()),
                );
              },
              child: Container(
                width: 250,
                height: 60,
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'Ejercicio 2: Cajas de colores',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            // Botón Ejercicio 3
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Ejercicio3()),
                );
              },
              child: Container(
                width: 250,
                height: 60,
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'Ejercicio 3: Fila de círculos',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            // Botón Ejercicio 4
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Ejercicio4()),
                );
              },
              child: Container(
                width: 250,
                height: 60,
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'Ejercicio 4: Tarjeta de contacto',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            // Botón Ejercicio 5
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Ejercicio5()),
                );
              },
              child: Container(
                width: 250,
                height: 60,
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'Ejercicio 5: Navegación',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ========================= EJERCICIO 1 =========================
class Ejercicio1 extends StatelessWidget {
  const Ejercicio1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ejercicio 1'), backgroundColor: Colors.red),

      // TODO: Crear una pantalla que muestre:
      // - Tu nombre en grande
      // - Tu edad debajo
      // - Todo dentro de un Container con color de fondo
      // - Centrado en la pantalla
      body: Placeholder(),
    );
  }
}

// ========================= EJERCICIO 2 =========================
class Ejercicio2 extends StatelessWidget {
  const Ejercicio2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ejercicio 2'), backgroundColor: Colors.green),

      // TODO: Crear tres Containers apilados verticalmente:
      // - Uno rojo, uno azul, uno verde
      // - Cada uno de diferente altura
      // - Centrados en la pantalla
      body: Placeholder(),
    );
  }
}

// ========================= EJERCICIO 3 =========================
class Ejercicio3 extends StatelessWidget {
  const Ejercicio3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ejercicio 3'),
        backgroundColor: Colors.orange,
      ),

      // TODO: Crear tres círculos en fila horizontal:
      // - Usar Container con decoración circular
      // - Colores amarillo, naranja y rojo
      // - Centrados en pantalla
      body: Placeholder(),
    );
  }
}

// ========================= EJERCICIO 4 =========================
class Ejercicio4 extends StatelessWidget {
  const Ejercicio4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ejercicio 4'),
        backgroundColor: Colors.purple,
      ),

      // TODO: Crear una tarjeta estilo contacto:
      // - Nombre en texto grande
      // - Teléfono debajo
      // - Email debajo
      // - Todo en un Container con borde y padding
      body: Placeholder(),
    );
  }
}

// ========================= EJERCICIO 5 =========================
class Ejercicio5 extends StatelessWidget {
  const Ejercicio5({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ejercicio 5'), backgroundColor: Colors.teal),

      // TODO: Pantalla principal con un botón (Container + GestureDetector):
      // - Un Container que diga "Ir a Página 2"
      // - Al tocarlo, navegar a una segunda pantalla
      // - La segunda pantalla solo muestra "¡Hola desde Página 2!"
      // - La segunda pantalla debe estar en un nuevo fichero .dart, dentro de la carpeta /lib
      body: Placeholder(),
    );
  }
}