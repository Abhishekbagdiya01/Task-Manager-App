import { Response, Router, Request } from "express";
import { db } from "../db"
import { NewUser, users } from "../db/schema";
import { eq } from "drizzle-orm";
import bcrypt from "bcryptjs"
import { IUserModel } from "../models/IUserModel";
import jwt from "jsonwebtoken";

const authRouter = Router();
authRouter.post("/signUp", async (req: Request, res: Response) => {
  try {
    // get req body
    const userModel: IUserModel = req.body;
    // check if the user already exists
    const existingUser = await db
      .select()
      .from(users)
      .where(eq(users.email, userModel.email));

    if (existingUser.length) {
      res
        .status(400)
        .json({ error: "User with the same email already exists!" });
      return;
    }

    // hashed pw
    const encryptPassword = await bcrypt.hash(userModel.password, 8);
    // create a new user and store in db
    const newUser: NewUser = {
      name: userModel.name,
      email: userModel.email,
      password: encryptPassword,
    };

    const [user] = await db.insert(users).values(newUser).returning();
    res.status(201).json(user);
  } catch (e) {
    res.status(500).json({ error: e });
  }
});

authRouter.post("/login", async (req: Request, res: Response) => {
  try {
    // get req body
    const userModel: IUserModel = req.body;
    // check if the user exists
    const [existingUser] = await db
      .select()
      .from(users)
      .where(eq(users.email, userModel.email));

    if (!existingUser) {
      res
        .status(400)
        .json({ error: "User with the same email doesn't exists!" });
      return;
    }

    const isMatch = await bcrypt.compare(userModel.password, existingUser.password)

    if (!isMatch) {
      res.status(400).json({
        error: "Incorrect password"
      });
      return;
    }
    const passKey: string = "passwordKey";
    const token = jwt.sign({ id: existingUser.id }, passKey)
    res.json({ token, ...existingUser })

  } catch (e) {
    res.status(500).json({ error: e });
  }
});

export default authRouter;
