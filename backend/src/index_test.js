// //const router = require('express').Router();
// const Cart = require('./model/Cart');
// const User = require('./model/User');
// const Product = require('./model/Product');
// const ObjectId = require('mongoose').Types.ObjectId;
// const mongoose = require('mongoose');
// const keys = require('./config/keys');
// const { func } = require('@hapi/joi')
// const dotenv = require('dotenv');
// //const verifyUser = require('../GlobalMiddlwares/verifyUser');


// mongoose.connect(keys.MongoUrl, { useNewUrlParser: true, useUnifiedTopology: true });

// var db = mongoose.connection;
// db.on('error', console.error.bind(console, 'connection error:'));
// db.once('open', function () {
//     console.log('connected');
// })

// async function name() {
//     size = 5;
//     quantity = 1;
//     var product = await Product.findOneAndUpdate(
//         {
//           _id: ObjectId("5ecf5c5fc6bd53ec63af59a6"),
//           "different_colored_product._id": ObjectId("5ed886f39ae1370138266c60"),
//         },
//         {
//           $inc: {
//             ["different_colored_product.$.size_and_quantity." +
//             [size.toString()]]: -quantity,
//           },
//         },
//         {
//           new: true,
//           useFindAndModify: false,
//         }
//       );

//       console.log(product);
//       console.log(product.different_colored_product[0].size_and_quantity["5"]);
    
// }
// name();