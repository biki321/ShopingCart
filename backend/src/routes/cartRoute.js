const router = require("express").Router();
const Cart = require("../model/Cart");
const Product = require("../model/Product");
const ObjectId = require("mongoose").Types.ObjectId;
const verifyUser = require("../GlobalMiddlwares/verifyUser");
const { uuid } = require("uuidv4");
const User = require("../model/User");
const dotenv = require("dotenv");
const Razorpay = require("razorpay");
const crypto = require("crypto");

dotenv.config();

const stripe = require("stripe")(process.env.STRIPE_SECRET_KEY);

//query for product
async function oneproduct(product_id, nested_id, size) {
  //this a object for project() in OneProduct's aggregate query
  let projection = {
    different_colored_product: { _id: 1 },
    product_name: 1,
    product_brand: 1,
    product_price: 1,
    ["different_colored_product." + "url_for_image"]: 1,
    //quantity
    ["different_colored_product." +
    "size_and_quantity." +
    [size.toString()]]: 1,
  };

  //queryning
  try {
    var OneProduct = await Product.aggregate()
      .match({
        _id: ObjectId(product_id),
        "different_colored_product._id": ObjectId(nested_id),
      })
      .unwind("different_colored_product")
      .match({ "different_colored_product._id": ObjectId(nested_id) })
      .project(projection);
  } catch (error) {
    throw error;
  }
  //console.log(OneProduct[0]);
  return OneProduct[0];
}

//this will check if the product already exist or not
//if exist just increase or decrease the quantity
async function checkIfProductAddedAlready(
  res,
  user_id,
  product_id,
  nested_id,
  size,
  quantity,
  priceToAddToTotalPrice
) {
  try {
    var doc = await Cart.findOne(
      { user_id: ObjectId(user_id) },
      { "products.product_id": 1, "products.nested_id": 1, "products.size": 1 }
    );

    let arrayOfItemInCart = doc.products;

    //this obj is containing few field of the item to add to cart
    let obj = {
      product_id: product_id,
      nested_id: nested_id,
      size: size,
    };

    var needed_index = 0;
    for (
      needed_index = 0;
      needed_index < arrayOfItemInCart.length;
      needed_index++
    ) {
      //compareTwoObj return true then both objs are equal
      //we are checking whether the item to add already in the cart or not
      //if compareTwoObj return true the it is otherwise no.
      if (compareTwoObj(obj, arrayOfItemInCart[needed_index])) {
        try {
          var updatedDoc = await Cart.updateOne(
            { user_id: ObjectId(user_id) },
            {
              $inc: {
                //total_price: priceToAddToTotalPrice,
                ["products." + needed_index + "." + "quantity"]: quantity,
              },
            }
          );
          //console.log(updatedDoc);
          return res.status(200).json({ msg: "Added To Cart" });
        } catch (err) {
          throw err;
        }
      }
    }
    return false;
  } catch (err) {
    throw err;
  }
}

function pushProductToCart(
  res,
  OneProduct,
  user_id,
  product_id,
  nested_id,
  size,
  quantity
) {
  Cart.findOneAndUpdate(
    { user_id: ObjectId(user_id) },
    {
      //$inc: { total_price: OneProduct.product_price },
      $push: {
        products: {
          product_id: ObjectId(product_id),
          nested_id: ObjectId(nested_id),
          brand: OneProduct.product_brand,
          product_name: OneProduct.product_name,
          product_image_url: OneProduct.different_colored_product.url_for_image,
          size: size,
          color_name: OneProduct.color_name,
          price: OneProduct.product_price,
          quantity: quantity,
          modified_on: Date.now(),
        },
      },
    },
    { useFindAndModify: false },
    (err, doc) => {
      //console.log('push item: ', doc);
      if (err) {
        throw err;
      } else {
        return res.status(200).json({ msg: "Added To Cart" });
      }
    }
  );
}

//this will give the quantity of an Product added in cart
async function quantityOfProductInCart(user_id, id_of_cart_item) {
  try {
    let doc = await Cart.findOne(
      {
        user_id: ObjectId(user_id),
        "products._id": ObjectId(id_of_cart_item),
      },
      {
        "products.$.quanity": 1,
      }
    );
    return doc.products[0].quantity;
  } catch (error) {
    throw error;
  }
}

//this will give price an item in product schema
async function priceOfAnItem(product_id) {
  try {
    let doc = await Product.findOne(
      { _id: ObjectId(product_id) },
      { product_price: 1 }
    );
    return doc.product_price;
  } catch (error) {
    throw error;
  }
}

