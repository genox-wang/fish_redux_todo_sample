import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<TodoListState> buildEffect() {
  return combineEffects(<Object, Effect<TodoListState>>{
    TodoListAction.action: _onAction,
  });
}

void _onAction(Action action, Context<TodoListState> ctx) {
}
