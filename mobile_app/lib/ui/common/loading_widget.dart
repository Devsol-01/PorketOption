import 'package:flutter/material.dart';
import 'package:mobile_app/ui/common/app_colors.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;
  final bool isOverlay;
  final double size;

  const LoadingWidget({
    super.key,
    this.message,
    this.isOverlay = false,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final loadingContent = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: const AlwaysStoppedAnimation<Color>(primary),
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: 16),
          Text(
            message!,
            style: TextStyle(
              color: isDark ? darkTextSecondary : lightTextSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );

    if (isOverlay) {
      return Container(
        color: (isDark ? darkBackground : lightBackground).withOpacity(0.8),
        child: Center(child: loadingContent),
      );
    }

    return Center(child: loadingContent);
  }
}

class PulsingDot extends StatefulWidget {
  final double size;
  final Color color;
  final Duration duration;

  const PulsingDot({
    super.key,
    this.size = 8,
    this.color = primary,
    this.duration = const Duration(milliseconds: 1000),
  });

  @override
  State<PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.repeat(reverse: true);
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
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: widget.color.withOpacity(_animation.value),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}

class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PulsingDot(
          duration: const Duration(milliseconds: 600),
        ),
        const SizedBox(width: 4),
        PulsingDot(
          duration: const Duration(milliseconds: 600),
        ),
        const SizedBox(width: 4),
        PulsingDot(
          duration: const Duration(milliseconds: 600),
        ),
      ],
    );
  }
}
