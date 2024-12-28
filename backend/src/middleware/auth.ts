import { Response, NextFunction } from "express"
import { AuthRequest } from "../interfaces/auth_request";
import Jwt from "jsonwebtoken";
import { UUID } from "crypto";
import { db } from "../db";
import { users } from "../db/schema";
import { eq } from "drizzle-orm";
export const auth = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    // get the header
    const token = req.header("x-auth-token");

    if (!token) {
      res.status(401).json({
        message: "No auth token, access denied!"
      });
      return;
    }
    // Verify the token
    const verified = Jwt.verify(token, "passwordKey");
    if (!verified) {
      res.status(401).json({ error: "Token verification failed" });
      return;
    }
    // get the user data
    const verifiedToken = verified as { id: UUID };
    const [user] = await db.select().from(users).where(eq(users.id, verifiedToken.id));

    if (!user) {
      res.status(401).json({
        error: "User not found!"
      });
    }

    req.user = verifiedToken.id;
    req.token = token;
    next();

  } catch (error) {
    res.status(500).json(error);
  }

};

