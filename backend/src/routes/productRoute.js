const router = require('express').Router();
const brands = require('../model/Brand');
const products = require('../model/Product');
const ObjectId = require('mongoose').Types.ObjectId;

function getFirstAndLastIndex(NoOfDoc, pageNo) {
    let firstIndex = (pageNo * NoOfDoc) - NoOfDoc;
    let LastIndex = (pageNo * NoOfDoc) - 1;

    return { firstIndex, LastIndex };
}

async function finalDocsToSend(ids) {
    let data = await products.find({ '_id': { $in: ids } }, {
        product_name:1,
        product_brand:1,
        product_price:1,        
        'different_colored_product.url_for_image':1,
    });
    console.log(data);
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
    let product_ids = brand.product_id.slice(firstIndex, LastIndex);

    let finalData = await finalDocsToSend(product_ids);
   
    res.locals.productsData = finalData;
    next();
}

//middleware for specific product query
function queryDataForParticularProduct(req,res,next){
    let productid = req.params.id;

    products.findById(productid, (err, doc) => {
        if(err) {throw err;}
        console.log(doc);
        res.locals.OneProduct = doc;
        next();
    })
    
    

}

//this route will send products of a particular brand
router.get('/brand/:brand/NoOfDoc/:NoOfDoc/pageNo/:pageNo', queryDataForProductOfParticularBrand, async (req, res) => {
    res.set({'Content-Type': 'application/json'});
    res.status(200).json({'products': res.locals.productsData});

});

//this route will send a particular product using its id
router.get('/productid/:id' ,queryDataForParticularProduct, async (req, res) => {
    res.set({'Content-Type': 'application/json'});
    res.status(200).json({'OneProduct': res.locals.OneProduct});

});



module.exports = router;

