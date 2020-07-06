const mongoose = require("mongoose");

let collectionName = "carts";

const cart_schema = new mongoose.Schema(
  {
    user_id: { type: mongoose.Schema.Types.ObjectId, require: true },

    total_price: { type: Number, default: 0 },

    products: [
      {
        product_id: { type: mongoose.Schema.Types.ObjectId, require: true },
        nested_id: { type: mongoose.Schema.Types.ObjectId, require: true },
        brand: { type: String, require: true, require: true },
        product_name: { type: String },
        product_image_url: { type: String, require: true, require: true },
        size: { type: Number, require: true },
        color_name: { type: String, require: true },
        price: { type: Number, require: true },
        purchasedPrice: { type: Number, required: false },
        quantity: { type: Number, require: true },
        modified_on: { type: Date, require: true },
        isPurchased: {type:Boolean, require: true, default: false},
      },
    ],
  },
  { collection: collectionName }
);

module.exports = mongoose.model("carts", cart_schema, collectionName);
