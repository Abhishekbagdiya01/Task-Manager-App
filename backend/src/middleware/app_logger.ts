import { Request, Response, NextFunction } from "express";

let appLogger = (req: Request, res: Response, next: NextFunction) => {
  const url = req.url;
  const method = req.method;
  console.log(`Request to ${url} with method ${method}`);
  next();
}
export default appLogger
