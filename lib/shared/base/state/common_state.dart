import 'package:kiratoxz_flutter/shared/base/error/error.dart';

enum CommonStateType {
  initial,
  loading,
  error,
  success,
}

extension CommonStateTypeExt on CommonStateType {
  bool get isInitial => this == CommonStateType.initial;
  bool get isLoading => this == CommonStateType.loading;
  bool get isError => this == CommonStateType.error;
  bool get isSuccess => this == CommonStateType.success;
}

class CommonState<T> {
  final T? data;
  final Object? error;
  final Object? loadingData;

  final CommonStateType type;

  bool get hasData => data != null;

  bool get hasError => error != null;

  bool get isLoading => type == CommonStateType.loading;

  bool get isNoInternetError {
    if (error is ErrorException) {
      return (error as ErrorException).code == ErrorException.noInternetCode;
    }
    final noInternet = ErrorException.noInternet();
    return noInternet.toString() == error.toString();
  }

  const CommonState({
    this.data,
    this.error,
    this.type = CommonStateType.initial,
    this.loadingData,
  });

  factory CommonState.initial() {
    return const CommonState(type: CommonStateType.initial);
  }

  factory CommonState.loading([Object? loadingData]) {
    return CommonState(
      type: CommonStateType.loading,
      loadingData: loadingData,
    );
  }

  factory CommonState.success([T? data]) {
    return CommonState(data: data, type: CommonStateType.success);
  }

  factory CommonState.error(Object error) {
    return CommonState(type: CommonStateType.error, error: error);
  }

  Result? maybeWhen<Result>({
    Result Function()? initial,
    required Result Function() loading,
    required Result Function(T? data) success,
    required Result Function(Object? error) error,
    Result Function()? orElse,
  }) {
    switch (type) {
      case CommonStateType.initial:
        return initial?.call() ?? orElse?.call();
      case CommonStateType.loading:
        return loading.call() ?? orElse?.call();
      case CommonStateType.error:
        return error.call(this.error) ?? orElse?.call();
      case CommonStateType.success:
        return success.call(data) ?? orElse?.call();
      default:
        return orElse?.call();
    }
  }

  Result? whenListenReaction<Result>({
    Result Function()? initial,
    required Result Function() loading,
    required Result Function(T? data) success,
    required Result Function(Object? error) error,
    Result Function()? orElse,
  }) {
    return maybeWhen(
      loading: loading,
      success: success,
      error: error,
      orElse: orElse,
    );
  }

  Result? whenRenderWidget<Result>({
    Result Function()? initial,
    required Result Function() loading,
    required Result Function(T? data) success,
    required Result Function(Object? error) error,
    Result Function()? orElse,
  }) {
    switch (type) {
      case CommonStateType.initial:
        return initial?.call() ?? orElse?.call();
      case CommonStateType.loading:
        if (this.data != null) {
          return success.call(data) ?? orElse?.call();
        }
        return loading.call() ?? orElse?.call();
      case CommonStateType.error:
        if (this.data != null) {
          return success.call(data) ?? orElse?.call();
        }
        return error.call(this.error) ?? orElse?.call();
      case CommonStateType.success:
        return success.call(data) ?? orElse?.call();
      default:
        return orElse?.call();
    }
  }

  Result? maybeWhenV2<Result>({
    Result Function()? initial,
    required Result Function(Object? loadingData) loading,
    required Result Function(T? data) success,
    required Result Function(Object? error) error,
    Result Function()? orElse,
  }) {
    switch (type) {
      case CommonStateType.initial:
        return initial?.call() ?? orElse?.call();
      case CommonStateType.loading:
        return loading.call(loadingData) ?? orElse?.call();
      case CommonStateType.error:
        return error.call(this.error) ?? orElse?.call();
      case CommonStateType.success:
        return success.call(data) ?? orElse?.call();
      default:
        return orElse?.call();
    }
  }

  Result? only<Result>({
    Result Function()? initial,
    Result Function()? loading,
    Result Function(T? data)? success,
    Result Function(Object? error)? error,
  }) {
    switch (type) {
      case CommonStateType.initial:
        return initial?.call();
      case CommonStateType.loading:
        return loading?.call();
      case CommonStateType.error:
        return error?.call(this.error);
      case CommonStateType.success:
        return success?.call(data);
    }
  }

  Result? onlyV2<Result>({
    Result Function()? initial,
    Result Function(Object? loadingData)? loading,
    Result Function(T? data)? success,
    Result Function(Object? error)? error,
  }) {
    switch (type) {
      case CommonStateType.initial:
        return initial?.call();
      case CommonStateType.loading:
        return loading?.call(loadingData);
      case CommonStateType.error:
        return error?.call(this.error);
      case CommonStateType.success:
        return success?.call(data);
    }
  }

  Result? onlyRenderWidget<Result>({
    Result Function()? initial,
    Result Function()? loading,
    Result Function(T? data)? success,
    Result Function(Object? error)? error,
    Result Function()? orElse,
  }) {
    switch (type) {
      case CommonStateType.initial:
        return initial?.call() ?? orElse?.call();
      case CommonStateType.loading:
        if (this.data != null) {
          return success?.call(data) ?? orElse?.call();
        }
        return loading?.call() ?? orElse?.call();
      case CommonStateType.error:
        if (this.data != null) {
          return success?.call(data) ?? orElse?.call();
        }
        return error?.call(this.error) ?? orElse?.call();
      case CommonStateType.success:
        return success?.call(data) ?? orElse?.call();
      default:
        return orElse?.call();
    }
  }

  CommonState<E> copyWith<E>({
    E? data,
    Object? error,
    CommonStateType? type,
    Object? loadingData,
  }) {
    return CommonState<E>(
      data: data ?? (this.data is E ? (this.data as E) : null),
      error: error ?? this.error,
      type: type ?? this.type,
      loadingData: loadingData ?? this.loadingData,
    );
  }

  @override
  String toString() {
    return 'CommonState(data: $data, error: $error, loadingData: $loadingData, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CommonState<T> &&
        other.data == data &&
        other.error == error &&
        other.loadingData == loadingData &&
        other.type == type;
  }

  @override
  int get hashCode {
    return data.hashCode ^
        error.hashCode ^
        loadingData.hashCode ^
        type.hashCode;
  }
}
