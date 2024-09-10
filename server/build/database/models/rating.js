"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ratingSchema = void 0;
const mongoose_1 = require("mongoose");
exports.ratingSchema = new mongoose_1.Schema({
    userId: {
        type: String,
        required: true
    },
    rating: {
        type: Number,
        required: true
    }
});
