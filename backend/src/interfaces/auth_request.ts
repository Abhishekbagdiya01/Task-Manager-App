import { UUID } from "node:crypto";
import { Request } from "express";
export interface AuthRequest extends Request {
  user?: UUID;
  token?: string;
}
