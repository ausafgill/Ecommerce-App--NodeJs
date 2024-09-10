import Jwt from "jsonwebtoken";
import { Request, Response, NextFunction } from 'express';

const auth=async(req: Request, res: Response,next:NextFunction)=>{
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
              req.user = (verified as { id: string }).id;
              req.token = token;
              next();
    } catch (error) {

        res.status(500).json({ error: error });
    }
}
export default auth;


