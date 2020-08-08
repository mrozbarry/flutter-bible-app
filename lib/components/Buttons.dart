import 'package:flutter/material.dart';

class MaterialTextButton extends StatelessWidget {
  final Widget child;
  final void Function() onPressed;
  final Alignment alignment;

  MaterialTextButton({
    this.child,
    this.onPressed,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Align(
          alignment: Alignment.centerLeft,
          child: child,
        ),
        onPressed: onPressed,
      );
  }
}

enum IconSide {
  Left,
  Right,
}

class MaterialRaisedTextIconButton extends StatelessWidget {
  final Widget label;
  final Widget icon;
  final void Function() onPressed;
  final IconSide iconSide;

  MaterialRaisedTextIconButton({
    this.label,
    this.icon,
    this.onPressed,
    this.iconSide = IconSide.Left,
  });

  @override
  Widget build(BuildContext context) {
    var left = this.iconSide == IconSide.Left
        ? icon
        : label;

    var right = this.iconSide == IconSide.Left
        ? label 
        : icon;

    return RaisedButton.icon(
        // visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        label: right,
        icon: left,
        onPressed: onPressed,
      );
  }
}
