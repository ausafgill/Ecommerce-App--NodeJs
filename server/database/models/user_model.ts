import mongoose, { Document, Schema } from "mongoose";
import { IUserInterface } from "../interface/user_interface";
import { productSchema } from "./product_model";


const userSchema = new Schema<IUserInterface>({
  name: { type: String, required: true },
  email: {
    type: String,
    required: true,

    validate: {
      validator: (value) => {
        const re =
          /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
        return value.match(re);
      },
      message: "Enter Valid Email",
    },
  },
  password: { type: String, required: true,


    validate: {
      validator: (value) => {
        
        return value.length>=6;
      },
      message: "Enter password atleast 6 letters long",
    },
   },
  address: { type: String, default: "" },
  type: { type: String, default: "user" },
  cart:[
  // {
  //   product:productSchema,
  //   quantity:{
  //     type:Number,
  //     required:true
  //   }
  // }
{
  product: { type: productSchema, required: true },
  quantity: { type: Number, required: true },
}
  ]
});

const UserModel = mongoose.model<IUserInterface>("UserModel", userSchema);
export default UserModel;
