

import 'package:fish_redux/fish_redux.dart';
import 'package:fish_redux_todo_sample/todo_list_page/page.dart';
import 'package:fish_redux_todo_sample/todo_list_page/todo_component/state.dart';
import 'package:flutter/material.dart';

createApp() {
  // 定义路由
  final AbstractRoutes routes = PageRoutes(
    pages: <String, Page<Object, dynamic>>{
      /// 注册 TodoListPage
      'todo_list': TodoListPage(),
    },
  );
  return MaterialApp(
    title: 'To Do List',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    // 通过路由提取 page。 同时传入初始化参数
    home: routes.buildPage('todo_list', <TodoState>[
      TodoState()..title = "To Do 1",
      TodoState()..title = "To Do 2",
      TodoState()..title = "To Do 3",
    ]),
  );
}