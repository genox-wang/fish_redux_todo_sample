import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(TodoListState state, Dispatch dispatch, ViewService viewService) {
  // 取出绑定的适配器
  final ListAdapter adapter = viewService.buildAdapter();
  return Scaffold(
    appBar: AppBar(
      title: Text(
        "To Do List"
      ),
    ),
    body: ListView.builder(
      // 适配器为我们提供了 buidler 和 count 接口
      itemBuilder: adapter.itemBuilder,
      itemCount: adapter.itemCount,
    )
  );
}
