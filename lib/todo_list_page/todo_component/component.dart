import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class TodoComponent extends Component<TodoState> {
  TodoComponent()
      : super(
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<TodoState>(
                adapter: null,
                slots: <String, Dependent<TodoState>>{
                }),);

}
