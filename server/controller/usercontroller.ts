import { Request,Response } from "express"
import { addToCartRepo, fetchUserDataRepo, getAllOrdersRepo, placeOrderRepo, removeFromCartRepo, saveUserAddressRepo } from "../repositries/userrepo"


export const addToCartController=async(req:Request,res:Response)=>{
  try {
    const {id} =req.body
    const userId = req.user as string; 
    const cart=await addToCartRepo(id,userId);

    if (userId) {
        res.status(200).json(cart)
        
    }
    else{
        res.status(400).json("NOT FOUND")
    }
  } catch (error) {
    res.status(400).json(error)
    
  }

}
export const fetchUserData=async(req:Request,res:Response)=>{
  try {
    const userId = req.user as string; 
    const userFetch=await fetchUserDataRepo(userId);
    if(userFetch){
      res.status(200).json(userFetch)
    }
    else{
      res.status(404).json("Not Found")
    }
    
  } catch (error) {
    res.status(400).json(error);
    
  }
}

export const removeFromCartController=async(req:Request,res:Response)=>{
  try {
    const {id} =req.params
    const userId = req.user as string; 
    const cart=await removeFromCartRepo(id,userId);

    if (userId) {
        res.status(200).json(cart)
        
    }
    else{
        res.status(400).json("NOT FOUND")
    }
  } catch (error) {
    res.status(400).json(error)
    
  }


}


export const saveUserAddressController=async(req:Request,res:Response)=>{
  const userId = req.user as string; 
  const{address}= req.body
  try {
    const user=await saveUserAddressRepo(address,userId);
    if(user){
      res.status(200).json(user);
    }
    else{
      res.status(404).json("NOT FOUND")
  }

    
  } catch (error) {
   
      res.status(400).json(error)

  }
}

export const orderPlaceController=async(req:Request,res:Response)=>{
  const userId = req.user as string; 
  const{address,totalPrice,cart}= req.body
  try {
    const order=await placeOrderRepo(address,totalPrice,cart,userId);
    if(order){
      res.status(200).json(order);
    }
    else{
      res.status(404).json("NOT FOUND")
  }
  } catch (error) {

     res.status(400).json(error)
  }
}

export const getAllOrdersController=async(req:Request,res:Response)=>{
  const userId = req.user as string; 
  //const{userId}=req.body;
  try {
    const userOrder=await getAllOrdersRepo(userId);
    if(userOrder){
      res.status(200).json(userOrder)
    }
    else{
      res.status(404).json("NO ORDER FOUND");
    }
  } catch (error) {
    res.status(400).json(error)
    
  }
}