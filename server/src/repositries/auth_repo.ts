import mongoose from "mongoose";
import { IUserInterface } from "../../database/interface/user_interface";
import UserModel from "../../database/models/user_model";


export const signupUserRepo = async (
  user: IUserInterface
): Promise<boolean> => {
  try {
    const existingUser = await UserModel.findOne({ email: user.email });
    if (existingUser) {
      return false;
    } else {
      const userCreate = await UserModel.create(user);
      return true;
    }
  } catch (error) {
    console.log(error);
    return false;
  }
};
