const router = require('express').Router();
const Cart = require('../model/Cart');
const Product = require('../model/Product');
const ObjectId = require('mongoose').Types.ObjectId;
const verifyUser = require('../GlobalMiddlwares/verifyUser');

//query for product 
async function oneproduct(product_id, nested_id, size) {

    //this a object for project() in OneProduct's aggregate query
    let projection = {
        different_colored_product: { nested_id: 1 },
        product_name: 1,
        product_brand: 1,
        product_price: 1,
        [ "different_colored_product." + "url_for_image"]: 1 ,
        //quantity
        ["different_colored_product." + "size_and_quantity." + [size.toString()]]: 1,
    };

    //queryning
    let OneProduct = await Product.aggregate().unwind('different_colored_product')
        .match({ _id: ObjectId(product_id), 'different_colored_product._id': ObjectId(nested_id) })
        .project(
            projection
        );
            //console.log(OneProduct[0]);
    return OneProduct[0];
}

//this will check if the product already exist or not
//if exist just increase or decrease the quantity
async function checkIfProductAddedAlready(res, user_id, product_id, nested_id, size, quantity, priceToAddToTotalPrice) {

    try {
        var doc = await Cart.findOne({ user_id: ObjectId(user_id) },
            { 'products.product_id': 1, 'products.nested_id': 1, 'products.size': 1, });

        let arrayOfItemInCart = doc.products;

        //this obj is containing few field of the item to add to cart
        let obj = {
            'product_id': product_id,
            'nested_id': nested_id,
            'size': size
        }

        var needed_index = 0;
        for (needed_index = 0; needed_index < arrayOfItemInCart.length; needed_index++) {
            //compareTwoObj return true then both objs are equal
            //we are checking whether the item to add already in the cart or not
            //if compareTwoObj return true the it is otherwise no.
            if (compareTwoObj(obj, arrayOfItemInCart[needed_index])) {
                try {
                    var updatedDoc = await Cart.updateOne({ user_id: ObjectId(user_id) },
                        { $inc: { total_price: priceToAddToTotalPrice, ["products." + needed_index + "." + "quantity"]: quantity }, },
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

    async (err, doc) => {

    }

}

function pushProductToCart(res, OneProduct, user_id, product_id, nested_id, size, quantity) {
    Cart.findOneAndUpdate({ user_id: ObjectId(user_id) }, {
        $inc: { total_price: OneProduct.product_price },
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
            }
        }
    },
        { useFindAndModify: false },
        (err, doc) => {
            //console.log('push item: ', doc);
            if (err) { throw err; }
            else {
                return res.status(200).json({ msg: "Added To Cart" });
            }
        });
}

//this will give the quantity of an Product added in cart
async function quantityOfProductInCart(user_id, idOfCartItem) {
    try {
        let a = doc = await Cart.findOne({
            user_id: ObjectId(user_id),
            'products._id': ObjectId(idOfCartItem),
        }, {
            'products.$.quanity': 1,
        });
        return (doc.products[0].quantity);
    } catch (error) {
        throw error;
    }
}

//this will give price an item in product schema
async function priceOfAnItem(product_id) {
    try {
        let doc = await Product.findOne({ _id: ObjectId(product_id), },
            { product_price: 1 },
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
    let product_id = req.body.product_id;

    //this is the _id of object inside product.different_colored_product array
    let nested_id = req.body.nested_id;

    //this size & quantity is  of type Number in mongodb
    //required shoe size
    let size = (req.body.size);

    //required quantity of product
    //it can be +ve or -ve number according to whether to add or remove product from cart
    let quantity = req.body.quantity;

    let OneProduct = await oneproduct(product_id, nested_id, size);

    let quantityInStock = OneProduct.different_colored_product.size_and_quantity[size.toString()];

    let priceToAddToTotalPrice = quantity * OneProduct.product_price;

    if(quantity < 0){
        return res.status(404).json({err: "quantity can not be -negative"});
    }    

    //check if quantity to add in cart is more than the original stock.
    if (quantity > quantityInStock) {
        return res.status(404).json({ err: `Only $quantityInStock items left` });
    }
    else if (await checkIfProductAddedAlready(res, user_id, product_id, nested_id, size, quantity, priceToAddToTotalPrice)) { }
    else {
        pushProductToCart(res, OneProduct, user_id, product_id, nested_id, size, quantity);
    }
}

//updating the cart
//this route can handle the following features
// 1. adding to cart(also adding same product)
// 2. increasing quantity or decreasing quantity
router.post('/addToCart', verifyUser, addItemToCart);

//this will add or remove item from cart
async function IncOrDecQuantity(res, user_id, idOfCartItem, quantity, priceToAddToTotalPrice) {

    let updatedDoc = await Cart.updateOne({ user_id: user_id, 'products._id': idOfCartItem },
        { $inc: { total_price: priceToAddToTotalPrice, "products.$.quantity": quantity }, },
    );
    console.log(updatedDoc);
    //updateDoc.n is number of doc matched
    if (updatedDoc.n !== 0) {

        //updateDoc.nModified is number of doc modified
        if (updatedDoc.nModified !== 0) {
            (quantity < 0) ? res.status(200).json({ msg: "Item quantity decreased" }) : res.status(200).json({ msg: "Item quantity increased" });
        } else {
            return res.status(404).json({ err: "Nothing modified" });
        }
    } else {
        return res.status(404).json({ err: "No Doc Matched" });
    }
}

//this will delete an item from the products array of the cart
async function deleteItemFromCart(user_id, idOfCartItem) {

    let updatedDoc = await Cart.updateOne({ user_id: ObjectId(user_id) }, { $pull: { products: { _id: ObjectId(idOfCartItem) } } });

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
}

async function addRemoveDelete(req, res, next) {
    let user_id = res.locals.payload.user_id;
    let product_id = req.body.product_id;
    let idOfCartItem = req.body.idOfCartItem;

    //this is the _id of object inside product.different_colored_product array
    let nested_id = req.body.nested_id;

    //this size & quantity is  of type Number in mongodb
    //required shoe size
    let size = (req.body.size);

    //required quantity of product
    //it can be +ve or -ve number according to whether to add or remove product from cart
    let quantity = req.body.quantity;

    let OneProduct = await oneproduct(product_id, nested_id, size);
    console.log(OneProduct);

    let quantityInStock = OneProduct.different_colored_product.size_and_quantity[size.toString()];
    console.log("quantityStock:", quantityInStock);

    let quantityOfItemInCart = await quantityOfProductInCart(user_id, idOfCartItem);
    console.log("quantityInCart:", quantityOfItemInCart);

    let priceToAddToTotalPrice = quantity * OneProduct.product_price;
    console.log("pricce: ", priceToAddToTotalPrice);

    if (quantity < 0) {
        if (quantityOfItemInCart + quantity < 0) { return res.status(404).json({ err: "can not reduce" }); }
    }

    //check if quantity to add in cart is more than the original stock.
    if (quantity > quantityInStock) {
        return res.status(404).json({ err: `Only $quantityInStock items left` });
    }
    await IncOrDecQuantity(res, user_id, idOfCartItem, quantity, priceToAddToTotalPrice);
};

//this rooute will add or remove or delete the item in the cart
router.post('/addOrRemove', verifyUser, addRemoveDelete);

//this route will give the cart for a specific user
router.get('/', verifyUser ,async (req,res) => {
    let user_id = res.locals.payload.user_id;
    
    try {
        let cartData = await Cart.findOne({user_id: user_id});
        if(cartData === null ) return res.status(404).json({err: "data not found"});
        return res.status(200).json(cartData);
    } catch (error) {
        throw error;
    }
});


module.exports = router;

