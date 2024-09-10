import { Router } from "express";
import auth from "../middleware/auth";
import { addToCartController, fetchUserData, getAllOrdersController, orderPlaceController, removeFromCartController, saveUserAddressController } from "../controller/usercontroller";
import { removeFromCartRepo } from "../repositries/userrepo";

const userRouter=Router()
userRouter.post('/add-to-cart',auth,addToCartController)
userRouter.delete('/remove-from-cart/:id',auth,removeFromCartController)
userRouter.get('/fetchUser',auth,fetchUserData)
userRouter.post('/save-address',saveUserAddressController);
userRouter.post('/place-order',auth,orderPlaceController);
userRouter.get('/fetch-orders',auth,getAllOrdersController)

export default userRouter