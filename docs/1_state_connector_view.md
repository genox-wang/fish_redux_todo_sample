# 从零开始 Fish Redux (一) —— 数据传递与展示

初学 Flutter 的时候自己实现过一个简单的 BloC 架构来实现状态管理。开始用起来挺顺手，但当业务复杂了之后，一个BloC拆分成3个BloC，3个BloC拆封成5个BloC后，你会发现数据绑定本身的 `StreamBuilder` 嵌套就会成为一个噩梦。

有过类似状态管理分治的失败经验后，我明白集中(Store和Monitor)和分治(State和View)的兼顾有多难。

这时候 fish-redux 出现了，感谢阿里开源 [fish-redus](https://github.com/alibaba/fish-redux)。 它完美了解决的集中和分治这对矛盾，为 Flutter 提供了完善的状态管理框架， 为大中型项目提供了编码规范。


## 一、如何学习

fish-redux 虽好，但说实话并不容易学，因为它和传统的 Flutter 开发习惯很不同。那该如何学呢？

根据我的采坑经验，我强烈建议以下学习路径

1. 过一遍[官方文档](https://github.com/alibaba/fish-redux/blob/master/doc/README-cn.md)，主要关注 `Action`,`Effect`,`Reducer`,`Connector` (如果看完一头雾水，很正常，因为现在文档还很零散，不适合初学者阅读，如果第一遍就看明白了，请容我膜拜)
2. 跑一下官方的 [sample](https://github.com/alibaba/fish-redux/tree/master/example)。这是一个 ToDoList 实现，阅读下源码(当然你可能还是一头雾水，这时候可以带着问题重温一下文档)
3. 动手实践实现一个 ToDoList

做完这三步，你基本也就入门了，可以自己体会框架的神奇之处了。

当然，你如果懒得运行 sample。那也没关系，请跟着我从零开始实现一个 ToDoList，拆解 fish-redux 的功能


## 二、 准备工作

### 安装模板插件 

[Fish Redux Template For Android Studio](https://github.com/BakerJQ/FishReduxTemplateForAS), by BakerJQ.
[Fish Redux Template For VSCode](https://github.com/huangjianke/fish-redux-template), by huangjianke.

这个插件会为你自动生成代码模板

### 用插件生成代码模板

我们先来分析一下页面结构：

一个简单的 ToDoList 界面应该这样  Page -> ListView -> ToDo

那我们在定义 fish-redux 模块的时候应该至少包含

1. todo_list_page  页面,装载整个页面内容
2. list_adapter  因为有 listView 所以需要一个 fish-redux 的适配器
3. todo_component listView 里的 todo 组件

好，那下面我们用插件生成模板，如下目录结构

```
.
├── lib
│   ├── app.dart
│   ├── main.dart
│   └── todo_list_page  // 页面
│       ├── action.dart
│       ├── effect.dart
│       ├── list_adapter  // 适配器
│       │   ├── action.dart
│       │   ├── adapter.dart
│       │   ├── reducer.dart
│       │   └── state.dart
│       ├── page.dart
│       ├── reducer.dart
│       ├── state.dart
│       ├── todo_component // Item组件
│       │   ├── action.dart
│       │   ├── component.dart
│       │   ├── effect.dart
│       │   ├── reducer.dart
│       │   ├── state.dart
│       │   └── view.dart
│       └── view.dart
```

哇靠，有那么多文件吗？ 不要着急，这一篇我们不会用到 Action  Effect 和 Reducer。 单独讲 State, Adapter 和 Connector。所以大部分你只要保持默认就可以。



`pubspec.yaml` 添加插件

```
dependencies:
  ...

  fish_redux: ^0.2.5
  logger: ^0.7.0+2 // 输出日志

```

## 三、Todo Component 

在 `todo_component/state.dart` 添加 `title` 字段为了 view 展示
```dart
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

```

`todo_component/view.dart` 中把 `title` 绑定到 Text 展示出来

重点来了！

你这里会发现 Component buildView 是无状态的，上下文相关。只能访问 `state` 里的数据。 以及 `viewService` 提供的上下文相关的数据(比如 adapter)。这样的数据隔离，会让你更专注的来实现 component 本身的功能 (adapter, page 同理)。

> 补充：平时写代码的时候会不会由于太过自由。从其他模块取数据太过容易，模块之间的数据相互引用修改成为稀疏平常的事情、这样不仅增加的状态维护的成本，也提高了后期排错的难度，同时更多的选择会影响你专注地完成模块的本职工作。fish-redux 提高了模块之间状态通信的成本，做好了隔离，让状态维护和监控成为可能。

```dart

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

```

## 四、Todo Adapter 

`list_adapter/state.dart` 也要在状态内定义自己使用的数据类型

```dart
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
```

好了，上面的 Todo Component 定义好了， `Adapter` 的 `State` 也定义好了，那是如何把 `toDos` 里的数据传给 `Component` 使用的呢？

`list_adapter/adapter.dart` 这里实现了 ListState 里的 toDos 和 Component 的绑定规则

这里用到了 `Connector` 但有注释应该不难理解

```dart

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
```

## 五、 To Do Page

`todo_list_page/state.dart` 这里也维护了自己的状态，和 `toDos` 数据，

这里还做了两件事

1. 通过初始化传参初始化了 `toDos`
2. 定义 Connector 实现与 `Adapter `的数据绑定规则

```dart
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
```

上面只是实现了 `ListState` 里的 `toDos` 和 `Component` 的绑定规则，还有 `Page` 到 `Adapter` 的绑定规则，但实际绑定的动作在哪里做的呢？

就通过 `adapter: ListStateConnector() + TodoListAdapter(),`, 这里把绑定数据的 adapter 用作 page 的依赖

`todo_list_page/page.dart`

```dart
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
```

这里可以通过`viewService.buildAdapter()` 得到刚刚绑定的 adapter 并实现渲染

`todo_list_page/view.dart`

```dart
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
```

刚刚把整个 `Page` 实现了，但无法直接挂在到原来的页面上。需要通过定义 `PageRoutes` 注册路由。通过 `routes.buildPage('todo_list', params)` 来提取 page 和传参数。(这个也是官方文档缺失的部分。所以初学者都会看的一头雾水。之后如果有 `Quick Start` 的话或许会加入)

`app.dart`
```dart
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
```

## 六、运行效果

<image src="img/todo_list_0.png", width="300px">

这个时候可能很多小伙伴心里暗骂了， 一顿花里胡哨就实现了这么一个东西 ？ - -||

下面那么点代码不就搞定了吗？ 

```dart
createApp() {
  final items = <String>[
    "To Do 1",
    "To Do 2",
    "To Do 3"
  ]
  return MaterialApp(
    title: 'To Do List',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home:Scaffold(
      appBar: AppBar(
        title: Text(
          "To Do List"
        ),
      ),
      body: ListView(
        children: items.map((item) => Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent)
          ),
          child: Text(
            state.item,
            style: TextStyle(
              fontSize: 18,
              color: Colors.blueAccent
            ),
          ),
        )).toList()
      )
    )
  );
}
```

## 七、总结

的确 To Do List 这么简单的项目不需要用到那么重的框架(何况这一篇只实现了数据传递和展现)。但当业务越来越复杂之后，你会体会到这套框架给你带来的好处。

1. 更专注开发每个模块功能，让每个模块交付一个确定性。只有保证每个模块的确定性，才能保证最终项目的可维护和确定性
2. 为我们提供了良好的目录和编码规范。强制实现业务和View隔离，让后期代码更容易维护
3. 模块想怎么拆分就怎么拆分，你只需要定义规则。框架自动帮你实现了 State 的合并
4. 集中式的状态管理，让插桩，监控，回滚模块的开发成为可能

下一篇开始我会通过 `Effect` `Reducer` `Action` 实现事件的传输和数据的双向绑定，那才是 `redux` 精髓。

最后我想说，虽然入门学习成本很高。但当学会了熟练了之后，你的开发效率不会比原来低，因为插件已经帮你生成必须的模板，你指需要添加你的状态、事件、view 和业务逻辑就可以了。