import 'package:fish_redux/fish_redux.dart';
import '../todo_component/component.dart';
import '../todo_component/state.dart';

import 'reducer.dart';
import 'state.dart';

class TodoListAdapter extends DynamicFlowAdapter<ListState> {
  TodoListAdapter()
      : super(
          pool: <String, Component<Object>>{
            // 定义组件绑定, toDo 是key,它会在 Connector 里用到
            "toDo": TodoComponent()
          },
          connector: _ListConnector(),
          reducer: buildReducer(),
        );
}

// ItemBean 对象定义了实际数据与组件绑定
class _ListConnector extends ConnOp<ListState, List<ItemBean>> {
  // get 定义了 state 到 ItemBean 的正向绑定
  @override
  List<ItemBean> get(ListState state) {
    if (state.toDos?.isNotEmpty == true) {
      return state.toDos
        .map((todo) => ItemBean("toDo", todo))
        .toList();
    }
    return <ItemBean>[];
  }

  // set 定义了 ItemBean 到 state 的逆向绑定
  @override
  void set(ListState state, List<ItemBean> toDos) {
    if (toDos?.isNotEmpty == true) {
      state.toDos = List<TodoState>.from(
        toDos.map((todo) => todo).toList());
    } else {
      state.toDos = <TodoState>[];
    }
  }
}
