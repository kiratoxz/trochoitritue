// ignore_for_file: constant_identifier_names, unused_element

import 'package:flutter/material.dart';
import 'package:pretty_logger/pretty_logger.dart';

class LoadingOverlay {
  static final LoadingOverlay _instance = LoadingOverlay._();

  LoadingOverlay._();

  factory LoadingOverlay() {
    return _instance;
  }

  OverlayEntry? entry;

  bool _isShowLoading = false;
  String? _messageContent;

  void showLoadingWithMessage(BuildContext context, {String? message}) {
    _messageContent = message;
    showLoadingPage(context);
  }

  void showLoadingPage(BuildContext context) {
    try {
      if (_isShowLoading) return;
      entry = createOverlayEntry(context);
      Overlay.of(context).insert(entry!);
      _isShowLoading = true;
    } catch (e) {
      PLog.error('showLoadingPage: $e');
    }
  }

  void hideLoadingPage() {
    try {
      _messageContent = null;
      if (entry != null) {
        entry?.remove();
        entry = null;
        _isShowLoading = false;
      }
    } catch (e) {
      PLog.error('hideLoadingPage: $e');
    }
  }

  OverlayEntry createOverlayEntry(BuildContext context) {
    return OverlayEntry(
      builder: (context) => GestureDetector(
        child: Material(
          color: const Color(0x1A011222),
          elevation: 4.0,
          child: _LoadingIndicatorWidget(
            messageContent: _messageContent,
          ),
        ),
      ),
    );
  }
}

class _LoadingIndicatorWidget extends StatefulWidget {
  final String? messageContent;
  final Color? loadingColor;
  final Color? primaryTextColor;

  const _LoadingIndicatorWidget(
      {Key? key, this.messageContent, this.loadingColor, this.primaryTextColor})
      : super(key: key);

  @override
  __LoadingIndicatorWidgetState createState() =>
      __LoadingIndicatorWidgetState();
}

class __LoadingIndicatorWidgetState extends State<_LoadingIndicatorWidget> {
  String? get _messageContent => widget.messageContent;

  TextStyle get _messageTextStyle => TextStyle(
        fontWeight: FontWeight.w400,
        color: widget.primaryTextColor ??
            Theme.of(context).textTheme.bodyLarge?.color ??
            Colors.black,
        fontSize: 16,
        height: 20 / 16,
      );
  static const double DEFAULT_SIZE = 80.0;

  double _resolveBoxHeight = DEFAULT_SIZE;

  double _resolveBoxWidth = DEFAULT_SIZE;

  final GlobalKey _textSizeKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      automaticallyAdjustContent();
    });
  }

  @override
  void didUpdateWidget(covariant _LoadingIndicatorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    automaticallyAdjustContent();
  }

  void automaticallyAdjustContent() {
    if (_messageContent == null) {
      _resolveBoxHeight = DEFAULT_SIZE;
      _resolveBoxWidth = DEFAULT_SIZE;
    } else {
      Size textSize = _textSize(_messageContent, _messageTextStyle);
      double horizontalPadding = 16;
      _resolveBoxWidth = textSize.width + horizontalPadding * 2;
      _resolveBoxHeight = DEFAULT_SIZE + textSize.height;
    }
    if (mounted) {
      setState(() {});
    }
  }

  Size _textSize(String? text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        textDirection: TextDirection.ltr)
      ..layout(
          minWidth: 0, maxWidth: MediaQuery.of(context).size.width * 3 / 4);
    return textPainter.size;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: _resolveBoxWidth,
          height: _resolveBoxHeight,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.yellow, borderRadius: BorderRadius.circular(16)),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      widget.loadingColor ?? Theme.of(context).primaryColor),
                  backgroundColor: const Color(0xFFEAF0FF),
                  strokeWidth: 4,
                ),
              ),
              SizedBox(
                height: _messageContent != null ? 12 : 0,
              ),
              _messageContent != null
                  ? Flexible(
                      child: Text(
                        _messageContent ?? '',
                        key: _textSizeKey,
                        style: _messageTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
