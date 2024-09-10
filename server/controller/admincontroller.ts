import { Request,Response } from "express";
import { IProductInterface } from "../database/interface/product_interface";
import admin from "../middleware/admin"
import { addProductRepo,changeOrderStatusRepo,deleteProductRepo,fetchAllOrdersRepo,getAllProductsRepo } from "../repositries/admin_repo";
import { error } from "console";



export const addProductController=async(req:Request,res:Response)=>{
const product:IProductInterface=req.body;

try {
    const addProduct= await addProductRepo(admin,product);
    if(addProduct){
        res.json(addProduct);
    }
    else{
        res.status(400).json({error:"Product Not Added"})

    }
} catch (error) {
    res.status(400).json({error:"Product Not Added"})
}

}

export const getAllProductsController=async(req:Request,res:Response)=>{
    try {
        const allProducts=await getAllProductsRepo();
        if(allProducts){
            res.status(200).json({allProducts})


        }
        else{
            res.status(400).json({error:"NO Product"})
        }
    } catch (error) {
        res.status(400).json({error})
    }

}
export const deleteProductController=async(req:Request,res:Response)=>{
    const {id}=req.body
    try {
        const delProduct=await deleteProductRepo(id);
        if(delProduct){
            res.status(200).json({data:"Product Deleted"});
        }
        else{
            res.status(400).json({error:"Error"})
        }
    } catch (error) {
        res.status(400).json(error);
        
    }
}
export const fetchAllOrdersController=async(req:Request,res:Response)=>{
    try {
        const allOrders=await fetchAllOrdersRepo();
        if(allOrders){
            res.status(200).json(allOrders);
        }
        else{
            res.status(404).json("NO ORDERS");

        }
    } catch (error) {
        res.status(400).json(error)
    }
}
export const changeOrderStatusController=async(req:Request,res:Response)=>{
    const {status,id}=req.body
    try {
        const order=await changeOrderStatusRepo(status,id);
        if(order){
            res.status(200).json('UPDATED');
        }
        else{
            res.status(404).json("NO ORDERS");

        }
        
        
    } catch (error) {
        res.status(400).json(error);
    }
}