import { response, Router, Request } from "express";
import { IUserModel } from "../models/IUserModel";
const authRouter = Router();


authRouter.post("/signUp", async (req: Request, res) => {

  try {
    const userModel: IUserModel = req.body;
    res.status(200).send({
      message: `Username is ${userModel.name} and email is ${userModel.email}`
    })
  } catch (error) {

  }

});

export default authRouter;
