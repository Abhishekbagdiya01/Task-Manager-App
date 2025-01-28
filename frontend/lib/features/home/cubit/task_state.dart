part of 'task_cubit.dart';

sealed class TaskState {}

final class TaskInitial extends TaskState {}

final class TaskAdded extends TaskState {
  final TaskModel taskmodel;

  TaskAdded({required this.taskmodel});
}

final class TaskLoaded extends TaskState {
  final List<TaskModel> allTasks;

  TaskLoaded({required this.allTasks});
}

final class TaskLoading extends TaskState {}

final class TaskError extends TaskState {
  final String errorMessage;
  TaskError({required this.errorMessage});
}
