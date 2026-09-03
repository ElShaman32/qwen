import 'package:flutter/material.dart';
import 'package:flutter_lucide_animated/flutter_lucide_animated.dart';

/// Tile de módulo estilo "Fast Menu" (círculo coloreado + icono animado).
/// Draw-in escalonado al aparecer y re-animación al toque.
/// SIN loop: costo de render continuo = cero (gama baja OK).
class AnimatedModuleTile extends StatefulWidget {
  const AnimatedModuleTile({
    super.key,
    required this.icono,
    required this.label,
    required this.color,
    required this.onTap,
    this.index = 0,
  });

  final LucideAnimatedIconData icono;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final int index;

  @override
  State<AnimatedModuleTile> createState() => _AnimatedModuleTileState();
}

class _AnimatedModuleTileState extends State<AnimatedModuleTile> {
  final LucideAnimatedIconController _controller =
      LucideAnimatedIconController();

  @override
  void initState() {
    super.initState();
    // Draw-in escalonado (one-shot) al montar el grid.
    Future<void>.delayed(Duration(milliseconds: 100 * widget.index), () {
      if (mounted) _controller.animate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        _controller.animate(); // micro-feedback al toque
        widget.onTap();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color.withValues(alpha: 0.14),
            ),
            child: Center(
              child: LucideAnimatedIcon(
                icon: widget.icono,
                trigger: AnimationTrigger.manual,
                controller: _controller,
                size: 28,
                color: widget.color,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            widget.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
