"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const http_1 = __importDefault(require("http"));
const routes_1 = __importDefault(require("./routes/routes"));
const body_parser_1 = __importDefault(require("body-parser"));
const cors_1 = __importDefault(require("cors"));
const dotenv_1 = __importDefault(require("dotenv"));
const mongoose_1 = __importDefault(require("mongoose"));
dotenv_1.default.config();
const app = (0, express_1.default)();
const server = http_1.default.createServer(app);
//console.log(`MONGO_DB_URI: ${process.env.MONGO_DB_URI}`);
app.use((0, cors_1.default)());
app.use(body_parser_1.default.json());
app.use(body_parser_1.default.urlencoded({ extended: true }));
app.set('PORT', 3000);
app.set('BASE_URL', 'localhost');
//middleware
app.use("/amazon/v1/", routes_1.default);
const mongoUri = process.env.MONGO_DB_URI;
if (!mongoUri) {
    console.error("MONGODB URL NOT DEFINED");
    process.exit(1);
}
mongoose_1.default.connect(mongoUri, {})
    .then(() => {
    console.log("MongoDB connection successful");
})
    .catch((error) => {
    console.error("Error connecting to MongoDB:", error);
});
try {
    const port = app.get("PORT");
    const base_Url = app.get("BASE_URL");
    server.listen(port, () => {
        console.log("Server is Listeninggg");
    });
}
catch (error) {
    console.log(error);
}
