import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kiratoxz_flutter/game/presentation/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class DrawerAppInfo extends StatelessWidget {
  const DrawerAppInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: 'Ứng dụng tạo bởi ',
        style: AppTextStyles.bodyXs.copyWith(color: Colors.yellow),
        children: <TextSpan>[
          TextSpan(
            text: 'Kiratoxz',
            style: AppTextStyles.bodyXs.copyWith(fontWeight: FontWeight.w700),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launchUrl(Uri.parse("https://t.me/kiratoxz"));
              },
          ),
          const TextSpan(
            text: ' của ',
            style: AppTextStyles.bodyXs,
          ),
          TextSpan(
            text: 'VZ99',
            style: AppTextStyles.bodyXs.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
