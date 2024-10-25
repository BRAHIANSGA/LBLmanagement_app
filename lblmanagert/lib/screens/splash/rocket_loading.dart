import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class RocketLoading extends StatefulWidget {
  final Color? backgroundColor;
  final Duration animationDuration;

  const RocketLoading({
    super.key,
    this.backgroundColor,
    this.animationDuration = const Duration(seconds: 3),
  });

  @override
  State<RocketLoading> createState() => _RocketLoadingState();
}

class _RocketLoadingState extends State<RocketLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Color> _starColors = [
    Colors.white,
    Colors.blue.shade100,
    Colors.blue.shade200,
  ];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Función modificada para calcular la opacidad
  double _calculateOpacity(double animationValue) {
    double angle = animationValue * 2 * math.pi;
    double sinValue = math.sin(angle);
    
    // Ahora invertimos la lógica: si el seno es positivo, el cohete está "detrás"
    if (sinValue > 0) {
      return 0.3 + (0.7 * (1 - sinValue));
    }
    return 1.0;
  }

  Widget _buildStar(double top, double left, double size) {
    return Positioned(
      top: top,
      left: left,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: _starColors[_random.nextInt(_starColors.length)],
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 3,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorld() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Colors.blue.shade800,
            Colors.blue.shade600,
          ],
          center: Alignment.center,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/world.png',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.blue.shade800,
                    Colors.blue.shade400,
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRocketTrail(double angle, double opacity) {
    return Opacity(
      opacity: opacity,
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateX(-math.pi / 4)
          ..rotateY(math.pi / 4)
          ..rotateZ(angle),
        alignment: Alignment.center,
        child: Transform.translate(
          offset: const Offset(0, -80),
          child: Container(
            width: 40,
            height: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.red.withOpacity(0.8 * opacity),
                  Colors.orange.withOpacity(0.3 * opacity),
                  Colors.yellow.withOpacity(0.0),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.3 * opacity),
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor ?? Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "LBLmanagement...",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.blue,
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Estrellas de fondo
                    ...List.generate(
                      20,
                      (index) => _buildStar(
                        _random.nextDouble() * 250,
                        _random.nextDouble() * 250,
                        _random.nextDouble() * 2 + 1,
                      ),
                    ),
                    // Órbita
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.blue.withOpacity(0.2),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                    ),
                    // Mundo (ahora antes del cohete)
                    _buildWorld(),
                    // Estela del cohete y cohete (después del mundo)
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (_, child) {
                        final opacity = _calculateOpacity(_controller.value);
                        return Stack(
                          children: [
                            _buildRocketTrail(_controller.value * 2 * math.pi, opacity),
                            Opacity(
                              opacity: opacity,
                              child: Transform(
                                transform: Matrix4.identity()
                                  ..setEntry(3, 2, 0.001)
                                  ..rotateX(-math.pi / 4)
                                  ..rotateY(math.pi / 4)
                                  ..rotateZ(_controller.value * 2 * math.pi),
                                alignment: Alignment.center,
                                child: Transform.translate(
                                  offset: const Offset(0, -80),
                                  child: Transform.rotate(
                                    angle: -_controller.value * 2 * math.pi,
                                    child: Transform.rotate(
                                      angle: math.pi / 4,
                                      child: const Icon(
                                        Icons.rocket_launch,
                                        size: 40,
                                        color: Colors.red,
                                        shadows: [
                                          Shadow(
                                            color: Colors.red,
                                            blurRadius: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}