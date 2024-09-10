import express,{ Express } from "express";
import http from 'http'
import router from "./routes/routes"
import bodyParser  from "body-parser";
import cors from 'cors'
import { configDotenv } from "dotenv";

import dotenv,{config}from "dotenv"
import mongoose from "mongoose";
import { error } from "console";


dotenv.config()
const app:Express=express()
const server=http.createServer(app);
//console.log(`MONGO_DB_URI: ${process.env.MONGO_DB_URI}`);

app.use(cors());
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({extended:true}))
app.set('PORT',3000);
app.set('BASE_URL','localhost');
//middleware
app.use("/amazon/v1/",router)


const mongoUri = process.env.MONGO_DB_URI;

if (!mongoUri) {
    console.error("MONGODB URL NOT DEFINED");
    process.exit(1);
}

mongoose.connect(mongoUri, {})
    .then(() => {
        console.log("MongoDB connection successful");
    })
    .catch((error) => {
        console.error("Error connecting to MongoDB:", error);
    });



try {
    const port:Number=app.get("PORT");
    const base_Url:String=app.get("BASE_URL");
    server.listen(port,():void=>{
        console.log("Server is Listeninggg");
    })
} catch (error) {
    console.log(error);
    
}


