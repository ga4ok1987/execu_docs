import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:window_manager/window_manager.dart';

enum WindowMode { normal, maximized, minimized, fullscreen }

class WindowState {
  final double width;
  final double height;
  final double dx;
  final double dy;
  final WindowMode mode;

  const WindowState({
    required this.width,
    required this.height,
    required this.dx,
    required this.dy,
    this.mode = WindowMode.normal,
  });

  Map<String, dynamic> toMap() => {
    'width': width,
    'height': height,
    'dx': dx,
    'dy': dy,
    'mode': mode.index,
  };

  factory WindowState.fromMap(Map<String, dynamic> map) => WindowState(
    width: (map['width'] ?? 1000).toDouble(),
    height: (map['height'] ?? 700).toDouble(),
    dx: (map['dx'] ?? 100).toDouble(),
    dy: (map['dy'] ?? 100).toDouble(),
    mode: WindowMode.values[map['mode'] ?? 0],
  );

  WindowState copyWith({
    double? width,
    double? height,
    double? dx,
    double? dy,
    WindowMode? mode,
  }) {
    return WindowState(
      width: width ?? this.width,
      height: height ?? this.height,
      dx: dx ?? this.dx,
      dy: dy ?? this.dy,
      mode: mode ?? this.mode,
    );
  }
}

@injectable
class WindowCubit extends HydratedCubit<WindowState> with WindowListener {
  WindowCubit()
    : super(
        const WindowState(
          width: 1000,
          height: 700,
          dx: 100,
          dy: 100,
          mode: WindowMode.minimized,
        ),
      ) {
    init();
  }

  Future<void> init() async {
    await windowManager.ensureInitialized();
    windowManager.addListener(this);
    await windowManager.waitUntilReadyToShow();
    await windowManager.setMinimumSize(const Size(1000, 700));
    await restoreWindow();
  }

  Future<void> restoreWindow() async {
    switch (state.mode) {
      case WindowMode.normal:
        await windowManager.setBounds(
          Rect.fromLTWH(state.dx, state.dy, state.width, state.height),
        );
        break;
      case WindowMode.maximized:
        await windowManager.maximize();
        break;
      case WindowMode.minimized:
        await windowManager.minimize();
        break;
      case WindowMode.fullscreen:
        await windowManager.setFullScreen(true);
        break;
    }
  }

  @override
  void onWindowMove() async {
    final size = await windowManager.getSize();
    final pos = await windowManager.getPosition();
    emit(
      WindowState(
        width: size.width,
        height: size.height,
        dx: pos.dx,
        dy: pos.dy,
        mode: WindowMode.normal,
      ),
    );
  }

  @override
  void onWindowMaximize() async {
    final size = await windowManager.getSize();
    final pos = await windowManager.getPosition();
    emit(
      WindowState(
        width: size.width,
        height: size.height,
        dx: pos.dx,
        dy: pos.dy,
        mode: WindowMode.maximized,
      ),
    );
  }

  @override
  void onWindowUnmaximize() async {
    final size = await windowManager.getSize();
    final pos = await windowManager.getPosition();
    emit(
      WindowState(
        width: size.width,
        height: size.height,
        dx: pos.dx,
        dy: pos.dy,
        mode: WindowMode.normal,
      ),
    );
  }

  @override
  void onWindowMinimize() async {
    emit(state.copyWith(mode: WindowMode.minimized));
  }

  @override
  void onWindowRestore() async {
    final size = await windowManager.getSize();
    final pos = await windowManager.getPosition();
    emit(
      WindowState(
        width: size.width,
        height: size.height,
        dx: pos.dx,
        dy: pos.dy,
        mode: WindowMode.normal,
      ),
    );
  }

  @override
  WindowState? fromJson(Map<String, dynamic> json) {
    try {
      return WindowState.fromMap(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(WindowState state) => state.toMap();

  @override
  Future<void> close() {
    windowManager.removeListener(this);
    return super.close();
  }
}
