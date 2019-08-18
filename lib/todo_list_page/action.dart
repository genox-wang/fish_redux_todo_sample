import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum TodoListAction { action }

class TodoListActionCreator {
  static Action onAction() {
    return const Action(TodoListAction.action);
  }
}
