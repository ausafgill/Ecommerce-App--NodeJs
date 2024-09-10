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
exports.getDealofDayController = exports.postProductRatingController = exports.getSearchProductController = exports.getCategoryProductsController = void 0;
const productrepo_1 = require("../repositries/productrepo");
const getCategoryProductsController = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const category = req.query.category;
    if (typeof category === 'string') {
        try {
            const products = yield (0, productrepo_1.getCategoryProductsRepo)(category);
            if (products) {
                res.status(200).json(products);
            }
            else {
                res.status(404).json({ error: "Products not found for the specified category" });
            }
        }
        catch (error) {
            console.error('Error fetching category products:', error);
            res.status(500).json({ error: 'An unexpected error occurred' });
        }
    }
    else {
        res.status(400).json({ error: "Invalid or missing category parameter" });
    }
});
exports.getCategoryProductsController = getCategoryProductsController;
const getSearchProductController = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const searchProduct = yield (0, productrepo_1.getSearchProductRepo)(req.params.name);
        if (searchProduct) {
            res.status(200).json(searchProduct);
        }
        else {
            res.status(400).json({ error: "No Such Product" });
        }
    }
    catch (error) {
        res.status(400).json(error);
    }
});
exports.getSearchProductController = getSearchProductController;
const postProductRatingController = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { id, rating } = req.body;
    const userId = req.user;
    try {
        const addRating = yield (0, productrepo_1.postProductRatingRepo)(id, rating, userId);
        if (addRating) {
            res.status(200).json(addRating);
        }
        else {
            res.status(404).json({ error: "Product Not Found" });
        }
    }
    catch (error) {
        res.status(400).json(error);
    }
});
exports.postProductRatingController = postProductRatingController;
const getDealofDayController = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const bestProd = yield (0, productrepo_1.getDealofDayRepo)();
        if (bestProd) {
            res.status(200).json({ data: bestProd });
        }
        else {
            res.status(404).json({ error: "NOT FOUND" });
        }
    }
    catch (error) {
        res.status(400).json(error);
    }
});
exports.getDealofDayController = getDealofDayController;
