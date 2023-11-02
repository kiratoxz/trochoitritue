import 'dart:async';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobx/mobx.dart';
import '../../shared.dart';

abstract class BaseScreenArguments {
  final VoidCallback? onScreenBuildDone;

  BaseScreenArguments({
    this.onScreenBuildDone,
  });
}

abstract class BaseScreenStateful extends StatefulHookWidget {
  const BaseScreenStateful({Key? key}) : super(key: key);
}

abstract class BaseScreenState<CS extends BaseScreenStateful> extends State<CS>
    with BaseScreenMixin, ScreenStatefulMixin<CS> {
  bool haveInitialized = false;
  final FToast fToast = FToast();
  final List<ReactionDisposer> reactionDisposerBag = [];
  final List<StreamSubscription> disposeBag = [];

  void initComponents(BuildContext context) {
    // any related to context should be init here
    if (!haveInitialized) {
      initWithContext(context);
      haveInitialized = true;
    }
  }

  void closeReactionDisposer() {
    for (final disposable in reactionDisposerBag) {
      disposable();
    }
  }

  void closeDisposeBag() {
    // disposeBag.close();
    for (final stream in disposeBag) {
      stream.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    initComponents(context);
  }

  @override
  void dispose() {
    closeReactionDisposer();
    closeDisposeBag();
    super.dispose();
  }
}
