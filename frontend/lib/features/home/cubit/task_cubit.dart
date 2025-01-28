import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/home/models/task_model.dart';
import 'package:frontend/features/home/repository/task_remote_repository.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskInitial());
  TaskRemoteRepository taskRemoteRepository = TaskRemoteRepository();
  Future<void> addTask(TaskModel taskModel) async {
    try {
      emit(TaskInitial());
      TaskModel newTask = await taskRemoteRepository.addTask(taskModel);
      emit(TaskAdded(taskmodel: newTask));
    } catch (e) {
      emit(TaskError(errorMessage: e.toString()));
    }
  }

  Future<void> getTasks() async {
    try {
      emit(TaskLoading());
      List<TaskModel> allTasks = await taskRemoteRepository.getTasks();
      emit(TaskLoaded(allTasks: allTasks));
    } catch (e) {
      emit(TaskError(errorMessage: e.toString()));
    }
  }
}
