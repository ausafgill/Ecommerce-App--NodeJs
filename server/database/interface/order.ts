import { Document } from "mongoose";

export interface IOrderInterface{
    products:[],
    totalPrice:number,
    address:string,
    userId:string,
    orderAt:number,
    status:number



}