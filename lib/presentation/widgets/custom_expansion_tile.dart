import 'package:flutter/material.dart';

final settingsExpanded = ValueNotifier<bool>(false);

class CustomExpansionTile extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final ValueNotifier<bool> expandedNotifier;

  const CustomExpansionTile({
    super.key,
    required this.title,
    required this.children,
    required this.expandedNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: expandedNotifier,
      builder: (context, expanded, _) {
        return Column(
          children: [
            ListTile(
              title: Text(title),
              onTap: () => expandedNotifier.value = !expanded,
              trailing: Icon(expanded ? Icons.expand_less : Icons.expand_more),
            ),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 100),
              firstChild: const SizedBox.shrink(),
              secondChild: Column(children: expanded ? children : []),
              crossFadeState: expanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            ),
          ],
        );
      },
    );
  }
}
