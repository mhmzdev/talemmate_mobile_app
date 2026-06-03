import 'package:flutter/widgets.dart';
import 'package:taleemmate/configs/configs.dart';

class StackCenter extends StatelessWidget {
  const StackCenter({
    super.key,
    this.onLeft,
    this.onRight,
    this.center,
  });

  final Widget? onLeft;
  final Widget? onRight;
  final Widget? center;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return Stack(
      alignment: .center,
      children: [
        if (onLeft != null) Align(alignment: .centerLeft, child: onLeft!),
        if (onRight != null) Align(alignment: .centerRight, child: onRight!),
        ?center,
      ],
    );
  }
}
