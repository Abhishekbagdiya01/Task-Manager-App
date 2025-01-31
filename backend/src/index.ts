import express from "express";
import authRouter from "./routes/auth_router";
import taskRouter from "./routes/task_router";
import appLogger from "./middleware/app_logger";
const app = express();
app.use(appLogger);
app.use(express.json());
app.use("/auth/", authRouter);
app.use("/tasks/", taskRouter);
app.get("/", (request: Express.Request, response: Express.Response | any) => {
  response.send(`Welcome to my app`);
});
app.listen(8000, () => {
  console.log(`Server started on port 8000~`);
});
