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
exports.getDealofDayRepo = exports.postProductRatingRepo = exports.getSearchProductRepo = exports.getCategoryProductsRepo = void 0;
const product_model_1 = __importDefault(require("../database/models/product_model"));
const getCategoryProductsRepo = (category) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const product = yield product_model_1.default.find({ category: category });
        if (product) {
            return product;
        }
        else {
            return null;
        }
    }
    catch (error) {
        console.log(error);
        return null;
    }
});
exports.getCategoryProductsRepo = getCategoryProductsRepo;
const getSearchProductRepo = (name) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const product = yield product_model_1.default.find({
            name: { $regex: name, $options: "i" },
        });
        if (product) {
            return product;
        }
        else {
            return null;
        }
    }
    catch (error) {
        console.log(error);
        return null;
    }
});
exports.getSearchProductRepo = getSearchProductRepo;
const postProductRatingRepo = (id, rating, userId) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const producttoRate = yield product_model_1.default.findById(id);
        if (producttoRate) {
            for (let i = 0; i < producttoRate.ratings.length; i++) {
                if (userId == producttoRate.ratings[i].userId) {
                    producttoRate.ratings.splice(i, 1);
                    break;
                }
            }
        }
        producttoRate === null || producttoRate === void 0 ? void 0 : producttoRate.ratings.push({ userId, rating });
        // Save the updated product
        yield (producttoRate === null || producttoRate === void 0 ? void 0 : producttoRate.save());
        return { product: producttoRate };
    }
    catch (error) {
        console.log(error);
        return { product: null };
    }
});
exports.postProductRatingRepo = postProductRatingRepo;
const getDealofDayRepo = () => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const allProduct = yield product_model_1.default.find({});
        const bestProd = allProduct.sort((a, b) => {
            let aSum = 0;
            let bSum = 0;
            for (let i = 0; i < a.ratings.length; i++) {
                aSum += a.ratings[i].rating;
            }
            for (let i = 0; i < b.ratings.length; i++) {
                bSum += b.ratings[i].rating;
            }
            return aSum < bSum ? 1 : -1;
        });
        return { p: bestProd[0] };
    }
    catch (error) {
        console.log(error);
        return { p: null };
    }
});
exports.getDealofDayRepo = getDealofDayRepo;
