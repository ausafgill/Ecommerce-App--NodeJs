"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const admincontroller_1 = require("../controller/admincontroller");
const admin_1 = __importDefault(require("../middleware/admin"));
const adminRouter = (0, express_1.Router)();
adminRouter.post('/add-product', admin_1.default, admincontroller_1.addProductController);
adminRouter.get("/getAll-product", admincontroller_1.getAllProductsController);
adminRouter.post("/delete-product", admin_1.default, admincontroller_1.deleteProductController);
adminRouter.get('/fetchAllOrders', admin_1.default, admincontroller_1.fetchAllOrdersController);
adminRouter.post('/change-order-status', admin_1.default, admincontroller_1.changeOrderStatusController);
exports.default = adminRouter;
