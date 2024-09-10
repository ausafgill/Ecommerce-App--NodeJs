import { Request, Response } from "express";

import Jwt from "jsonwebtoken";
import { signinUserRepo, signupUserRepo } from "../repositries/auth_repo";
import { error } from "console";
import { IUserInterface } from "../database/interface/user_interface";

export const signupUserController = async (req: Request, res: Response) => {
  const user: IUserInterface = req.body;

  try {
    const userCreate = await signupUserRepo(user);
    if (userCreate) {
      res.status(200).json({ data: user });
    } else {
      res.status(400).json({ error: "User Already Exists" });
    }
  } catch (error) {
    res.status(500).json({ error: error });
  }
};

export const signinUserController = async (req: Request, res: Response) => {
  const { email, password } = req.body;
  try {
    const { user, isMatch } = await signinUserRepo(password, email);
    if (!user) {
    return  res.status(400).json({ error: "User with email not found" });
    }
    if (!isMatch) {
      return res.status(400).json({ error: "Incorrect Password" });
    }
    if (user) {
      const token = Jwt.sign({ id: user._id }, "passwordKey");
      res.json({ token, ...user.toObject() });
    }
  } catch (error) {
    res.status(500).json({ error: error });
  }
};

