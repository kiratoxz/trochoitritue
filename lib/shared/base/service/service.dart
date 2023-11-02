import 'package:pretty_logger/pretty_logger.dart';

Future? protectNonAsync(Function source) async {
  try {
    await source.call();
  } catch (e) {
    PLog.error('Error: $e');
  }
}
