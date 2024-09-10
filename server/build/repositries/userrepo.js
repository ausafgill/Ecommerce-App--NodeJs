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
exports.getAllOrdersRepo = exports.placeOrderRepo = exports.saveUserAddressRepo = exports.fetchUserDataRepo = exports.removeFromCartRepo = exports.addToCartRepo = void 0;
const order_model_1 = require("../database/models/order_model");
const product_model_1 = __importDefault(require("../database/models/product_model"));
const user_model_1 = __importDefault(require("../database/models/user_model"));
const addToCartRepo = (productId, userId) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const product = yield product_model_1.default.findById(productId);
        if (!product) {
            throw new Error("Product not found");
        }
        let user = yield user_model_1.default.findById(userId);
        if (!user) {
            throw new Error("User not found");
        }
        user.cart = user.cart || [];
        const existingCartItem = user === null || user === void 0 ? void 0 : user.cart.find((item) => item.product.id.toString() === product.id.toString());
        if (existingCartItem) {
            existingCartItem.quantity += 1;
        }
        else {
            user.cart.push({ product, quantity: 1 });
        }
        yield user.save();
        return user;
    }
    catch (error) {
        console.log(error);
        throw error;
    }
});
exports.addToCartRepo = addToCartRepo;
const removeFromCartRepo = (productId, userId) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const product = yield product_model_1.default.findById(productId);
        if (!product) {
            throw new Error("Product not found");
        }
        let user = yield user_model_1.default.findById(userId);
        if (!user) {
            throw new Error("User not found");
        }
        for (let i = 0; i < user.cart.length; i++) {
            if (user.cart[i].product.id.toString() === product.id.toString()) {
                if (user.cart[i].quantity == 1) {
                    user.cart.splice(i, 1);
                }
                user.cart[i].quantity -= 1;
            }
        }
        yield user.save();
        return user;
    }
    catch (error) {
        console.log(error);
        throw error;
    }
});
exports.removeFromCartRepo = removeFromCartRepo;
const fetchUserDataRepo = (userId) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const user = yield user_model_1.default.findById(userId);
        if (user) {
            return user;
        }
        else {
            return null;
        }
    }
    catch (error) {
        console.log(error);
        throw error;
    }
});
exports.fetchUserDataRepo = fetchUserDataRepo;
const saveUserAddressRepo = (address, userId) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const user = yield user_model_1.default.findById(userId);
        if (user) {
            user.updateOne({ address: address });
            user.save();
        }
        return user;
    }
    catch (error) {
        throw error;
    }
});
exports.saveUserAddressRepo = saveUserAddressRepo;
const placeOrderRepo = (address, totalPrice, cart, userId) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        let products = [];
        for (let i = 0; i < cart.length; i++) {
            let product = yield product_model_1.default.findById(cart[i].product._id);
            if (!product) {
                throw new Error("Product not found");
            }
            if ((product === null || product === void 0 ? void 0 : product.quantity) >= cart[i].quantity) {
                products.push({ product, quantity: cart[i].quantity });
                yield product.save();
            }
            else {
                throw new Error("Stock Unavailable");
            }
        }
        let user = yield user_model_1.default.findById(userId);
        if (!user) {
            throw new Error("Product not found");
        }
        user.cart = [];
        user = yield user.save();
        let order = new order_model_1.OrderModel({
            products,
            totalPrice,
            address,
            userId,
            orderAt: new Date().getTime(),
        });
        order = yield order.save();
        return order;
    }
    catch (error) {
        console.log(error);
        throw error;
    }
});
exports.placeOrderRepo = placeOrderRepo;
const getAllOrdersRepo = (userId) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const userOrder = yield order_model_1.OrderModel.find({ userId: userId });
        if (userOrder) {
            return userOrder;
        }
        else {
            return 'NO ORDER';
        }
    }
    catch (error) {
        console.log(error);
        throw error;
    }
});
exports.getAllOrdersRepo = getAllOrdersRepo;
