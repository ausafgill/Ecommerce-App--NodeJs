import { Router } from "express";
import { signinUserController, signupUserController } from "../controller/authcontroller";
import { identifierToKeywordKind } from "typescript";
import Jwt from "jsonwebtoken";
import UserModel from "../database/models/user_model";
import auth from "../middleware/auth";


const authRouter=Router();

authRouter.post('/',signupUserController);
authRouter.post('/signin',signinUserController);



authRouter.post('/tokenIsValid',async(req,res)=>{
    try {
        const token =req.header('token');
        if(!token) return res.json(false);
        const verified= Jwt.verify(token,"passwordKey");
        if(!verified) return res.json(false);


       // const user=await UserModel.findById(verified.id);
       const user = await UserModel.findById((verified as { id: string }).id);
       if(!user) return res.json(false);
       res.json(true);
    } catch (error) {
        
    }
})
// get user data
authRouter.get("/", auth, async (req, res) => {
    const user = await UserModel.findById(req.user);
    res.json({ ...user?.toObject(), token: req.token });
  });

export default authRouter
