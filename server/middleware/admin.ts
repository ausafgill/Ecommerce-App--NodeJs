import Jwt from "jsonwebtoken";
import { Request, Response, NextFunction } from 'express';
import UserModel from "../database/models/user_model";

const admin=async(req: Request, res: Response,next:NextFunction)=>{
    try {
        const token=req.header("token");
        if(!token){
            return res.status(401).json({msg:"No auth token,access denied"});
            
        }
        const verified=Jwt.verify(token,"passwordKey");
        if (!verified)
            return res
              .status(401)
              .json({ msg: "Token verification failed, authorization denied." });
              const user= await UserModel.findById( (verified as { id: string }).id);
              if(user?.type=='user' || user?.type=='seller'){
                return res.status(401).json({msg:"You are not an admin!"})

              }
             
              req.user = (verified as { id: string }).id;
              req.token = token;
              next();
    } catch (error) {

        res.status(500).json({ error: error });
    }
}
export default admin;


