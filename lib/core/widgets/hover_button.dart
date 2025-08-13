import 'package:flutter/material.dart';

class HoverButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color color;
  final double hoverTranslate;
  final double hoverBlur;
  final double normalBlur;
  final bool isCircle;

  const HoverButton({
    super.key,
    required this.child,
    this.onPressed,
    this.color = Colors.blue,
    this.hoverTranslate = -3,
    this.hoverBlur = 40,
    this.normalBlur = 15,
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
            // при натисканні кнопка просідає
            final double translateY = isPressed
                ? 2
                : (isHovered ? hoverTranslate : 0);

            return AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              transform: Matrix4.translationValues(0, translateY, 0),
              padding: isCircle
                  ? const EdgeInsets.all(
                      5,
                    ) // робимо квадратну область для кола
                  : const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(isCircle ? 1000 : 12),
                // велике значення = коло
                boxShadow: [
                  isCircle
                      ? BoxShadow(
                          color: const Color.fromRGBO(11, 99, 246, 0.8),
                          blurRadius: isHovered ? hoverBlur/10 : normalBlur/10,
                          spreadRadius: isHovered ? 2 : 1,
                          offset: Offset(
                            0,
                            isPressed ? 1 : (isHovered ? 2 : 1),
                          ),
                        )
                      : BoxShadow(
                          color: const Color.fromRGBO(11, 99, 246, 0.8),
                          blurRadius: isHovered ? hoverBlur : normalBlur,
                          spreadRadius: isHovered ? 3 : 1,
                          offset: Offset(
                            0,
                            isPressed ? 2 : (isHovered ? 20 : 5),
                          ),
                        ),
                ],
              ),
              child: child,
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
