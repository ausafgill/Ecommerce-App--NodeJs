import mongoose, { Schema } from "mongoose";
import { IOrderInterface } from "../interface/order";
import { productSchema } from "./product_model";

export const orderSchema = new Schema<IOrderInterface>({
  products: [
    {
      product: productSchema,
      quantity: {
        type: Number,
        required: true,
      },
    },
  ],
  totalPrice: {
    type: Number,
    required: true,
  },
  address: {
    type: String,
    required: true,
  },
  userId: {
    type: String,
    required: true,
  },
  orderAt: {
    type: Number,
    required: true,
  },
  status: {
    type: Number,
    default: 0,
  },
});
export const OrderModel=mongoose.model<IOrderInterface>("Order Model",orderSchema);