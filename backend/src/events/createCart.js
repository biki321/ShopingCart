const EventEmitter = require('events');
const Cart = require('../model/Cart');
const ObjectId = require('mongoose').Types.ObjectId;

class CreateCart extends EventEmitter { }

//this event Emitte will create acart for a userId given to it 
const createCart = new CreateCart();

createCart.on('createCart', (userId) => {
    Cart({ user_id: ObjectId(userId) }).save((err, doc) => {
        if(err){
            throw err;            
        }
        console.log(doc);
    });
});


module.exports = createCart;