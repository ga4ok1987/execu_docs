import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class HoverButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color color;
  final double hoverTranslate;
  final bool isCircle;

  const HoverButton({
    super.key,
    required this.child,
    this.onPressed,
    this.color = AppColors.backgroundButtonBlue,
    this.hoverTranslate = -3,
    this.isCircle = false,
  });

  @override
  Widget build(BuildContext context) {
    final hoverNotifier = ValueNotifier(false);
    final pressedNotifier = ValueNotifier(false);

    return MouseRegion(
      onEnter: (_) => hoverNotifier.value = true,
      onExit: (_) => hoverNotifier.value = false,
      child: GestureDetector(
        onTapDown: (_) => pressedNotifier.value = true,
        onTapUp: (_) => pressedNotifier.value = false,
        onTapCancel: () => pressedNotifier.value = false,
        onTap: onPressed,
        child: ValueListenableBuilder2<bool, bool>(
          first: hoverNotifier,
          second: pressedNotifier,
          builder: (context, isHovered, isPressed, _) {
            final double translateY = isPressed
                ? 2
                : (isHovered ? hoverTranslate : 0);

            return AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              transform: Matrix4.translationValues(0, translateY, 0),
              child: Material(
                color: color,
                elevation: isHovered ? 18 : 14,
                borderRadius: BorderRadius.circular(isCircle ? 1000 : 6),
                child: Padding(
                  padding: isCircle
                      ? const EdgeInsets.all(8)
                      : const EdgeInsets.symmetric(horizontal: 25, vertical: 6),
                  child: child,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ValueListenableBuilder для двох ValueNotifier одночасно
class ValueListenableBuilder2<A, B> extends StatelessWidget {
  final ValueNotifier<A> first;
  final ValueNotifier<B> second;
  final Widget Function(BuildContext, A, B, Widget?) builder;

  const ValueListenableBuilder2({
    super.key,
    required this.first,
    required this.second,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<A>(
      valueListenable: first,
      builder: (context, valueA, _) {
        return ValueListenableBuilder<B>(
          valueListenable: second,
          builder: (context, valueB, __) {
            return builder(context, valueA, valueB, null);
          },
        );
      },
    );
  }
}
