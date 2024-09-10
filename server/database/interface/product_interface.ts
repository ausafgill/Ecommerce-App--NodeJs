import { Document } from "mongoose";
import { Rating } from "./rating_interface";

export interface IProductInterface extends Document{
    name:string,
    description:string,
    category:string,
    images:[],
    price:number,
    quantity:number,
    ratings:Rating[]
    



}