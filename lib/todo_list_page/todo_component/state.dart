import 'package:fish_redux/fish_redux.dart';

class TodoState implements Cloneable<TodoState> {
  // todo item 的标题
  String title = "";

  // 重写 clone 方法保证数据的完整拷贝
  @override
  TodoState clone() {
    return TodoState()
      ..title = title;
  }
}

TodoState initState(Map<String, dynamic> args) {
  return TodoState();
}
