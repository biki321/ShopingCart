const express = require("express");
const authRoute = require("./routes/authRoute");
const productsRoute = require("./routes/productRoute");
const cartRoute = require("./routes/cartRoute");
const mongoose = require("mongoose");
const dotenv = require("dotenv");
const bodyParser = require("body-parser");
const keys = require("./config/keys");
const port = process.env.PORT || 8000;

const app = express();
dotenv.config();

mongoose.connect(keys.MongoUrl, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

var db = mongoose.connection;
db.on("error", console.error.bind(console, "connection error:"));
db.once("open", function () {
  console.log("connected");
});

//middlewares
app.use(bodyParser.json());

//this route is for authentication related activities
app.use("/api/users", authRoute);
// app.use('/test', (req,res)=>{
//     console.log(req.body);
//     res.status(200);
// });

//this route is for product related requests
app.use("/api/products", productsRoute);

//this route is for updating the cart
app.use("/api/cart", cartRoute);

app.listen(port);
