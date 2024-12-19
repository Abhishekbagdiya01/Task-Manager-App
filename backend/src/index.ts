import express from "express";
import authRouter from "./routes/auth";

const hostname = "localhost";
const app = express();
app.use(express.json())
app.use("/auth/", authRouter)
app.get("/", (reqest: Express.Request, response: Express.Response | any) => {
  response.send(`Welcome to my app`);
})

app.listen(8000, () => {
  console.log(`Server started on port 8000~`);
})
