import { Request, Response, Router } from "express";
import { db } from "../db/db";
import { NewUser, users } from "../db/schema";
import { eq } from "drizzle-orm";
import bcrypt from "bcryptjs";
import { IUserModel } from "../models/IUserModel";
import jwt from "jsonwebtoken";
import { auth } from "../middleware/auth";
import { AuthRequest } from "../interfaces/auth_request";
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
    res.status(200).json(user);
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
    const isMatch = await bcrypt.compare(
      userModel.password,
      existingUser.password,
    );
    if (!isMatch) {
      res.status(400).json({
        error: "Incorrect password",
      });
      return;
    }
    const passKey: string = "passwordKey";
    const token = jwt.sign({ id: existingUser.id }, passKey);
    res.json({ token, ...existingUser });
  } catch (e) {
    res.status(500).json({ error: e });
  }
});
authRouter.post("/tokenIsValid", async (req: Request, res: Response) => {
  try {
    //get the header
    const token = req.header("x-auth-token");
    if (!token) {
      res.json(false);
      return;
    }
    // verify the token if token is valid
    const verified = jwt.verify(token, "passwordKey");
    if (!verified) {
      res.json(false);
      return;
    }
    const varifiedToken = verified as {
      id: string;
    };
    const [user] = await db.select().from(users).where(
      eq(users.id, varifiedToken.id),
    );
    if (!user) {
      res.json(false);
      return;
    }
    res.json(true);
  } catch (e) {
    res.status(500).json({
      erro: e,
    });
  }
});
authRouter.get("/", auth, async (req: AuthRequest, res: Response) => {
  try {
    if (!req.user) {
      res.status(401).json({
        message: "User not found",
      });
      return;
    }
    const [user] = await db.select().from(users).where(eq(users.id, req.user));
    res.json({ ...user, token: req.token });
  } catch (e) {
    res.status(500).json({ error: e });
  }
});
export default authRouter;
