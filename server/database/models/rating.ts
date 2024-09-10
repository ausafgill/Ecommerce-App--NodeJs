import mongoose, { Schema } from "mongoose";
import { Rating } from "../interface/rating_interface";

export const ratingSchema=new Schema<Rating>({
    userId:{
        type:String,
        required:true

    },
    rating:{
type:Number,
required:true
    }
})