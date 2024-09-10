import { json } from "body-parser";
import {Router,Request,Response} from "express"
const helloRouter=Router();

helloRouter.get("/",(req:Request,res:Response)=>{
return res.json({data:"Server is Liveddd"})
});

export default helloRouter;