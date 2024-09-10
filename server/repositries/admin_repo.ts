
import { isElementAccessExpression } from "typescript";
import { IProductInterface } from "../database/interface/product_interface";
import ProductModel from "../database/models/product_model";
import admin from "../middleware/admin";
import { OrderModel } from "../database/models/order_model";

export const addProductRepo=async(
admin:any,
product:IProductInterface
):Promise<{p:IProductInterface|null}>=>{


    try {
        let newproduct= new ProductModel(
         {
            name:product.name,
            description:product.description,
            category:product.category,
            price:product.price,
            quantity:product.quantity,
            images:product.images
         }
        );
        newproduct=  await newproduct.save();
        return {p:newproduct}
    } catch (error) {
        console.log(error)
        return {p:null};
        
    }
}

export const getAllProductsRepo=async():Promise<any[]|null>=>{
    try {
        const allProducts= await ProductModel.find()
        if(allProducts){
return allProducts
        }
        else{
            return null
        }
    } catch (error) {
        console.log("NO PRODUCTS")
        return null;
    }
}

export const deleteProductRepo=async(id:String):Promise<boolean>=>{
    try {
        const delProduct =await ProductModel.findByIdAndDelete(id);
        if(delProduct){
            return true;
        }
        else{
            return false
        }
    } catch (error) {
        console.log(error)
        return false;
        
    }
}
export const fetchAllOrdersRepo =async()=>{
    try {
        const orders=await OrderModel.find();
        return orders;
    } catch (error) {
        console.log(error)
        throw error
        
    }

}
export const changeOrderStatusRepo=async(status:number,orderId:String)=>{
    try {
        const order=await OrderModel.findById(orderId);
    if(order){
        order.status=status;
        await order.save();
    }
    return  true

    } catch (error) {
        console.log(error);
        throw error
        
    }
}