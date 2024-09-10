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
exports.changeOrderStatusController = exports.fetchAllOrdersController = exports.deleteProductController = exports.getAllProductsController = exports.addProductController = void 0;
const admin_1 = __importDefault(require("../middleware/admin"));
const admin_repo_1 = require("../repositries/admin_repo");
const addProductController = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const product = req.body;
    try {
        const addProduct = yield (0, admin_repo_1.addProductRepo)(admin_1.default, product);
        if (addProduct) {
            res.json(addProduct);
        }
        else {
            res.status(400).json({ error: "Product Not Added" });
        }
    }
    catch (error) {
        res.status(400).json({ error: "Product Not Added" });
    }
});
exports.addProductController = addProductController;
const getAllProductsController = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const allProducts = yield (0, admin_repo_1.getAllProductsRepo)();
        if (allProducts) {
            res.status(200).json({ allProducts });
        }
        else {
            res.status(400).json({ error: "NO Product" });
        }
    }
    catch (error) {
        res.status(400).json({ error });
    }
});
exports.getAllProductsController = getAllProductsController;
const deleteProductController = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { id } = req.body;
    try {
        const delProduct = yield (0, admin_repo_1.deleteProductRepo)(id);
        if (delProduct) {
            res.status(200).json({ data: "Product Deleted" });
        }
        else {
            res.status(400).json({ error: "Error" });
        }
    }
    catch (error) {
        res.status(400).json(error);
    }
});
exports.deleteProductController = deleteProductController;
const fetchAllOrdersController = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const allOrders = yield (0, admin_repo_1.fetchAllOrdersRepo)();
        if (allOrders) {
            res.status(200).json(allOrders);
        }
        else {
            res.status(404).json("NO ORDERS");
        }
    }
    catch (error) {
        res.status(400).json(error);
    }
});
exports.fetchAllOrdersController = fetchAllOrdersController;
const changeOrderStatusController = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { status, id } = req.body;
    try {
        const order = yield (0, admin_repo_1.changeOrderStatusRepo)(status, id);
        if (order) {
            res.status(200).json('UPDATED');
        }
        else {
            res.status(404).json("NO ORDERS");
        }
    }
    catch (error) {
        res.status(400).json(error);
    }
});
exports.changeOrderStatusController = changeOrderStatusController;
