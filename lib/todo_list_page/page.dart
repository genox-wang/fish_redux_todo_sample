import 'package:fish_redux/fish_redux.dart';
import 'list_adapter/adapter.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class TodoListPage extends Page<TodoListState, dynamic> {
  TodoListPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<TodoListState>(
                // 添加 TodoListAdapter 依赖，并绑定数据
                adapter: ListStateConnector() + TodoListAdapter(),
                slots: <String, Dependent<TodoListState>>{
                }),
            middleware: <Middleware<TodoListState>>[
            ],);

}
