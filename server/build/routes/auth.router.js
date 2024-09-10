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
const express_1 = require("express");
const authcontroller_1 = require("../controller/authcontroller");
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const user_model_1 = __importDefault(require("../database/models/user_model"));
const auth_1 = __importDefault(require("../middleware/auth"));
const authRouter = (0, express_1.Router)();
authRouter.post('/', authcontroller_1.signupUserController);
authRouter.post('/signin', authcontroller_1.signinUserController);
authRouter.post('/tokenIsValid', (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const token = req.header('token');
        if (!token)
            return res.json(false);
        const verified = jsonwebtoken_1.default.verify(token, "passwordKey");
        if (!verified)
            return res.json(false);
        // const user=await UserModel.findById(verified.id);
        const user = yield user_model_1.default.findById(verified.id);
        if (!user)
            return res.json(false);
        res.json(true);
    }
    catch (error) {
    }
}));
// get user data
authRouter.get("/", auth_1.default, (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const user = yield user_model_1.default.findById(req.user);
    res.json(Object.assign(Object.assign({}, user === null || user === void 0 ? void 0 : user.toObject()), { token: req.token }));
}));
exports.default = authRouter;
