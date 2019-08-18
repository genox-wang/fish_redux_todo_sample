import 'package:fish_redux/fish_redux.dart';

import 'list_adapter/state.dart';
import 'todo_component/state.dart';

class TodoListState implements Cloneable<TodoListState> {

  // 存放 Todo 信息
  List<TodoState> toDos;

  @override
  TodoListState clone() {
    return TodoListState()
      ..toDos = toDos;
  }
}

// 改方法在路由初始化的时候调用, args 的内容为 routes.buildPage('list_todo', args) 里传参, 需要通过 args 初始化 state 的话可以在这里操作
TodoListState initState(dynamic args) {
  final toDos = args as List<TodoState>;
  return TodoListState()
    ..toDos = toDos ?? <TodoState>[];
}


// 定义 Page 和 Adapter 的数据绑定, 这里实现一个 Connector TodoListState 里的 toDos
// 赋值给了 ListState 的 toDos， 但组织了逆向赋值 
// Connector 绑定 Adapter 操作在 page.dart 里进行
class ListStateConnector extends Reselect1<TodoListState, ListState, List<TodoState>> {
  @override
  ListState computed(List<TodoState> toDos) {
    return ListState()
      ..toDos = toDos;
  }

  @override
  List<TodoState> getSub0(TodoListState state) {
    return state.toDos;
  }

  @override
  void set(TodoListState state, ListState subState) {
    throw Exception('Unexcepted to set TodoListState from ListState');
  }

}