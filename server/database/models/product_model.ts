import mongoose, { Schema } from "mongoose";
import { IProductInterface } from "../interface/product_interface";
import { ratingSchema } from "./rating";
export const productSchema=new Schema<IProductInterface> ({
    name:{
        type:String,
        required:true,
        trim:true,
    },
    description:{
        type:String,
        required:true,
        trim:true,
    },
    category:{
        type:String,
        required:true
    },
    quantity:{
        type:Number,
        required:true,

    },
    price:{
        type:Number,
        required:true,
    },
    images:{
        type:[],
        required :true
    },
    ratings:
        [ratingSchema]
    
})
const ProductModel= mongoose.model<IProductInterface>("ProductModel",productSchema);
export default ProductModel;