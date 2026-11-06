import 'package:flutter_riverpod/flutter_riverpod.dart';

final shellProvider =
    StateNotifierProvider<ShellNotifier, ShellState>((ref) {
  return ShellNotifier();
});

class ShellState {
  final int index;

  const ShellState({this.index = 0});

  ShellState copyWith({int? index}) => ShellState(index: index ?? this.index);
}

class ShellNotifier extends StateNotifier<ShellState> {
  ShellNotifier() : super(const ShellState());

  void select(int index) {
    if (index < 0 || index > 3 || index == state.index) return;
    state = state.copyWith(index: index);
  }
}
