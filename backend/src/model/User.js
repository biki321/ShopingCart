const mongoose  = require('mongoose')

let collectionName = 'users';

const user_schema = new mongoose.Schema({
    name: {
        type : String,
        required: true,
        min: 6,
        max: 255
    },
    email: {
        type: String,
        required: true,
        max: 255,
        min: 6
    },
    password: {
        type : String,
        required: true,
        
        min: 6
    },
    date:{
        type: Date,
        default: Date.now
    }
}, {collection: collectionName});

// userSchema.pre('save', function(next){
//     var user = this;

//     if(user.isModified('password')){
//         bcrypt.genSalt(10, function(err, salt){
//             if(err) return next(err);

//             bcrypt.hash(user.password, salt, function(err, hash){
//                 if(err) return next(err);
//                 user.password = hash;
//                 next();
//             })

//         })
//     }else {next()}
// });

module.exports = mongoose.model( 'users', user_schema , collectionName);