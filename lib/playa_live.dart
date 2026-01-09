import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PlayaLivePage extends StatelessWidget {
  const PlayaLivePage({super.key});

  static final Uri _url = Uri.parse(
    'https://www.skylinewebcams.com/es/webcam/espana/andalucia/cadiz/conil-de-la-frontera.html',
  );

  Future<void> _abrirWeb() async {
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw 'No se pudo abrir el enlace';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estado de la playa en directo')),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: _abrirWeb,
          icon: const Icon(Icons.waves),
          label: const Text('Abrir webcam en directo'),
        ),
      ),
    );
  }
}
