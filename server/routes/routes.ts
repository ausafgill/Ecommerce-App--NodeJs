import {Router} from "express"
import authRouter from "./auth.router";
import helloRouter from "./hello.router";

    import adminRouter from "./adminrouter";
import { productRouter } from "./product";
import userRouter from "./user.router";



const router=Router();

router.use('/user/signup',authRouter)
router.use('/user',authRouter)
router.use('/hello',helloRouter)
router.use('/admin',adminRouter)
router.use('/product',productRouter)
router.use('/cart',userRouter)
export default router;