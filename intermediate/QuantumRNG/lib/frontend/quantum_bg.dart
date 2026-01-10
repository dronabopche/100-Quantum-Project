import 'package:flutter/material.dart';
import 'dart:math';

class QuantumBackground extends StatefulWidget {
  final Widget child;

  const QuantumBackground({Key? key, required this.child}) : super(key: key);

  @override
  _QuantumBackgroundState createState() => _QuantumBackgroundState();
}

class _QuantumBackgroundState extends State<QuantumBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: QuantumBackgroundPainter(_animation.value),
          child: Container(
            color: Colors.transparent,
            child: widget.child,
          ),
        );
      },
    );
  }
}

class QuantumBackgroundPainter extends CustomPainter {
  final double animationValue;

  QuantumBackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF0A0E21); // Deep space blue background

    // Draw base background
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    _drawQuantumWaves(canvas, size);
    _drawProbabilityClouds(canvas, size);
    _drawEntanglementLines(canvas, size);
    _drawQuantumParticles(canvas, size);
    _drawSuperpositionRings(canvas, size);
  }

  void _drawQuantumWaves(Canvas canvas, Size size) {
    final wavePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = const Color(0xFF1E88E5).withOpacity(0.3)
      ..shader = LinearGradient(
        colors: [
          const Color(0xFF1E88E5).withOpacity(0.1),
          const Color(0xFF64B5F6).withOpacity(0.3),
          const Color(0xFF1E88E5).withOpacity(0.1),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    final waveCount = 8;
    final waveSpacing = size.height / waveCount;

    for (int i = 0; i < waveCount; i++) {
      final y = i * waveSpacing;
      path.reset();
      path.moveTo(0, y);

      for (double x = 0; x < size.width; x += 2) {
        final waveHeight = sin(x * 0.02 + animationValue * 2 * pi + i) * 8;
        path.lineTo(x, y + waveHeight);
      }

      canvas.drawPath(path, wavePaint);
    }
  }

  void _drawProbabilityClouds(Canvas canvas, Size size) {
    final cloudPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF4A148C).withOpacity(0.15);

    final cloudCount = 12;
    for (int i = 0; i < cloudCount; i++) {
      final seed = i * 137.5; // Golden angle distribution
      final x = (cos(seed) * 0.4 + 0.5) * size.width;
      final y = (sin(seed) * 0.4 + 0.5) * size.height;
      final radius = 40 + sin(animationValue * 2 * pi + i) * 20;

      // Draw probability cloud with multiple overlapping circles
      for (int j = 0; j < 5; j++) {
        final offsetX = cos(animationValue * pi + j) * 15;
        final offsetY = sin(animationValue * pi + j) * 15;
        final cloudRadius = radius * (0.7 + j * 0.1);

        canvas.drawCircle(
          Offset(x + offsetX, y + offsetY),
          cloudRadius,
          cloudPaint,
        );
      }
    }
  }

  void _drawEntanglementLines(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..color = const Color(0xFF00E5FF).withOpacity(0.2);

    final pairs = 15;
    for (int i = 0; i < pairs; i++) {
      final angle = i * 2 * pi / pairs;
      final distance = min(size.width, size.height) * 0.3;

      final x1 = size.width / 2 + cos(angle) * distance;
      final y1 = size.height / 2 + sin(angle) * distance;

      final x2 = size.width / 2 + cos(angle + pi) * distance;
      final y2 = size.height / 2 + sin(angle + pi) * distance;

      // Draw pulsating entanglement line
      final pulse = sin(animationValue * 2 * pi + i) * 0.5 + 0.5;
      final dashPattern = [4.0 + pulse * 8, 4.0 + pulse * 8];

      final dashedPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8 + pulse * 0.4
        ..color = const Color(0xFF00E5FF).withOpacity(0.1 + pulse * 0.1);

      _drawDashedLine(
          canvas, Offset(x1, y1), Offset(x2, y2), dashedPaint, dashPattern);
    }
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint,
      List<double> dashPattern) {
    final path = Path();
    path.moveTo(start.dx, start.dy);
    path.lineTo(end.dx, end.dy);

    final metrics = path.computeMetrics().first;
    final totalLength = metrics.length;
    double currentLength = 0;

    while (currentLength < totalLength) {
      final isDash =
          ((currentLength / (dashPattern[0] + dashPattern[1])).floor() % 2) ==
              0;
      final nextLength =
          currentLength + (isDash ? dashPattern[0] : dashPattern[1]);

      if (isDash) {
        final extractedPath =
            metrics.extractPath(currentLength, min(nextLength, totalLength));
        canvas.drawPath(extractedPath, paint);
      }

      currentLength = nextLength;
    }
  }

  void _drawQuantumParticles(Canvas canvas, Size size) {
    final particleCount = 50;

    for (int i = 0; i < particleCount; i++) {
      final seed = i * 137.5;
      final baseX = (cos(seed) * 0.8 + 1) * 0.5 * size.width;
      final baseY = (sin(seed) * 0.8 + 1) * 0.5 * size.height;

      // Quantum uncertainty movement
      final uncertaintyX = sin(animationValue * 3 * pi + i) * 20;
      final uncertaintyY = cos(animationValue * 2 * pi + i * 1.3) * 20;

      final x = baseX + uncertaintyX;
      final y = baseY + uncertaintyY;

      final particlePaint = Paint()
        ..style = PaintingStyle.fill
        ..color = _getParticleColor(i)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);

      final radius = 1.5 + sin(animationValue * 4 * pi + i) * 0.8;

      canvas.drawCircle(Offset(x, y), radius, particlePaint);

      // Draw quantum trail
      final trailLength = 3;
      for (int j = 1; j <= trailLength; j++) {
        final trailX = x - uncertaintyX * 0.1 * j;
        final trailY = y - uncertaintyY * 0.1 * j;
        final trailRadius = radius * (1 - j * 0.3);
        final trailOpacity = 0.3 * (1 - j * 0.3);

        final trailPaint = Paint()
          ..style = PaintingStyle.fill
          ..color = _getParticleColor(i).withOpacity(trailOpacity)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.0);

        canvas.drawCircle(Offset(trailX, trailY), trailRadius, trailPaint);
      }
    }
  }

  Color _getParticleColor(int index) {
    final colors = [
      const Color(0xFF00E5FF),
      const Color(0xFF76FF03),
      const Color(0xFFFF4081),
      const Color(0xFFFFD600),
    ];
    return colors[index % colors.length].withOpacity(0.6);
  }

  void _drawSuperpositionRings(Canvas canvas, Size size) {
    final ringCount = 4;
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = min(size.width, size.height) * 0.4;

    for (int i = 0; i < ringCount; i++) {
      final progress = (i / ringCount + animationValue) % 1.0;
      final radius = maxRadius * progress;
      final opacity = (1 - progress) * 0.15;

      final ringPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..color = const Color(0xFF00E5FF).withOpacity(opacity);

      canvas.drawCircle(center, radius, ringPaint);

      // Draw quantum state markers around the ring
      final stateCount = 8;
      for (int j = 0; j < stateCount; j++) {
        final angle = j * 2 * pi / stateCount + animationValue * pi;
        final markerX = center.dx + cos(angle) * radius;
        final markerY = center.dy + sin(angle) * radius;

        final markerPaint = Paint()
          ..style = PaintingStyle.fill
          ..color = const Color(0xFF76FF03).withOpacity(opacity * 2);

        canvas.drawCircle(Offset(markerX, markerY), 2.0, markerPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
