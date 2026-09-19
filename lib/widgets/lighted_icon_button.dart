import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_portfolio/widgets/hover_detector.dart';

class LightedIconButton extends StatefulWidget {
  const LightedIconButton({
    super.key,
    required this.faIcon,
    required this.onClick,
    required this.color,
    required this.hoverColor,
    required this.toolTip,
  });
  final Color color;
  final String toolTip;
  final Color hoverColor;
  final FaIconData faIcon;
  final VoidCallback onClick;
  @override
  State<LightedIconButton> createState() => _LightedIconButtonState();
}

class _LightedIconButtonState extends State<LightedIconButton> {
  ValueNotifier<bool> ishovered = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return HoverDetector(
      onHover: (value) => ishovered.value = value,
      child: IconButton(
        onPressed: widget.onClick,
        icon: ListenableBuilder(
          listenable: ishovered,
          builder: (context, child) => Tooltip(
            message: widget.toolTip,
            child: FaIcon(
              widget.faIcon,
              color: ishovered.value ? widget.hoverColor : widget.color,
            ),
          ),
        ),
      ),
    );
  }
}
