"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const auth_1 = __importDefault(require("../middleware/auth"));
const usercontroller_1 = require("../controller/usercontroller");
const userRouter = (0, express_1.Router)();
userRouter.post('/add-to-cart', auth_1.default, usercontroller_1.addToCartController);
userRouter.delete('/remove-from-cart/:id', auth_1.default, usercontroller_1.removeFromCartController);
userRouter.get('/fetchUser', auth_1.default, usercontroller_1.fetchUserData);
userRouter.post('/save-address', usercontroller_1.saveUserAddressController);
userRouter.post('/place-order', auth_1.default, usercontroller_1.orderPlaceController);
userRouter.get('/fetch-orders', auth_1.default, usercontroller_1.getAllOrdersController);
exports.default = userRouter;
