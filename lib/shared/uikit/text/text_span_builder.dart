// ignore_for_file: depend_on_referenced_packages

import 'package:extended_text/extended_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kiratoxz_flutter/shared/shared.dart';
import 'package:collection/collection.dart';

enum FlagType { image, coin, text }

class AppTextSpanBuilder extends SpecialTextSpanBuilder {
  final Gradient? textGradientStyle;

  AppTextSpanBuilder({
    this.specialStyle = const TextStyle(
      color: RColors.colorPrimaryBlue3,
    ),
    this.imageColor,
    this.imageMargin = 0,
    this.allowedFlags = const [FlagType.text],
    this.onTap,
    this.textGradientStyle,
  });

  final TextStyle specialStyle;
  final Color? imageColor;
  final double imageMargin;
  final List<FlagType> allowedFlags;
  final SpecialTextGestureTapCallback? onTap;

  @override
  SpecialText? createSpecialText(String? flag,
      {TextStyle? textStyle,
      SpecialTextGestureTapCallback? onTap,
      int? index}) {
    if (flag == null || flag == '' || textStyle == null || index == null) {
      return null;
    }

    if (isStart(flag, ImageAssetText.startTag) &&
        allowedFlags.contains(FlagType.image)) {
      return ImageAssetText(
        textStyle,
        start: index - ImageAssetText.startTag.length + 1,
        imageColor: imageColor,
        imageMargin: imageMargin,
      );
    }
    if (isStart(flag, AmountCoinText.startTag) &&
        allowedFlags.contains(FlagType.coin)) {
      return AmountCoinText(
        textStyle,
        start: index - AmountCoinText.startTag.length + 1,
      );
    }
    if (isStart(flag, SpecialStyleText.startTag) &&
        allowedFlags.contains(FlagType.text)) {
      return SpecialStyleText(
        textStyle.merge(specialStyle),
        start: index - SpecialStyleText.startTag.length + 1,
        onTap: onTap,
        textGradientStyle: textGradientStyle,
      );
    }
    return null;
  }
}

class ImageAssetText extends SpecialText {
  ImageAssetText(
    TextStyle textStyle, {
    required this.start,
    this.imageColor,
    this.imageMargin = 0,
  }) : super(startTag, endTag, textStyle);

  static const startTag = '[';
  static const endTag = ']';

  final int start;
  final Color? imageColor;
  final double imageMargin;

  @override
  InlineSpan finishText() {
    final String key = toString();

    String url = key.replaceAll(startTag, "");
    url = url.replaceAll(endTag, "");
    final spacing = (textStyle?.fontSize ?? 0.0) * 0.125;
    return ImageSpan(
      AssetImage(url),
      actualText: key,
      imageWidth: (textStyle?.fontSize ?? 0.0) + 2.0,
      imageHeight: (textStyle?.fontSize ?? 0.0) + 2.0,
      start: start,
      fit: BoxFit.contain,
      color: imageColor,
      margin: EdgeInsets.only(
        bottom: spacing,
        left: imageMargin,
        right: imageMargin,
      ),
    );
  }
}

class AmountCoinText extends SpecialText {
  AmountCoinText(TextStyle textStyle, {required this.start})
      : super(startTag, endTag, textStyle);

  static const startTag = '\$';
  static const endTag = '\$';

  final int start;

  @override
  InlineSpan finishText() {
    final String text = getContent();

    return SpecialTextSpan(
        text: text,
        actualText: toString(),
        start: start,
        deleteAll: true,
        style: textStyle?.copyWith(color: RColors.colorPrimaryBlue3),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            if (onTap != null) {
              onTap?.call(toString());
            }
          });
  }
}

class SpecialStyleText extends SpecialText {
  SpecialStyleText(
    this.textStyle, {
    required this.start,
    this.textGradientStyle,
    SpecialTextGestureTapCallback? onTap,
  }) : super(startTag, endTag, textStyle, onTap: onTap);

  static const startTag = '@';
  static const endTag = '@';

