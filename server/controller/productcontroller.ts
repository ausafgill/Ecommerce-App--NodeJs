import { Request,Response } from "express"
import { getCategoryProductsRepo, getDealofDayRepo, getSearchProductRepo, postProductRatingRepo } from "../repositries/productrepo";
import { error } from "console";



export const getCategoryProductsController = async (req: Request, res: Response) => {
    const category = req.query.category;

  
    if (typeof category === 'string') {
        try {
            const products = await getCategoryProductsRepo(category);

            if (products) {
                res.status(200).json(products);
            } else {
                res.status(404).json({ error: "Products not found for the specified category" });
            }
        } catch (error) {
            console.error('Error fetching category products:', error);
            res.status(500).json({ error: 'An unexpected error occurred' });
        }
    } else {
        res.status(400).json({ error: "Invalid or missing category parameter" });
    }



}

export const getSearchProductController= async(req:Request,res:Response)=>{
    try {
        const searchProduct=await getSearchProductRepo(req.params.name);
        if(searchProduct){
            res.status(200).json(searchProduct)
        }
        else{
            res.status(400).json({error:"No Such Product"})
        }
    } catch (error) {
        res.status(400).json(error)
        
    }
}
export const postProductRatingController=async(req:Request,res:Response)=>{

    const{id,rating}=req.body
    const userId = req.user as string; 
try {

    const addRating=await postProductRatingRepo(id,rating,userId);
    if(addRating){
        res.status(200).json(addRating)
    }
    else{
        res.status(404).json({error:"Product Not Found"})
    }
} catch (error) {
    res.status(400).json(error)
    
}
}
export const getDealofDayController=async(req:Request,res:Response)=>{
    try {
        const bestProd=await getDealofDayRepo();
        if(bestProd){
            res.status(200).json({data:bestProd});
        }
        else{
            res.status(404).json({error:"NOT FOUND"})
        }
    } catch (error) {
        res.status(400).json(error)
    }
}