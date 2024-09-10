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
exports.signinUserController = exports.signupUserController = void 0;
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const auth_repo_1 = require("../repositries/auth_repo");
const signupUserController = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const user = req.body;
    try {
        const userCreate = yield (0, auth_repo_1.signupUserRepo)(user);
        if (userCreate) {
            res.status(200).json({ data: user });
        }
        else {
            res.status(400).json({ error: "User Already Exists" });
        }
    }
    catch (error) {
        res.status(500).json({ error: error });
    }
});
exports.signupUserController = signupUserController;
const signinUserController = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { email, password } = req.body;
    try {
        const { user, isMatch } = yield (0, auth_repo_1.signinUserRepo)(password, email);
        if (!user) {
            return res.status(400).json({ error: "User with email not found" });
        }
        if (!isMatch) {
            return res.status(400).json({ error: "Incorrect Password" });
        }
        if (user) {
            const token = jsonwebtoken_1.default.sign({ id: user._id }, "passwordKey");
            res.json(Object.assign({ token }, user.toObject()));
        }
    }
    catch (error) {
        res.status(500).json({ error: error });
    }
});
exports.signinUserController = signinUserController;