  final Gradient? textGradientStyle;

  final int start;
  @override
  // ignore: overridden_fields
  final TextStyle textStyle;

  @override
  InlineSpan finishText() {
    final String text = getContent();
    if (textGradientStyle != null) {
      return WidgetSpan(
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return textGradientStyle!.createShader(Offset.zero & bounds.size);
          },
          child: GestureDetector(
            onTap: onTap != null
                ? () {
                    onTap?.call(text);
                  }
                : null,
            child: Text(
              text,
              style: textStyle,
            ),
          ),
        ),
      );
    }
    return TextSpan(
      text: text,
      style: textStyle,
      recognizer: TapGestureRecognizer()
        ..onTap = onTap != null
            ? () {
                onTap?.call(text);
              }
            : null,
    );
    // return SpecialTextSpan(
    //     text: text,
    //     actualText: toString(),
    //     start: start,
    //     deleteAll: true,
    //     style: textStyle,
    //     recognizer: TapGestureRecognizer()
    //       ..onTap = onTap != null
    //           ? () {
    //               onTap?.call(text);
    //             }
    //           : null);
  }
}

class GradientExtendedText extends StatefulWidget {
  final String data;
  final TextStyle? specialTextStyle;
  final TextAlign? textAlign;
  final TextStyle? style;
  final LinearGradient? gradient;

  const GradientExtendedText(
    this.data, {
    Key? key,
    this.specialTextStyle,
    this.textAlign,
    this.style,
    this.gradient,
  }) : super(key: key);

  @override
  State<GradientExtendedText> createState() => _GradientExtendedTextState();
}

class _GradientExtendedTextState extends State<GradientExtendedText> {
  // a key to set on our Text widget, so we can measure later
  GlobalKey myTextKey = GlobalKey();

// a RenderBox object to use in state
  RenderBox? myTextRenderBox;

  @override
  void initState() {
    super.initState();
    // this will be called after first draw, and then call _recordSize() method
    WidgetsBinding.instance.addPostFrameCallback((_) => _recordSize());
  }

  void _recordSize() {
    // now we set the RenderBox and trigger a redraw
    setState(() {
      myTextRenderBox =
          myTextKey.currentContext?.findRenderObject() as RenderBox;
    });
  }

  Shader? getTextGradient(RenderBox? renderBox) {
    if (renderBox == null || widget.gradient == null) return null;
    return widget.gradient!.createShader(const Rect.fromLTWH(50, 50, 50, 50));
  }

  @override
  Widget build(BuildContext context) {
    final list = widget.data.split('@');
    if (list.length < 3) {
      return Text(
        widget.data,
        style: widget.style,
      );
    }
    final widgets = <Widget>[];
    list.forEachIndexed((index, element) {
      if (index == 0) {
        widgets.add(Text(
          element,
          style: widget.style,
        ));
      } else if (index == list.length - 1) {
        // final start = widget.data.length - list[index - 1].length;
        widgets.add(Text(
          element,
          style: widget.style,
        ));
      } else {
        // final start = List.generate(index, (newIndex) {
        //   return list[newIndex].length;
        // }).reduce((value, element) => value + element);
        // final end = start + list[index].length;
        widgets.add(Text(
          element,
          style: widget.specialTextStyle,
        ));
      }
    });

    return Wrap(
      children: widgets,
    );
    // return ExtendedText(
    //   widget.data,
    //   key: myTextKey,
    //   specialTextSpanBuilder: AppTextSpanBuilder(
    //       specialStyle:
    //           const TextStyle().merge(widget.specialTextStyle).copyWith(
    //                 foreground: widget.gradient != null
    //                     ? (Paint()..shader = getTextGradient(myTextRenderBox))
    //                     : null,
    //               )),
    //   textAlign: widget.textAlign,
    //   style: widget.style?.copyWith(
    //     foreground: widget.gradient != null
    //         ? (Paint()..shader = getTextGradient(myTextRenderBox))
    //         : null,
    //   ),
    // );
  }
}
