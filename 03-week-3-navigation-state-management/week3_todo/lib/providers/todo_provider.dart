import 'package:flutter_riverpod/flutter_riverpod.dart';

class Todo {
  Todo(this.title, {this.done = false});
  final String title;
  final bool done;

  Todo copyWith({String? title, bool? done}) =>
      Todo(title ?? this.title, done: done ?? this.done);
}

class TodoListNotifier extends Notifier<List<Todo>> {
  @override
  List<Todo> build() => const [];

  void add(String title) => state = [...state, Todo(title)];

  void toggle(Todo target) {
    state = [
      for (final todo in state)
        if (todo == target) todo.copyWith(done: !todo.done) else todo
    ];
  }

  void remove(Todo target) {
    state = state.where((todo) => todo != target).toList();
  }
}

final todoListProvider =
    NotifierProvider<TodoListNotifier, List<Todo>>(TodoListNotifier.new);

final unfinishedTodoProvider = Provider<List<Todo>>((ref) {
  final allTodos = ref.watch(todoListProvider);
  return allTodos.where((todo) => !todo.done).toList();
});