function compareTwoObj(obj, objfromCart) {
  let keys = Object.keys(obj);
  for (let i = 0; i < keys.length; i++) {
    let key = keys[i];
    //return false if both obj are not equal
    if (obj[key].toString() !== objfromCart[key].toString()) return false;
  }
  return true;
}

//middleware to add product to cart
async function addItemToCart(req, res, next) {
  let user_id = res.locals.payload.user_id;
  let product_id = req.params.product_id;

  //this is the _id of object inside product.different_colored_product array
  let nested_id = req.params.nested_id;

  //this size & quantity is  of type Number in mongodb
  //required shoe size
  let size = req.params.size;

  if (size < 5 || size > 13)
    return res.status(404).json({ err: "size should be in between 5 to 13" });

  //required quantity of product
  //it can be +ve or -ve number according to whether to add or remove product from cart
  let quantity = req.params.quantity;

  let OneProduct = await oneproduct(product_id, nested_id, size);

  let quantityInStock =
    OneProduct.different_colored_product.size_and_quantity[size.toString()];

  let priceToAddToTotalPrice = quantity * OneProduct.product_price;

  if (quantity < 0) {
    return res.status(404).json({ err: "quantity can not be negative" });
  }

  if (quantityInStock == 0) {
    return res.status(404).json({ err: "OutOfStock" });
  }
  //check if quantity to add in cart is more than the original stock.
  else if (quantity > quantityInStock) {
    return res.status(404).json({ err: `Only $quantityInStock items left` });
  } else if (
    await checkIfProductAddedAlready(
      res,
      user_id,
      product_id,
      nested_id,
      size,
      quantity,
      priceToAddToTotalPrice
    )
  ) {
  } else {
    pushProductToCart(
      res,
      OneProduct,
      user_id,
      product_id,
      nested_id,
      size,
      quantity
    );
  }
}

//updating the cart
//this route can handle the following features
// 1. adding to cart(also adding same product again)
// 2. increasing quantity or decreasing quantity
router.post(
  [
    "/addToCart/",
    "product_id/:product_id/",
    "nested_id/:nested_id/",
    "size/:size/quantity/:quantity",
  ].join(""),
  verifyUser,
  addItemToCart
);

//this will add or remove item from cart
async function IncOrDecQuantity(
  res,
  user_id,
  id_of_cart_item,
  quantity,
  quantityInStock,
  priceToAddToTotalPrice,
  productPrice
  //no_of_items_in_cart
) {
  let updatedDoc = await Cart.updateOne(
    { user_id: user_id, "products._id": id_of_cart_item },
    {
      $inc: {
        total_price: priceToAddToTotalPrice,
        "products.$.quantity": quantity,
      },
    }
  );

  //send this data along with the res when no_of_items_in_cart is only one
  // let data = {};
  // no_of_items_in_cart == 1
  //   ? (data = {
  //       quantity: [quantity + quantityInStock],
  //       productPrice: productPrice,
  //     })
  //   : (data = {});
  //updateDoc.n is number of doc matched
  if (updatedDoc.n !== 0) {
    //updateDoc.nModified is number of doc modified
    if (updatedDoc.nModified !== 0) {
      quantity < 0
        ? res.status(200).json({ msg: "Item quantity decreased" })
        : res.status(200).json({ msg: "Item quantity increased" });
    } else {
      return res.status(404).json({ err: "Nothing modified" });
    }
  } else {
    return res.status(404).json({ err: "No Doc Matched" });
  }
}

async function addRemoveDelete(req, res, next) {
  let user_id = res.locals.payload.user_id;
  let product_id = req.params.product_id;
  let id_of_cart_item = req.params.id_of_cart_item;

  //this is the _id of object inside product.different_colored_product array
  let nested_id = req.params.nested_id;

  //this size & quantity is  of type Number in mongodb
  //required shoe size
  let size = req.params.size;

  if (size < 5 || size > 13)
    return res.status(404).json({ err: "size should be in between 5 to 13" });

  //required quantity of product
  //it can be +ve or -ve number according to whether to add or remove product from cart
  let quantity = req.params.quantity;

  //this is the no of items in cart already
  //let no_of_items_in_cart = req.params.no_of_items_in_cart;

  let OneProduct = await oneproduct(product_id, nested_id, size);

  let quantityInStock =
    OneProduct.different_colored_product.size_and_quantity[size.toString()];

  let quantityOfItemInCart = await quantityOfProductInCart(
    user_id,
    id_of_cart_item
  );

  let priceToAddToTotalPrice = quantity * OneProduct.product_price;

  if (quantity < 0) {
    if (quantityOfItemInCart + quantity < 0) {
      return res.status(404).json({ err: "can not reduce" });
    }
  }

  //check if quantity to add in cart is more than the original stock.
  if (quantity > quantityInStock) {
    return res.status(404).json({ err: `Only $quantityInStock items left` });
  }
  await IncOrDecQuantity(
    res,
    user_id,
    id_of_cart_item,
    quantity,
    quantityInStock,
    priceToAddToTotalPrice,
    OneProduct.product_price
    //no_of_items_in_cart
  );
}

