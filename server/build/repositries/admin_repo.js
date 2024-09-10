"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.changeOrderStatusRepo = exports.fetchAllOrdersRepo = exports.deleteProductRepo = exports.getAllProductsRepo = exports.addProductRepo = void 0;
const product_model_1 = __importDefault(require("../database/models/product_model"));
const order_model_1 = require("../database/models/order_model");
const addProductRepo = (admin, product) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        let newproduct = new product_model_1.default({
            name: product.name,
            description: product.description,
            category: product.category,
            price: product.price,
            quantity: product.quantity,
            images: product.images
        });
        newproduct = yield newproduct.save();
        return { p: newproduct };
    }
    catch (error) {
        console.log(error);
        return { p: null };
    }
});
exports.addProductRepo = addProductRepo;
const getAllProductsRepo = () => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const allProducts = yield product_model_1.default.find();
        if (allProducts) {
            return allProducts;
        }
        else {
            return null;
        }
    }
    catch (error) {
        console.log("NO PRODUCTS");
        return null;
    }
});
exports.getAllProductsRepo = getAllProductsRepo;
const deleteProductRepo = (id) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const delProduct = yield product_model_1.default.findByIdAndDelete(id);
        if (delProduct) {
            return true;
        }
        else {
            return false;
        }
    }
    catch (error) {
        console.log(error);
        return false;
    }
});
exports.deleteProductRepo = deleteProductRepo;
const fetchAllOrdersRepo = () => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const orders = yield order_model_1.OrderModel.find();
        return orders;
    }
    catch (error) {
        console.log(error);
        throw error;
    }
});
exports.fetchAllOrdersRepo = fetchAllOrdersRepo;
const changeOrderStatusRepo = (status, orderId) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const order = yield order_model_1.OrderModel.findById(orderId);
        if (order) {
            order.status = status;
            yield order.save();
        }
        return true;
    }
    catch (error) {
        console.log(error);
        throw error;
    }
});
exports.changeOrderStatusRepo = changeOrderStatusRepo;
