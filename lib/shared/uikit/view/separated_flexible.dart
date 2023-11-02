import 'package:flutter/material.dart';

class SeparatedRow extends StatelessWidget {
  final List<Widget> children;
  final Widget Function()? separatorBuilder;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final TextBaseline? textBaseline;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final EdgeInsets? padding;
  final bool flexEqual;

  const SeparatedRow({
    Key? key,
    required this.children,
    this.separatorBuilder,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
    this.textDirection,
    this.padding,
    this.flexEqual = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> c = flexEqual
        ? children.map<Widget>((e) => Expanded(child: e)).toList()
        : children.toList();
    for (var i = c.length; i-- > 0;) {
      if (i > 0 && separatorBuilder != null) c.insert(i, separatorBuilder!());
    }
    Widget row = Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      textBaseline: textBaseline,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      children: c,
    );
    return padding == null ? row : Padding(padding: padding!, child: row);
  }
}

class SeparatedColumn extends StatelessWidget {
  final List<Widget> children;
  final Widget Function()? separatorBuilder;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final TextBaseline? textBaseline;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final EdgeInsets? padding;

  const SeparatedColumn({
    Key? key,
    required this.children,
    this.separatorBuilder,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
    this.textDirection,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> itemList = [];
    if (separatorBuilder != null) {
      for (var i = 0; i < children.length; i++) {
        itemList.add(children[i]);
        if (i != children.length - 1) {
          itemList.add(separatorBuilder!());
        }
      }
    } else {
      itemList.addAll(children);
    }

    Widget col = Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      textBaseline: textBaseline,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      children: itemList,
    );
    return padding == null ? col : Padding(padding: padding!, child: col);
  }
}

class SeparatedWrap extends StatelessWidget {
  final List<Widget?> children;
  final Widget Function()? separatorBuilder;
  final Axis direction;
  final WrapAlignment alignment;
  final double spacing;
  final double runSpacing;
  final WrapCrossAlignment crossAxisAlignment;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final Clip clipBehavior;
  final WrapAlignment runAlignment;

  const SeparatedWrap({
    Key? key,
    required this.children,
    this.direction = Axis.horizontal,
    this.alignment = WrapAlignment.start,
    this.spacing = 0.0,
    this.runAlignment = WrapAlignment.start,
    this.runSpacing = 0.0,
    this.crossAxisAlignment = WrapCrossAlignment.start,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.clipBehavior = Clip.none,
    this.separatorBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> itemList = [];
    final nonNullChildren = children.whereType<Widget>().toList();
    if (separatorBuilder != null) {
      for (var i = 0; i < nonNullChildren.length; i++) {
        itemList.add(nonNullChildren[i]);
        if (i != nonNullChildren.length - 1) {
          itemList.add(separatorBuilder!());
        }
      }
    } else {
      itemList.addAll(nonNullChildren);
    }

    Widget col = Wrap(
      direction: direction,
      alignment: alignment,
      spacing: spacing,
      runSpacing: runSpacing,
      runAlignment: runAlignment,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      clipBehavior: clipBehavior,
      children: itemList,
    );
    return col;
  }
}

class SeparatedCircleIndicator extends StatelessWidget {
  final double size;
  final EdgeInsets? margin;
  final Color? color;

  const SeparatedCircleIndicator({
    Key? key,
    this.size = 3,
    this.margin,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color ?? Colors.yellow,
      ),
    );
  }
}
