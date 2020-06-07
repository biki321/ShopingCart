const mongoose = require('mongoose');

let collectionName = 'orders';

const order_schema = new mongoose.Schema({
    created_on: { type: Date, require: true },

    shipping: {
        customer: { type: String, require: true },
        address: { type: String, require: true },
        city: { type: String, require: true },
        region: { type: String, require: true },
        state: { type: String, require: true },
        country: { type: String, require: true },
        delivery_notes: { type: String, require: true },
    },

    payment: {
        method: { type: String, require: true },
        transaction_id: { type: String, require: true },
    },
    products: [
        {
            product_id: { type: mongoose.Schema.Types.ObjectId, require: true },
            brand: { type: String, require: true },
            product_name: { type: String, require: true },
            size: { type: Number, require: true },
            color_name: { type: String, require: true },
            price: { type: Number, require: true },
            quantity: { type: Number, require: true },
            modified_on: { type: Date, require: true },
        }
    ],

}, {collection: collectionName});

module.exports = mongoose.model('orders', order_schema, collectionName);