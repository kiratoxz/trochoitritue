import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:kiratoxz_flutter/shared/shared.dart';

class ToastInfoView extends StatelessWidget {
  const ToastInfoView(
    this.message, {
    Key? key,
    this.icon,
    this.isCenterMessage = true,
  }) : super(key: key);

  final String message;
  final Widget? icon;
  final bool isCenterMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40.0, left: 20, right: 20, bottom: 40),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SeparatedRow(
      separatorBuilder: () => const SizedBox(width: 12),
      children: [
        if (icon != null) icon!,
        Expanded(
          child: ExtendedText(
            message,
            specialTextSpanBuilder: AppTextSpanBuilder(
              specialStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            maxLines: 10,
            textAlign: isCenterMessage ? TextAlign.center : TextAlign.left,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
