import 'dart:math';
import 'package:flutter/material.dart';

class OceanWaves extends StatefulWidget {
  const OceanWaves({super.key});

  @override
  State<OceanWaves> createState() => _OceanWavesState();
}

class _OceanWavesState extends State<OceanWaves>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
            return SizedBox.expand(
              child: CustomPaint(
                painter: _WavesPainter(t: _controller.value),
              ),
            );
          },
        );
      },
    );
  }
}

class _WavesPainter extends CustomPainter {
  final double t; // 0..1
  _WavesPainter({required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final phase1 = t * 2 * pi;
    final phase2 = t * 2 * pi * 1.3;
    final phase3 = t * 2 * pi * 0.9;

    // (Opcional) Debug: pinta un fondo suave para verificar que ocupa toda la pantalla
    // canvas.drawRect(Offset.zero & size, Paint()..color = Colors.blue.withOpacity(0.03));

    _drawWave(
      canvas,
      size,
      baseY: h * 0.55,
      amplitude: h * 0.08,
      wavelength: w * 0.9,
      phase: phase1,
      color: const Color(0xFF2A9DF4).withOpacity(0.55),
    );

    _drawWave(
      canvas,
      size,
      baseY: h * 0.65,
      amplitude: h * 0.10,
      wavelength: w * 0.75,
      phase: phase2,
      color: const Color(0xFF1C77C3).withOpacity(0.60),
    );

    _drawWave(
      canvas,
      size,
      baseY: h * 0.75,
      amplitude: h * 0.12,
      wavelength: w * 0.65,
      phase: phase3,
      color: const Color(0xFF0B4F8A).withOpacity(0.65),
    );
  }

  void _drawWave(
    Canvas canvas,
    Size size, {
    required double baseY,
    required double amplitude,
    required double wavelength,
    required double phase,
    required Color color,
  }) {
    final w = size.width;
    final h = size.height;

    final path = Path()
      ..moveTo(0, h)
      ..lineTo(0, baseY);

    const steps = 60;
    for (int i = 0; i <= steps; i++) {
      final x = (i / steps) * w;
      final y = baseY + amplitude * sin((2 * pi * x / wavelength) + phase);
      path.lineTo(x, y);
    }

    path
      ..lineTo(w, h)
      ..close();

    final paint = Paint()..color = color;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WavesPainter oldDelegate) => oldDelegate.t != t;
}
