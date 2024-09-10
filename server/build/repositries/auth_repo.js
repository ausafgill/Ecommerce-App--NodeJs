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
exports.signinUserRepo = exports.signupUserRepo = void 0;
const user_model_1 = __importDefault(require("../database/models/user_model"));
const bcryptjs_1 = __importDefault(require("bcryptjs"));
const signupUserRepo = (user) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        if (!user.password) {
            throw new Error("Password is required");
        }
        const existingUser = yield user_model_1.default.findOne({ email: user.email });
        if (existingUser) {
            console.log(`User with email ${user.email} already exists.`);
            return false;
        }
        const hashedPass = yield bcryptjs_1.default.hash(user.password, 8);
        const newUser = new user_model_1.default({
            name: user.name,
            email: user.email,
            password: hashedPass,
        });
        yield newUser.save();
        return true;
    }
    catch (error) {
        console.error("Error during user signup:", error);
        return false;
    }
});
exports.signupUserRepo = signupUserRepo;
const signinUserRepo = (password, email) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const user = yield user_model_1.default.findOne({ email: email });
        if (!user) {
            console.log("USER NOT FOUND");
            return { user: null, isMatch: false };
        }
        const isMatch = yield bcryptjs_1.default.compare(password, user.password);
        return { user, isMatch };
    }
    catch (error) {
        console.log(error);
        return { user: null, isMatch: false };
    }
});
exports.signinUserRepo = signinUserRepo;
