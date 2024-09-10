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
Object.defineProperty(exports, "__esModule", { value: true });
exports.getAllOrdersController = exports.orderPlaceController = exports.saveUserAddressController = exports.removeFromCartController = exports.fetchUserData = exports.addToCartController = void 0;
const userrepo_1 = require("../repositries/userrepo");
const addToCartController = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { id } = req.body;
        const userId = req.user;
        const cart = yield (0, userrepo_1.addToCartRepo)(id, userId);
        if (userId) {
            res.status(200).json(cart);
        }
        else {
            res.status(400).json("NOT FOUND");
        }
    }
    catch (error) {
        res.status(400).json(error);
    }
});
exports.addToCartController = addToCartController;
const fetchUserData = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const userId = req.user;
        const userFetch = yield (0, userrepo_1.fetchUserDataRepo)(userId);
        if (userFetch) {
            res.status(200).json(userFetch);
        }
        else {
            res.status(404).json("Not Found");
        }
    }
    catch (error) {
        res.status(400).json(error);
    }
});
exports.fetchUserData = fetchUserData;
const removeFromCartController = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { id } = req.params;
        const userId = req.user;
        const cart = yield (0, userrepo_1.removeFromCartRepo)(id, userId);
        if (userId) {
            res.status(200).json(cart);
        }
        else {
            res.status(400).json("NOT FOUND");
        }
    }
    catch (error) {
        res.status(400).json(error);
    }
});
exports.removeFromCartController = removeFromCartController;
const saveUserAddressController = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const userId = req.user;
    const { address } = req.body;
    try {
        const user = yield (0, userrepo_1.saveUserAddressRepo)(address, userId);
        if (user) {
            res.status(200).json(user);
        }
        else {
            res.status(404).json("NOT FOUND");
        }
    }
    catch (error) {
        res.status(400).json(error);
    }
});
exports.saveUserAddressController = saveUserAddressController;
const orderPlaceController = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const userId = req.user;
    const { address, totalPrice, cart } = req.body;
    try {
        const order = yield (0, userrepo_1.placeOrderRepo)(address, totalPrice, cart, userId);
        if (order) {
            res.status(200).json(order);
        }
        else {
            res.status(404).json("NOT FOUND");
        }
    }
    catch (error) {
        res.status(400).json(error);
    }
});
exports.orderPlaceController = orderPlaceController;
const getAllOrdersController = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const userId = req.user;
    //const{userId}=req.body;
    try {
        const userOrder = yield (0, userrepo_1.getAllOrdersRepo)(userId);
        if (userOrder) {
            res.status(200).json(userOrder);
        }
        else {
            res.status(404).json("NO ORDER FOUND");
        }
    }
    catch (error) {
        res.status(400).json(error);
    }
});
exports.getAllOrdersController = getAllOrdersController;
