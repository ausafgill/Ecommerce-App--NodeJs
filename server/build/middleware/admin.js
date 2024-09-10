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
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const user_model_1 = __importDefault(require("../database/models/user_model"));
const admin = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const token = req.header("token");
        if (!token) {
            return res.status(401).json({ msg: "No auth token,access denied" });
        }
        const verified = jsonwebtoken_1.default.verify(token, "passwordKey");
        if (!verified)
            return res
                .status(401)
                .json({ msg: "Token verification failed, authorization denied." });
        const user = yield user_model_1.default.findById(verified.id);
        if ((user === null || user === void 0 ? void 0 : user.type) == 'user' || (user === null || user === void 0 ? void 0 : user.type) == 'seller') {
            return res.status(401).json({ msg: "You are not an admin!" });
        }
        req.user = verified.id;
        req.token = token;
        next();
    }
    catch (error) {
        res.status(500).json({ error: error });
    }
});
exports.default = admin;
