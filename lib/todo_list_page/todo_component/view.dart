import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(TodoState state, Dispatch dispatch, ViewService viewService) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.blueAccent)
    ),
    child: Text(
      state.title, // 标题文字绑定
      style: TextStyle(
        fontSize: 18,
        color: Colors.blueAccent
      ),
    ),
  );
}
