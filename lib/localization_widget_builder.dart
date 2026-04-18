import 'package:flutter/widgets.dart';

import 'value_localization.dart';

class LocalizationWidgetBuilder extends StatelessWidget {
  const LocalizationWidgetBuilder({
    super.key,
    required this.builder,
    this.child,
  });

  final Widget Function(BuildContext context, Widget? child) builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: ValueLocalization.listenable,
      builder: (context, _, __) => builder(context, child),
    );
  }
}