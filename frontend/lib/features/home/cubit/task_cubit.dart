import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/home/models/task_model.dart';
import 'package:frontend/features/home/repository/task_local_repository.dart';
import 'package:frontend/features/home/repository/task_remote_repository.dart';
part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskInitial());
  TaskRemoteRepository taskRemoteRepository = TaskRemoteRepository();
  TaskLocalRepository taskLocalRepository = TaskLocalRepository();
  // Future<void> addTask(TaskModel taskModel) async {
  //   try {
  //     emit(TaskInitial());
  //     TaskModel newTask = await taskRemoteRepository.addTask(taskModel);
  //     await taskLocalRepository.insertTask(taskModel);
  //     emit(TaskAdded(taskmodel: newTask));
  //   } catch (e) {
  //     emit(TaskError(errorMessage: e.toString()));
  //   }
  // }

  // Future<void> getTasks() async {
  //   try {
  //     emit(TaskLoading());
  //     List<TaskModel> allTasks = await taskRemoteRepository.getTasks();
  //     emit(TaskLoaded(allTasks: allTasks));
  //   } catch (e) {
  //     emit(TaskError(errorMessage: e.toString()));
  //   }
  // }

  // Future<void> syncTasks() async {
  //   final unSyncedTasks = await taskLocalRepository.getUnsyncedTasks();

  //   unSyncedTasks.forEach(
  //     (element) {
  //       log(" Title : ${element.title}, Is Synced? : ${element.id} ");
  //     },
  //   );
  //   if (unSyncedTasks.isEmpty) {
  //     return;
  //   }
  //   final isSynced = await taskRemoteRepository.syncTask(unSyncedTasks);
  //   log(isSynced.toString());
  //   if (isSynced) {
  //     for (final task in unSyncedTasks) {
  //       taskLocalRepository.updateRow(task.id!, 1);
  //     }
  //   }
  // }

  //

  Future<void> loadTasks() async {
    emit(TaskLoading());
    try {
      var tasks = await taskLocalRepository.getTasks();

      if (tasks.isEmpty) {
        // Fetch from remote if local DB is empty
        tasks = await taskRemoteRepository.getTasks();
        for (var task in tasks) {
          await taskLocalRepository.insertTask(task); // Store in local DB
        }
      }

      emit(TaskLoaded(allTasks: tasks));
      await syncTasks(); // Try syncing on startup
    } catch (e) {
      emit(TaskError(errorMessage: e.toString()));
    }
  }

  Future<void> addTask(TaskModel task) async {
    try {
      await taskLocalRepository.insertTask(task);
      final tasks = await taskLocalRepository.getTasks();
      emit(TaskAdded());
      await syncTasks(); // Try syncing immediately after adding
    } catch (e) {
      emit(TaskError(errorMessage: e.toString()));
    }
  }

  Future<void> syncTasks() async {
    try {
      final unsyncedTasks = await taskLocalRepository.getUnsyncedTasks();
      if (unsyncedTasks.isNotEmpty) {
        bool result = await taskRemoteRepository.syncTask(unsyncedTasks);
        if (result) {
          for (var task in unsyncedTasks) {
            await taskLocalRepository.updateRow(task.id!, 1); // Mark as synced
          }
        }
      }
      final tasks = await taskLocalRepository.getTasks();
      emit(TaskLoaded(allTasks: tasks));
    } catch (e) {
      emit(TaskError(errorMessage: e.toString()));
    }
  }
}
