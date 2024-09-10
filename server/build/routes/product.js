"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.productRouter = void 0;
const express_1 = require("express");
const auth_1 = __importDefault(require("../middleware/auth"));
const productcontroller_1 = require("../controller/productcontroller");
exports.productRouter = (0, express_1.Router)();
exports.productRouter.get('/get-category-product', auth_1.default, productcontroller_1.getCategoryProductsController);
exports.productRouter.get('/get-search-product/:name', auth_1.default, productcontroller_1.getSearchProductController);
exports.productRouter.post('/rate-product', auth_1.default, productcontroller_1.postProductRatingController);
exports.productRouter.get('/get-dealofday', auth_1.default, productcontroller_1.getDealofDayController);
