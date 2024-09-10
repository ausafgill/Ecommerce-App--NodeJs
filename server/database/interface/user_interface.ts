import mongoose,  { Document } from "mongoose";
export interface IUserInterface extends Document{
    name:string,
    email:string,
    password:string,
    address:string,
    type:string,
    cart: { product: mongoose.Document, quantity: number }[];
}