//this rooute will add or remove or delete the item in the cart
//"$SERVER_IP/api/cart/addOrRemove/product_id/$productId/nested_id/$nestedId/size/$size/quantity/$quantity/id_of_cart_item/$idOfCartItem/no_of_items_in_cart/$noOfItemsInCart",

router.post(
  [
    "/addOrRemove/",
    "product_id/:product_id/",
    "nested_id/:nested_id/",
    "size/:size/",
    "quantity/:quantity/",
    "id_of_cart_item/:id_of_cart_item",
  ].join(""),

  verifyUser,
  addRemoveDelete
);

//this will delete an item from the products array of the cart
async function deleteItemFromCart(req, res, next) {
  var user_id = res.locals.payload.user_id;
  var id_of_cart_item = req.params.id_of_cart_item;

  try {
    let updatedDoc = await Cart.updateOne(
      { user_id: ObjectId(user_id) },
      { $pull: { products: { _id: ObjectId(id_of_cart_item) } } }
    );

    //updateDoc.n is number of doc matched
    if (updatedDoc.n !== 0) {
      //updateDoc.nModified is number of doc modified
      if (updatedDoc.nModified !== 0) {
        return res.status(200).json({ msg: "Item removed" });
      } else {
        return res.status(404).json({ err: "Item could not removed" });
      }
    } else {
      return res.status(404).json({ err: "No Doc Matched" });
    }
  } catch (error) {
    res.status(500).json({ err: "server problem" });
  }
}

// async function deleteItemFromCart(req, res, next) {
//   var user_id = res.locals.payload.user_id;
//   var id_of_cart_item = req.params.id_of_cart_item;

//   try {
//     let updatedDoc = await Cart.findOneAndUpdate(
//       { user_id: ObjectId(user_id) },
//       { $pull: { products: { _id: ObjectId(id_of_cart_item) } } },
//       { $inc: { total_price: {} } }
//     );
//     //console.log(updatedDoc);
//     if (updatedDoc != null) return res.status(404).json({ err: "Not found" });
//     else return res.status(200).json(updatedDoc);
//   } catch (error) {
//     res.status(500).json({ err: "server error: " });
//     throw error;
//   }
// }

//this route will delete the item from products in cart
router.delete(
  "/deleteItem/id_of_cart_item/:id_of_cart_item",
  verifyUser,
  deleteItemFromCart
);

//give cart details
async function cart(req, res) {
  var user_id = res.locals.payload.user_id;
  try {
    var cartData = await Cart.findOne({ user_id: ObjectId(user_id) });
    if (cartData == null) {
      return res.status(204).json({ err: "No items in cart" });
    }
  } catch (error) {
    res.status(500).json({ err: "server error: 1" });
    throw error;
  }

  let totalPrice = 0;
  for (let i = 0; i < cartData.products.length; i++) {
    let size = cartData.products[i].size;

    try {
      let doc = await Product.aggregate()
        .match({ _id: ObjectId(cartData.products[i].product_id) })
        .unwind("different_colored_product")
        .match({
          "different_colored_product._id": ObjectId(
            cartData.products[i].nested_id
          ),
        })
        .project({
          product_price: 1,
          ["different_colored_product." +
          "size_and_quantity." +
          [size.toString()]]: 1,
        });
      //if (doc == null) { console.log("mot found any such item") }

      let quantityInStock =
        doc[0].different_colored_product.size_and_quantity[size];

      //here if the quantity in cart is available or not is checked and updated in cart if needed
      if (quantityInStock == 0) {
        needToUpdateCart = true;
        cartData.products[i].quantity = quantityInStock;
      } else if (quantityInStock < cartData.products[i].quantity) {
        needToUpdateCart = true;
        cartData.products[i].quantity = quantityInStock;
      }

      let priceOfProduct = doc[0].product_price;
      //this is totalPrice after updating the quantity in cart
      totalPrice = totalPrice + priceOfProduct * cartData.products[i].quantity;

      //updating the price in cart
      cartData.products[i].price = priceOfProduct;
    } catch (error) {
      //res.status(500).json({ err: "server error 3" });
      throw error;
    }
  }

  //total_price is updated in cart
  cartData.total_price = totalPrice;
  return cartData;

  //cart is saved
  // var savedRes = await cartData.save();
  // if (savedRes === cartData) {
  //   return res.status(200).json(savedRes);
  // } else {
  //   return res.status(500).json({ err: "server error 2" });
  // }

  //return res.status(200).json(cartData);
}

