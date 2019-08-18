import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<TodoState> buildEffect() {
  return combineEffects(<Object, Effect<TodoState>>{
    TodoAction.action: _onAction,
  });
}

void _onAction(Action action, Context<TodoState> ctx) {
}
