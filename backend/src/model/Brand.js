const mongoose = require('mongoose');

let collectionName = 'brands';

const brand_schema = new mongoose.Schema(
    {
        brand_name: {type: String, required: true},
        product_id: [ mongoose.ObjectId ],
    }
    , {collection: collectionName}
);


module.exports = mongoose.model( 'brands', brand_schema, collectionName);
