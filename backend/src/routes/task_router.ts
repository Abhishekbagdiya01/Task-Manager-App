import { Router, Request, Response } from "express";
import { db } from "../db/db";
import { tasks, NewTask } from "../db/schema";
import { ITaskModel } from "../models/ITask_model";
import { eq } from "drizzle-orm";
import { auth } from "../middleware/auth";
import { AuthRequest } from "../interfaces/auth_request";
export const taskRouter = Router();
//Fetch All Task
taskRouter.get("/", auth, async (req: AuthRequest, res: Response) => {
  try {
    // add task to the db
    const taskList = await db
      .select()
      .from(tasks).where(eq(tasks.uid, req.user!));
    // send Response
    res.status(200).json(taskList);
  } catch (e) {
    res.status(500).json({ error: e });
  }
});

//Create Task
taskRouter.post("/addTask", auth, async (req: AuthRequest, res: Response) => {
  try {
    //get body
    req.body = { ...req.body, uid: req.user }
    const taskModel: ITaskModel = req.body;
    console.log(taskModel);
    // create new task
    const newTask: NewTask = {
      id: taskModel.id,
      uid: taskModel.uid,
      title: taskModel.title,
      description: taskModel.description,
      hexColor: taskModel.hexColor,
      dueAt: new Date(taskModel.dueAt),
    }
    // add task to the db
    const [task] = await db
      .insert(tasks)
      .values(newTask)
      .returning();
    // send Response
    res.status(200).json(task);
  } catch (e) {
    res.status(500).json({ error: e });
  }
});
// Sync Task
taskRouter.post("/syncTask", auth, async (req: AuthRequest, res: Response) => {
  try {
    //get body
    const taskList = req.body;
    const filteredList: NewTask[] = [];
    for (let task of taskList) {
      task = {
        ...task,
        dueAt: new Date(task.dueAt),
        createdAt: new Date(task.createdAt),
        updatedAt: new Date(task.updatedAt),
        uid: req.user
      };
      filteredList.push(task);
    }
    // add task to the db
    const pushedTask = await db.insert(tasks).values(filteredList).returning();
    // send Response
    console.log(pushedTask);
    res.status(200).json(pushedTask);
  } catch (e) {
    console.log(e);
    res.status(500).json({ error: e });
  }
});
//Delete Task
taskRouter.delete("/deleteTask", auth, async (req: AuthRequest, res: Response) => {
  try {
    //get body
    const taskId = req.body.id;
    // Delete Task
    await db
      .delete(tasks)
      .where(eq(tasks.id, taskId));
    // send Response
    res.status(200).json(true);
  } catch (e) {
    res.status(500).json({ error: e });
  }
});
export default taskRouter;
