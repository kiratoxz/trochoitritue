// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:kiratoxz_flutter/shared/shared.dart';

mixin BaseMobxStore on Store {
  final List<ReactionDisposer> reactionDisposerBag = [];
  final List<StreamSubscription> disposeBag = [];
  final List<BaseMobxStore> stores = [];
  final List<dynamic> _rxCallbacks = [];
  VisibilityDetectorScreenType _currentVisibilityDetectorScreenType =
      VisibilityDetectorScreenType.visibility_gained;

  bool get isInjectedScreenVisible {
    switch (_currentVisibilityDetectorScreenType) {
      case VisibilityDetectorScreenType.focus_gained:
      case VisibilityDetectorScreenType.foreground_gained:
      case VisibilityDetectorScreenType.visibility_gained:
        return true;
      default:
        return false;
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

  void closeStoreList() {
    for (final store in stores) {
      try {
        store.dispose();
      } catch (_) {}
    }
    stores.clear();
  }

  void onVisibilityChanged(
    VisibilityDetectorScreenType newType,
  ) {
    if (_currentVisibilityDetectorScreenType == newType) {
      return;
    }
    _currentVisibilityDetectorScreenType = newType;
    if (isInjectedScreenVisible) {
      _emitAllRxBusCallBacks();
    }
    for (var store in stores) {
      store.onVisibilityChanged(newType);
    }
  }

  ///* We will emit the callback immediately if injected screen is visible,
  ///* Otherwise, we will cache the callback and emit later
  ///* Should use it when [callBack] need call api to update latest data
  void emitRxBusCallBackIfNeeded(dynamic callBack) {
    if (isInjectedScreenVisible) {
      callBack?.call();
    } else if (!_rxCallbacks.contains(callBack)) {
      _rxCallbacks.add(callBack);
    }
  }

  ///* Emit all the rxCallbacks which stored and clear it
  void _emitAllRxBusCallBacks() {
    for (var callback in _rxCallbacks) {
      protectNonAsync(() {
        callback?.call();
      });
    }
    _rxCallbacks.clear();
  }

  @mustCallSuper
  void dispose() {
    _rxCallbacks.clear();
    closeStoreList();
    closeReactionDisposer();
    closeDisposeBag();
  }
}

enum VisibilityDetectorScreenType {
  /// Called when the widget becomes visible or enters foreground while visible.
  focus_gained,

  /// Called when the widget becomes invisible or enters background while visible.
  focus_lost,

  /// Called when the app entered the foreground while the widget is visible.
  foreground_gained,

  /// Called when the app is sent to background while the widget was visible.
  foreground_lost,

  /// Called when the widget becomes visible.
  visibility_gained,

  /// Called when the widget becomes invisible.

  visibility_lost,
}
