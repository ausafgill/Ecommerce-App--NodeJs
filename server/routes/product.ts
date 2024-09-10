import { Router } from "express";
import auth from "../middleware/auth"
import { getCategoryProductsController, getDealofDayController, getSearchProductController, postProductRatingController } from "../controller/productcontroller";
export const productRouter=Router();
productRouter.get('/get-category-product',auth,getCategoryProductsController);
productRouter.get('/get-search-product/:name',auth,getSearchProductController);
productRouter.post('/rate-product',auth,postProductRatingController);
productRouter.get('/get-dealofday',auth,getDealofDayController)