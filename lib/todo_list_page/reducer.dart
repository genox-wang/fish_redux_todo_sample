import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<TodoListState> buildReducer() {
  return asReducer(
    <Object, Reducer<TodoListState>>{
      TodoListAction.action: _onAction,
    },
  );
}

TodoListState _onAction(TodoListState state, Action action) {
  final TodoListState newState = state.clone();
  return newState;
}
