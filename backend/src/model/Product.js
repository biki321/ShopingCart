const mongoose = require("mongoose");

let collectionName = "products";

//this schema represent each one particular named shoes from each brand
//for example Revolution 5 from Nike
const product_schema = new mongoose.Schema(
  {
    product_name: {
      type: String,
      require: false,
    },
    product_brand: {
      type: String,
      require: true,
    },
    // it is assumed that the price will be same for each every size
    product_price: {
      type: Number,
      require: true,
    },
    product_des: {
      type: String,
      require: false,
    },
    //here different_colored_product(sneakers) is an array where each element is nested document
    //names_of_colors is the color for a sneaker(multiple colors can be in one sneaker)
    //eg. red,blue,black
    //size_and_quantity field shows the quantity of sneakers for each size
    //so colors[2].size_and_quantity.7 gives the number of sneakers of color names_of_colors with size 7
    different_colored_product: [
      {
        names_of_colors: { type: String, required: true },
        url_for_image: { type: String, required: true },
        size_and_quantity: {
          "5": { type: Number, default: 0 },
          "6": { type: Number, default: 0 },
          "7": { type: Number, default: 0 },
          "8": { type: Number, default: 0 },
          "9": { type: Number, default: 0 },
          "10": { type: Number, default: 0 },
          "11": { type: Number, default: 0 },
          "12": { type: Number, default: 0 },
          "13": { type: Number, default: 0 },
        },
      },
    ],
  },
  { collection: collectionName }
);

module.exports = mongoose.model("products", product_schema, collectionName);
