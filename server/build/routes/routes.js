"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const auth_router_1 = __importDefault(require("./auth.router"));
const hello_router_1 = __importDefault(require("./hello.router"));
const adminrouter_1 = __importDefault(require("./adminrouter"));
const product_1 = require("./product");
const user_router_1 = __importDefault(require("./user.router"));
const router = (0, express_1.Router)();
router.use('/user/signup', auth_router_1.default);
router.use('/user', auth_router_1.default);
router.use('/hello', hello_router_1.default);
router.use('/admin', adminrouter_1.default);
router.use('/product', product_1.productRouter);
router.use('/cart', user_router_1.default);
exports.default = router;
