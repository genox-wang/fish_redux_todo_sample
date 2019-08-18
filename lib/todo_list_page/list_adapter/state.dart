import 'package:fish_redux/fish_redux.dart';
import 'package:fish_redux_todo_sample/todo_list_page/todo_component/state.dart';

class ListState implements Cloneable<ListState> {
  // toDos 数据
  List<TodoState> toDos;

  @override
  ListState clone() {
    return ListState()
      ..toDos = toDos;
  }
}

ListState initState(Map<String, dynamic> args) {
  return ListState();
}
