import { IProductInterface } from "../database/interface/product_interface";
import ProductModel from "../database/models/product_model";

export const getCategoryProductsRepo = async (
  category: string
): Promise<any[] | null> => {
  try {
    const product = await ProductModel.find({ category: category });
    if (product) {
      return product;
    } else {
      return null;
    }
  } catch (error) {
    console.log(error);
    return null;
  }
};

export const getSearchProductRepo = async (
  name: string
): Promise<any[] | null> => {
  try {
    const product = await ProductModel.find({
      name: { $regex: name, $options: "i" },
    });
    if (product) {
      return product;
    } else {
      return null;
    }
  } catch (error) {
    console.log(error);
    return null;
  }
};
export const postProductRatingRepo = async (
  id: String,
  rating: number,
  userId:string
): Promise<{ product: IProductInterface | null }> => {
  try {
    const producttoRate = await ProductModel.findById(id);
    if (producttoRate) {
      for (let i = 0; i < producttoRate.ratings.length; i++) {
        if (userId == producttoRate.ratings[i].userId) {
          producttoRate.ratings.splice(i, 1);
          break;
        }
      }
    }

    producttoRate?.ratings.push({ userId, rating  });

      // Save the updated product
      await producttoRate?.save();

      return { product: producttoRate };

   
  } catch (error) {
    console.log(error);
    return { product: null };
  }
};

export const getDealofDayRepo=async():Promise<{p:IProductInterface|null}>=>{
  try {
    const allProduct=await ProductModel.find({});
  const bestProd=  allProduct.sort((a,b)=>{
    let  aSum=0;
     let bSum=0;
      for(let i=0;i<a.ratings.length;i++){
        aSum+=a.ratings[i].rating;
      }
      for(let i=0;i<b.ratings.length;i++){
        bSum+=b.ratings[i].rating;
      }

      return aSum<bSum ?1:-1;

    })
   return {p:bestProd[0]}
  } catch (error) {
    console.log(error);
    return{p:null};
    
  }
}