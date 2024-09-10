import { Router } from "express";
import { addProductController ,getAllProductsController, deleteProductController, fetchAllOrdersController, changeOrderStatusController } from "../controller/admincontroller";
import admin from "../middleware/admin"

const adminRouter=Router()
adminRouter.post('/add-product',admin,addProductController)
adminRouter.get("/getAll-product",getAllProductsController)
adminRouter.post("/delete-product",admin,deleteProductController)
adminRouter.get('/fetchAllOrders',admin,fetchAllOrdersController)
adminRouter.post('/change-order-status',admin,changeOrderStatusController)
export default adminRouter