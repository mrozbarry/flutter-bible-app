import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final List<Widget> children;
  final void Function() onPressed;
  final IconSide iconSide;
  final MaterialTapTargetSize materialTapTargetSize;
  final Color color;
  final Color textColor;

  CustomButton({
    this.children,
    this.onPressed,
    this.color,
    this.textColor,
    this.iconSide = IconSide.Left,
    this.materialTapTargetSize = MaterialTapTargetSize.shrinkWrap,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: color,
      textColor: textColor,
      materialTapTargetSize: materialTapTargetSize,
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: children,
      ),
    );
  }
}

class MaterialTextButton extends StatelessWidget {
  final Widget child;
  final void Function() onPressed;
  final Alignment alignment;
  final MaterialTapTargetSize materialTapTargetSize;

  MaterialTextButton({
    this.child,
    this.onPressed,
    this.alignment = Alignment.center,
    this.materialTapTargetSize = MaterialTapTargetSize.shrinkWrap,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: materialTapTargetSize,
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
  final MaterialTapTargetSize materialTapTargetSize;
  final Color color;
  final Color textColor;

  MaterialRaisedTextIconButton({
    this.label,
    this.icon,
    this.onPressed,
    this.color,
    this.textColor,
    this.iconSide = IconSide.Left,
    this.materialTapTargetSize = MaterialTapTargetSize.shrinkWrap,
  });

  @override
  Widget build(BuildContext context) {
    var children = this.iconSide == IconSide.Left
        ? [icon, label]
        : [label, icon];

    return CustomButton(
      color: color,
      textColor: textColor,
      onPressed: onPressed,
      children: children,
    );
  }
}
