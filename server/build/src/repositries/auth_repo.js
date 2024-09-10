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
exports.signupUserRepo = void 0;
const user_model_1 = __importDefault(require("../../database/models/user_model"));
const signupUserRepo = (user) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const existingUser = yield user_model_1.default.findOne({ email: user.email });
        if (existingUser) {
            return false;
        }
        else {
            const userCreate = yield user_model_1.default.create(user);
            return true;
        }
    }
    catch (error) {
        console.log(error);
        return false;
    }
});
exports.signupUserRepo = signupUserRepo;
