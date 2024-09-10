import mongoose from "mongoose";
import { IUserInterface } from "../database/interface/user_interface";
import UserModel from "../database/models/user_model";
import bcrypt from "bcryptjs";
import { Hash } from "crypto";
import { writeFile } from "fs/promises";

export const signupUserRepo = async (
  user: IUserInterface
): Promise<boolean> => {
  try {
    if (!user.password) {
      throw new Error("Password is required");
    }

    const existingUser = await UserModel.findOne({ email: user.email });
    if (existingUser) {
      console.log(`User with email ${user.email} already exists.`);
      return false;
    }

    const hashedPass = await bcrypt.hash(user.password, 8);

    const newUser = new UserModel({
      name: user.name,
      email: user.email,
      password: hashedPass,
    });

    await newUser.save();

    return true;
  } catch (error) {
    console.error("Error during user signup:", error);
    return false;
  }
};

export const signinUserRepo = async (
  password: any,
  email: string
): Promise<{ user: IUserInterface | null; isMatch: boolean }> => {
  try {
    const user = await UserModel.findOne({ email: email });
    if (!user) {
      console.log("USER NOT FOUND");
      return { user: null, isMatch: false };
    }

    const isMatch = await bcrypt.compare(password, user.password);
    return { user, isMatch };
  } catch (error) {
    console.log(error);
    return { user: null, isMatch: false };
  }
};
