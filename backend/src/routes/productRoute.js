const router = require("express").Router();
const brands = require("../model/Brand");
const Product = require("../model/Product");
const ObjectId = require("mongoose").Types.ObjectId;

function getFirstAndLastIndex(NoOfDoc, pageNo) {
  let firstIndex = pageNo * NoOfDoc - NoOfDoc;
  let LastIndex = pageNo * NoOfDoc - 1;

  return { firstIndex, LastIndex };
}

async function finalDocsToSend(ids) {
  let data = await Product.find(
    { _id: { $in: ids } },
    {
      product_name: 1,
      product_brand: 1,
      product_price: 1,
      "different_colored_product.url_for_image": 1,
      "different_colored_product._id": 1,
    }
  );
  return data;
}

//middleware for querying specfic brand
const queryDataForProductOfParticularBrand = async function (req, res, next) {
  //the brand name of sneakers will come thorugh the query parameter in url
  let brandName = req.params.brand;
  //the number of doc to send in one req
  let NoOfDoc = req.params.NoOfDoc;
  let pageNo = req.params.pageNo;

  try {
    var brand = await brands.findOne({ brand_name: brandName });

    //brand
    // {
    //     "product_id": [
    //       "5ecf5c5fc6bd53ec63af59a6",
    //       "5ecf8e7c1079933a19eb85ac"
    //     ],
    //     "_id": "5ecf5a32c6bd53ec63af59a4",
    //     "brand_name": "Addidas"
    //   }
  } catch (error) {
    throw error;
  }
  //we need the required product_ids not all at once
  //so we are getting the firstIndex, LastIndex
  let { firstIndex, LastIndex } = getFirstAndLastIndex(NoOfDoc, pageNo);

  //product_ids.length == NoOfDoc
  let product_ids = brand.product_id.slice(firstIndex, LastIndex + 1);

  let finalData = await finalDocsToSend(product_ids);

  res.locals.productsData = finalData;
  next();
};

//middleware for specific product query
function queryDataForParticularProduct(req, res, next) {
  let productid = req.params.id;

  Product.findById(productid, (err, doc) => {
    //console.log(doc["different_colored_product"][0]["size_and_quantity"]);
    if (err) {
      throw err;
    }
    res.locals.OneProduct = doc;
    next();
  });
}

async function oneColoredroductWithOneSize(product_id, nested_id, size) {
  let projection = {
    //product_name: 1,
    //product_brand: 1,
    product_price: 1,
    different_colored_product: { _id: 1 },
    //[ "different_colored_product." + "url_for_image"]: 1 ,
    ["different_colored_product." +
    "size_and_quantity." +
    [size.toString()]]: 1,
    ["different_colored_product." + "names_of_colors"]: 1,
  };

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

async function oneColoredroductWithAllSize(product_id, nested_id) {
  let projection = {
    //product_name: 1,
    //product_brand: 1,
    product_price: 1,
    different_colored_product: { _id: 1 },
    ["different_colored_product." + "size_and_quantity"]: 1,
    ["different_colored_product." + "names_of_colors"]: 1,
    ["different_colored_product." + "url_for_image"]: 1,
  };

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

async function queryDataForParticularColoredProductWithSizeQuantity(
  req,
  res,
  next
) {
  let product_id = req.params.id;
  let nested_id = req.params.nestedid;
  let size = req.params.size;

  if (size < 5 || size > 13)
    return res.status(404).json({ err: "size should be in between 5 and 13" });

  try {
    var item = await oneColoredroductWithOneSize(product_id, nested_id, size);

    item = {
      _id: item["_id"],
      product_price: item["product_price"],
      size_and_quantity: item["different_colored_product"]["size_and_quantity"],
      nested_id: item["different_colored_product"]["_id"],
      names_of_colors: item["different_colored_product"]["names_of_colors"],
    };

    res.set({ "Content-Type": "application/json" });
    res.status(200).json({ coloredProductWithOneSize: item });
  } catch (error) {
    console.log(error);
    return res.status(404).json({ err: "not found" });
  }
}

async function queryDataForParticularColoredProductWithQuantities(
  req,
  res,
  next
) {
  let product_id = req.params.id;
  let nested_id = req.params.nestedid;

  try {
    var item = await oneColoredroductWithAllSize(product_id, nested_id);

    item = {
      _id: item["_id"],
      product_price: item["product_price"],
      size_and_quantity: item["different_colored_product"]["size_and_quantity"],
      nested_id: item["different_colored_product"]["_id"],
      names_of_colors: item["different_colored_product"]["names_of_colors"],
      url_for_image: item["different_colored_product"]["url_for_image"],
    };

    res.set({ "Content-Type": "application/json" });
    res.status(200).json({ coloredProductWithAllSize: item });
  } catch (error) {
    console.log(error);
    return res.status(404).json({ err: "not found" });
  }
}

//this route will send products of a particular brand
router.get(
  "/brand/:brand/NoOfDoc/:NoOfDoc/pageNo/:pageNo",
  queryDataForProductOfParticularBrand,
  async (req, res) => {
    res.set({ "Content-Type": "application/json" });
    res.status(200).json({ products: res.locals.productsData });
  }
);

//this route will send a particular product using its id
router.get(
  "/productid/:id",
  queryDataForParticularProduct,
  async (req, res) => {
    res.set({ "Content-Type": "application/json" });
    res.status(200).json({ OneProduct: res.locals.OneProduct });
  }
);

//this router will give a particular colored product's all sizes and quantity
router.get(
  "/productid/:id/nestedid/:nestedid",
  queryDataForParticularColoredProductWithQuantities
);

//this router wil give a particular colored product with size & quanity in stock using its nested_id
router.get(
  "/productid/:id/nestedid/:nestedid/size/:size",
  queryDataForParticularColoredProductWithSizeQuantity
);

module.exports = router;