//this route will give the cart for a specific user
router.get("/", verifyUser, async (req, res, next) => {
  try {
    //it will return cart details with  updating required fields
    var cartData = await cart(req, res);
    //cart is saved
    var savedRes = await cartData.save();
    if (savedRes === cartData) {
      return res.status(200).json(savedRes);
    } else {
      return res.status(500).json({ err: "server error 2" });
    }
  } catch (error) {
    res.status(500).json({ err: "server error" });
  }
});

//this route use for order and it will send the order id
router.get("/order", verifyUser, async (req, res, next) => {
  try {
    //it will return cart details with  updating required fields
    const cartData = await cart(req, res);
    //const user_id = res.locals.payload.user_id;

    if (cartData.total_price <= 0)
      return res.status(404).json({ err: "no item to buy" });

    var instance = new Razorpay({
      key_id: process.env.RZP_PUBLISHABLE_KEY,
      key_secret: process.env.RZP_SECRET_KEY,
    });
    var options = {
      amount: cartData.total_price * 100, // amount in the smallest currency unit
      currency: "INR",
      payment_capture: 0,
    };
    instance.orders
      .create(options)
      .then((order) => {
        return res.status(200).json(order);
      })
      .catch((error) => {
        return res.status(404).json({ err: "error" });
      });
  } catch (error) {
    res.status(500).json({ err: "server error" });
    throw error;
  }
});

//this will do the payment
router.post("/payment", verifyUser, async (req, res, next) => {
  const razorpay_order_id = req.body.razorpay_order_id;
  const razorpay_payment_id = req.body.razorpay_payment_id;
  const razorpay_signature = req.body.razorpay_signature;

  const instance = new Razorpay({
    key_id: process.env.RZP_PUBLISHABLE_KEY,
    key_secret: process.env.RZP_SECRET_KEY,
  });

  var generatedSignature = crypto
    .createHmac("SHA256", process.env.RZP_SECRET_KEY)
    .update(razorpay_order_id + "|" + razorpay_payment_id)
    .digest("hex");
  var isSignatureValid = generatedSignature == razorpay_signature;

  var order = await instance.orders.fetch(razorpay_order_id);

  //this will be true at the end if Inventory is updated after user buy some item
  //if any problem occurs in between update then it will be false
  var isInventoryQuantityUpdated = false;

  if (isSignatureValid) {
    const cartData = await cart(req, res);

    for (let i = 0; i < cartData.products.length; i++) {
      let product_id = cartData.products[i].product_id;
      let nested_id = cartData.products[i].nested_id;
      let size = cartData.products[i].size;
      let quantity = cartData.products[i].quantity;

      var product = null;
      //if  item's quantity in cart is 0 then no need for Inventory Update
      //as the user can not buy the item
      if (quantity != 0) {
        product = await Product.findOneAndUpdate(
          {
            _id: ObjectId(product_id),
            "different_colored_product._id": ObjectId(nested_id),
          },
          {
            $inc: {
              ["different_colored_product.$.size_and_quantity." +
              [size.toString()]]: -quantity,
            },
          },
          {
            new: true,
            useFindAndModify: false,
          }
        );
      }

      //if product is null that means Inventory is failed to update somehow
      if (product != null) {
        cartData.products[i].isPurchased = true;
        isInventoryQuantityUpdated = true;
      } else isInventoryQuantityUpdated = false;
    }

    if (isInventoryQuantityUpdated) {
      try {
        //cart is updated with "isPurchased" to true
        //if everything is okay
        var savedCart = await cartData.save();

        //here payment is captured
        var captured_result = await instance.payments.capture(
          razorpay_payment_id,
          order["amount"],
          order["currency"]
        );

        return res
          .status(200)
          .json({ msg: "payment successfull", cartData: savedCart });
      } catch (error) {
        res.status(404).json({
          err:
            "payment unsuccessful, you will get refund if payment was deducted",
        });
        throw error;
      }
    } else {
      return res.status(404).json({
        err:
          "payment unsuccessful, you will get refund if payment was deducted",
      });
    }
  } else
    return res.status(404).json({
      err: "payment unsuccessful, you will get refund if payment was deducted",
    });
});

module.exports = router;
