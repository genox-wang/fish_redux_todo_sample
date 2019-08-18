import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<TodoState> buildReducer() {
  return asReducer(
    <Object, Reducer<TodoState>>{
      TodoAction.action: _onAction,
    },
  );
}

TodoState _onAction(TodoState state, Action action) {
  final TodoState newState = state.clone();
  return newState;
}
