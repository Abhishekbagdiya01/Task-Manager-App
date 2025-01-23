import { Router, Request, Response } from "express";
import { db } from "../db/db";
import { tasks, NewTask } from "../db/schema";
import { ITaskModel } from "../models/ITask_model";
import { eq } from "drizzle-orm";
const taskRouter = Router();
//Fetch All Task
taskRouter.post("/", async (req: Request, res: Response) => {
  try {
    //get body
    const uid = req.body;

    // add task to the db
    const taskList = await db
      .select()
      .from(tasks).where(eq(tasks.uid, uid));
    // send Response
    res.status(200).json(taskList);
  } catch (e) {
    res.status(500).json({ error: e });
  }
});

//Create Task
taskRouter.post("/createTask", async (req: Request, res: Response) => {
  try {
    //get body
    const taskModel: ITaskModel = req.body;
    // create new task
    const newTask: NewTask = {
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
//Delete Task
taskRouter.delete("/updateTask", async (req: Request, res: Response) => {
  try {
    //get body
    const taskId = req.body;
    // Delete Task
    await db
      .delete(tasks)
      .where(eq(tasks.id, taskId));
    // send Response
    res.status(200).json({
      "message": "Task deleted successfully"
    });
  } catch (e) {
    res.status(500).json({ error: e });
  }
});
export default taskRouter;
